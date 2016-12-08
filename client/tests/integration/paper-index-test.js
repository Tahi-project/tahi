// Generated by CoffeeScript 1.10.0
import Ember from 'ember';
import { test } from 'ember-qunit';
import startApp from '../helpers/start-app';
import { paperWithTask, addUserAsParticipant, addUserAsCollaborator, addNestedQuestionToTask } from '../helpers/setups';
import setupMockServer from '../helpers/mock-server';
import Factory from '../helpers/factory';
import TestHelper from 'ember-data-factory-guy/factory-guy-test-helper';;
var app, currentPaper, fakeUser, server;

app = null;

server = null;

fakeUser = null;

currentPaper = null;

module('Integration: PaperIndex', {
  afterEach: function() {
    server.restore();
    Ember.run(function() {
      return TestHelper.teardown();
    });
    return Ember.run(app, app.destroy);
  },
  beforeEach: function() {
    var collaborators, figureTask, figureTaskId, figureTaskResponse, journal, nestedQuestion, paperPayload, paperResponse, phase, records, taskPayload, tasksPayload;
    app = startApp();
    server = setupMockServer();
    fakeUser = window.currentUserData.user;
    TestHelper.mockFindAll('discussion-topic', 1);
    figureTaskId = 94139;
    records = paperWithTask('FigureTask', {
      id: figureTaskId
    });
    currentPaper = records[0], figureTask = records[1], journal = records[2], phase = records[3];
    nestedQuestion = Factory.createRecord('NestedQuestion', {
      ident: 'figures--complies'
    });
    addNestedQuestionToTask(nestedQuestion, figureTask);
    paperPayload = Factory.createPayload('paper');
    paperPayload.addRecords(records.concat([fakeUser]));
    paperResponse = paperPayload.toJSON();
    paperResponse.paper.gradual_engagement = true;
    tasksPayload = Factory.createPayload('tasks');
    tasksPayload.addRecords([figureTask]);
    taskPayload = Factory.createPayload('task');
    taskPayload.addRecords([figureTask, currentPaper, fakeUser, nestedQuestion]);
    figureTaskResponse = taskPayload.toJSON();
    collaborators = [
      {
        id: "35",
        full_name: "Aaron Baker",
        info: "testroles2, collaborator"
      }
    ];
    server.respondWith('GET', "/api/papers/" + currentPaper.shortDoi, [
      200, {
        "Content-Type": "application/json"
      }, JSON.stringify(paperResponse)
    ]);
    server.respondWith('GET', "/api/papers/" + currentPaper.shortDoi + "/tasks", [
      200, {
        "Content-Type": "application/json"
      }, JSON.stringify(tasksPayload.toJSON())
    ]);
    server.respondWith('GET', "/api/tasks/" + figureTaskId, [
      200, {
        "Content-Type": "application/json"
      }, JSON.stringify(figureTaskResponse)
    ]);
    server.respondWith('PUT', /\/api\/tasks\/\d+/, [
      204, {
        "Content-Type": "application/json"
      }, JSON.stringify({})
    ]);
    server.respondWith('GET', /\/api\/filtered_users\/users\/\d+/, [
      200, {
        "Content-Type": "application/json"
      }, JSON.stringify([])
    ]);
    server.respondWith('GET', "/api/tasks/" + figureTaskId + "/nested_questions", [
      200, {
        "Content-Type": "application/json"
      }, JSON.stringify({
        nested_questions: [nestedQuestion]
      })
    ]);
    server.respondWith('GET', "/api/tasks/" + figureTaskId + "/nested_question_answers", [
      200, {
        "Content-Type": "application/json"
      }, JSON.stringify({
        nested_question_answers: []
      })
    ]);
    return server.respondWith('GET', "/api/journals", [
      200, {
        'Content-Type': 'application/json'
      }, JSON.stringify({
        journals: []
      })
    ]);
  }
});

test('on paper.index as a participant on a task but not author of paper', function(assert) {
  var journal, litePaper, paperPayload, paperResponse, phase, records, task;
  assert.expect(1);
  records = paperWithTask('Task', {
    id: 1,
    type: 'AdHocTask',
    title: 'ReviewMe'
  });
  currentPaper = records[0], task = records[1], journal = records[2], litePaper = records[3], phase = records[4];
  paperPayload = Factory.createPayload('paper');
  paperPayload.addRecords(records.concat([fakeUser]));
  paperResponse = paperPayload.toJSON();
  paperResponse.participations = [addUserAsParticipant(task, fakeUser)];
  server.respondWith('GET', '/api/papers/' + currentPaper.shortDoi, [
    200, {
      "Content-Type": "application/json"
    }, JSON.stringify(paperResponse)
  ]);
  return visit('/papers/' + currentPaper.shortDoi).then(function() {
    return assert.ok(!!find('.task-disclosure-heading:contains("ReviewMe")').length);
  });
});

test('on paper.index as a participant on a task and author of paper', function(assert) {
  var journal, litePaper, paperPayload, paperResponse, phase, records, task;
  assert.expect(1);
  records = paperWithTask('ReviseTask', {
    id: 1,
    qualifiedType: 'TahiStandardTasks::ReviseTask'
  });
  currentPaper = records[0], task = records[1], journal = records[2], litePaper = records[3], phase = records[4];
  paperPayload = Factory.createPayload('paper');
  paperPayload.addRecords(records.concat([fakeUser]));
  paperResponse = paperPayload.toJSON();
  paperResponse.participations = [addUserAsParticipant(task, fakeUser)];
  paperResponse.collaborations = [addUserAsCollaborator(currentPaper, fakeUser)];
  server.respondWith('GET', "/api/papers/" + currentPaper.shortDoi, [
    200, {
      "Content-Type": "application/json"
    }, JSON.stringify(paperResponse)
  ]);
  return visit('/papers/' + currentPaper.shortDoi).then(function() {
    return assert.ok(!!find('.card-content:contains("Revise Task")'),
      'Participant task is displayed in the sidebar for author');
  });
});

test('visiting /paper: Author completes all metadata cards', function(assert) {
  assert.expect(3);
  visit('/papers/' + currentPaper.shortDoi).then(function() {
    return assert.ok(!find('#paper-container.sidebar-empty').length, 'The sidebar should NOT be hidden');
  }).then(function() {
    const submitButton = find('button:contains("Submit")');
    return assert.ok(!submitButton.length, 'Submit is disabled');
  }).then(function() {
    const ref = find('#paper-submission-tasks .card-content');
    let results = [];
    let i, len;
    for (i = 0, len = ref.length; i < len; i++) {
      let card = ref[i];
      click(card);
      click('.task-completed');
      results.push(click('.overlay-close-button:first'));
    }
    return results;
  });
  andThen(function() {
    const submitButton = find('button:contains("Submit")');
    assert.notOk(submitButton.hasClass('button--disabled'), 'Submit is enabled');
  });
});

test('visiting /paper: Gradual Engagement banner visible', function(assert) {
  visit('/papers/' + currentPaper.shortDoi + '?firstView=true').then(function() {
    assert.ok(find('#submission-process').length, 'The banner is visible');
  });

  click('#sp-close');

  andThen(function() {
    assert.ok(!find('#submission-process').length, 'The banner is not visible');
  });
});

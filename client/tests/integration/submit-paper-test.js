import Ember from 'ember';
import { test } from 'ember-qunit';
import startApp from '../helpers/start-app';
import setupMockServer from '../helpers/mock-server';
import { paperWithTask } from '../helpers/setups';
import Factory from '../helpers/factory';

import FactoryGuy from 'ember-data-factory-guy';
import TestHelper from 'ember-data-factory-guy/factory-guy-test-helper';

var app, paper, server;

app = null;
server = null;
paper = null;

module('Integration: Submitting Paper', {
  afterEach: function() {
    server.restore();
    Ember.run(function() {
      return TestHelper.teardown();
    });
    Ember.run(app, app.destroy);
    $.mockjax.clear();
  },
  beforeEach: function() {
    app = startApp();
    TestHelper.setup();
    server = setupMockServer();

    let journal = FactoryGuy.make('journal');
    let phase = FactoryGuy.make('phase');
    let task  = FactoryGuy.make('ad-hoc-task', {
      phase: phase,
      isMetaDataTask: true,
      isSubmissionTask: true,
      completed: true
    });
    paper = FactoryGuy.make('paper', { journal: journal, phases: [phase], tasks: [task] });

    TestHelper.mockPaperQuery(paper);

    TestHelper.mockFindAll('discussion-topic', 1);
    TestHelper.mockFindAll('journal', 0);

    Factory.createPermission('Paper', paper.id, ['submit']);
    $.mockjax({url: `/api/papers/${paper.get('shortDoi')}`, type: 'put', status: 204 });
    $.mockjax({
      url: `/api/papers/${paper.get('shortDoi')}/submit`,
      type: 'put',
      status: 200,
      responseText: {papers: []}
    });

    $.mockjax({
      url: `/api/papers/${paper.get('id')}`,
      type: 'get',
      status: 200,
      responseText: {paper : { id: paper.id }}
    });
  }
});

test('User can submit a paper', function(assert) {
  visit('/papers/' + paper.get('shortDoi'));
  click('#sidebar-submit-paper');
  click('button#review-submission-submit-button');
  andThen(function() {
    assert.ok(_.findWhere($.mockjax.mockedAjaxCalls(), {
      type: 'PUT',
      url: '/api/papers/' + paper.get('shortDoi') + '/submit'
    }), 'It posts to the server');
  });
});

test('Shows the feedback form after submitting', function(assert) {
  visit('/papers/' + paper.get('shortDoi'));
  click('#sidebar-submit-paper');
  click('button#review-submission-submit-button');
  andThen(function() {
    assert.elementFound('.feedback-form', 'The feedback form is present');
  });
});

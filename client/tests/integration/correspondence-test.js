import Ember from 'ember';
import {
  test
} from 'ember-qunit';
import startApp from '../helpers/start-app';
import setupMockServer from '../helpers/mock-server';
import Factory from '../helpers/factory';
import moduleForAcceptance from 'tahi/tests/helpers/module-for-acceptance';

import FactoryGuy from 'ember-data-factory-guy';
import TestHelper from 'ember-data-factory-guy/factory-guy-test-helper';
import formatDate from 'tahi/lib/format-date';

var app, paper, correspondence, server;

app = null;
server = null;
paper = null;
correspondence = null;

moduleForAcceptance('Integration: Correspondence', {
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

    correspondence = FactoryGuy.make('correspondence');
    paper = FactoryGuy.make('paper', {
      correspondence: [correspondence]
    });

    TestHelper.mockPaperQuery(paper);
    TestHelper.mockFindAll('journal', 0);

    Factory.createPermission('Paper', paper.id, ['submit', 'manage_workflow']);
    $.mockjax({
      url: `/api/papers/${paper.get('shortDoi')}`,
      type: 'put',
      status: 204
    });

    $.mockjax({
      type: 'GET',
      url: '/api/feature_flags.json',
      status: 200,
      responseText: {
        CORRESPONDENCE: true
      }
    });
  }
});

test('User can view a correspondence record', function(assert) {
  visit('/papers/' + paper.get('shortDoi') + '/correspondence/viewcorrespondence/1');
  return andThen(function() {
    assert.ok(find('.correspondence-overlay'), 'Correspondence Overlay');
    assert.equal(find('.correspondence-date').text().trim(), formatDate(correspondence.get('sentAt'), {}));
    assert.equal(find('.correspondence-sender').text().trim(), correspondence.get('sender'));
    assert.equal(find('.correspondence-recipient').text().trim(), correspondence.get('recipient'));
    assert.equal(find('.correspondence-subject').text().trim(), correspondence.get('subject'));
  });
});

test('User can click on a correspondence to view it\'s recodes', function(assert) {
  visit('/papers/' + paper.get('shortDoi') + '/correspondence');
  click('.correspondence1 a');
  return andThen(function() {
    assert.equal(currentURL(), '/papers/' + paper.get('shortDoi') + '/correspondence/viewcorrespondence/1');
  });
});

test('User can see external correspondence form', function(assert) {
  let doi = paper.get('shortDoi');
  visit('/papers/' + doi + '/correspondence');
  click('#add-external-correspondence');
  return andThen(function() {
    assert.equal(currentURL(), '/papers/' + doi + '/correspondence/new-external');
    assert.textPresent('.inset-form-control-text', 'Date sent');
    assert.textPresent('.inset-form-control-text', 'Time sent');
    assert.textPresent('.inset-form-control-text', 'Description');
    assert.textPresent('.inset-form-control-text', 'From');
    assert.textPresent('.inset-form-control-text', 'To');
    assert.textPresent('.inset-form-control-text', 'Subject');
    assert.textPresent('.inset-form-control-text', 'CC');
    assert.textPresent('.inset-form-control-text', 'BCC');
    assert.textPresent('.inset-form-control-text', 'Contents');
  });
});

// test('User can create external correspondence', function(assert) {
//   let doi = paper.get('shortDoi');
//   visit('/papers/' + doi + '/correspondence/new-external');
//   fillIn('.external-correspondence-date-sent', '12/23/2017');
//   fillIn('.external-correspondence-time-sent', '12:23pm');
//   fillIn('.external-correspondence-description', 'Describing purpose of correspondence');
//   fillIn('.external-correspondence-from', 'sender@example.com');
//   fillIn('.external-correspondence-to', 'recipient@example.com');
//   fillIn('.external-correspondence-subject', 'What a Correspondence!');
//   fillIn('.external-correspondence-cc', 'friend@example.com');
//   fillIn('.external-correspondence-bcc', 'onlooker@example.com');
//   fillIn('.external-correspondence-contents', 'Some content');
//   click('.external-correspondence-submit');
//   return andThen(function() {
//     assert.equal(currentURL(), '/papers/' + doi + '/correspondence/');
//   });
// });

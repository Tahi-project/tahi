/**
 * Copyright (c) 2018 Public Library of Science
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
*/

import Ember from 'ember';
import { test } from 'ember-qunit';
import startApp from 'tahi/tests/helpers/start-app';
import setupMockServer from 'tahi/tests/helpers/mock-server';
import Factory from 'tahi/tests/helpers/factory';
import moduleForAcceptance from 'tahi/tests/helpers/module-for-acceptance';

let App = null;
let server = null;

let payload = {
  'papers': [{
    'id': 4,
    'short_title': 'Testing ABC',
    'title': 'Testing ABC',
    'short_doi': 'journal.test.123',
    'paper_type': 'Research',
    'submitted_at': '2015-07-06T19:49:17.991Z',
    'related_users': [{
      'name':'Editor',
      'users':[{'id':2,'first_name':'Editor','last_name':'User'}]
    }]
  }]
};

let PTSortQuery = {
  'paper_tracker_queries':[{
    'title':'sort',
    'query':'DOI IS 1',
    'order_by':'first_submitted_at',
    'order_dir':'asc',
    'id':2
  }]
};

moduleForAcceptance('Integration: Paper Tracker', {
  afterEach: function() {
    server.restore();
    Ember.run(function() {
      App.destroy();
    });
  },

  beforeEach: function() {
    Factory.resetFactoryIds();
    App = startApp();
    server = setupMockServer();
    $.mockjax({url: '/api/paper_tracker', status: 200, responseText: payload});
    $.mockjax({url: '/api/paper_tracker_queries', status: 200, responseText: PTSortQuery});
    $.mockjax({url: '/api/admin/journals/authorization', status: 204});
    $.mockjax({url: '/api/comment_looks', status: 200, responseText: {comment_looks: []}});
    $.mockjax({url: '/api/journals', status: 200, responseText: JSON.stringify({ 'journals':[{'id':1}] })});
  }
});

test('viewing papers', function(assert) {
  let record   = payload.papers[0];
  let roleName = record.related_users[0].name;
  let lastName = record.related_users[0].users[0].last_name;
  let submittedDate = record.submittedDate;
  let firstSubmittedDate = record.firstSubmitted;

  visit('/paper_tracker');
  andThen(function() {
    assert.elementFound('.paper-tracker-title-column a[href="/papers/journal.test.123"]');
    assert.elementFound('.paper-tracker-paper-id-column a[href="/papers/journal.test.123/workflow"]');
    assert.equal(
      find('td.paper-tracker-title-column a').text().trim(),
      record.short_title,
      'Title is displayed'
    );

    assert.ok(
      find('.paper-tracker-members-column .paper-tracker-users-group')
        .text()
        .trim()
        .match(roleName),
      'Role name is displayed'
    );

    assert.ok(
      find('.paper-tracker-members-column .paper-tracker-users-group')
        .text()
        .trim()
        .match(lastName),
      'User name is displayed'
    );

    assert.ok(
      find('.paper-tracker-date-column .paper-version-date')
        .text()
        .trim()
        .match(submittedDate),
      'Version date is displayed'
    );

    assert.ok(
      find('.paper-tracker-date-column .paper-submission-date')
        .text()
        .trim()
        .match(firstSubmittedDate),
      'Submission date is displayed'
    );

    assert.elementNotFound('.paper-tracker-date-column .fa-caret-up', 'No sort is applied before using saved query');
    assert.elementNotFound('th .paper-tracker-paper-preprint-id-column', 'Preprint doi column header is hidden without flag present');
    assert.elementNotFound('td .paper-tracker-paper-preprint-id-column', 'Preprint doi column is hidden without flag present');

    click('#paper-tracker-saved-searches a');

    andThen(function() {
      assert.elementFound('.paper-tracker-date-column .fa-caret-up', 'Sort is applied after using saved query');
    });
  });
});

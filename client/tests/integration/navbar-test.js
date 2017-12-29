import Ember from 'ember';
import { test } from 'ember-qunit';
import setupMockServer from 'tahi/tests/helpers/mock-server';
import * as TestHelper from 'ember-data-factory-guy';
import Factory from 'tahi/tests/helpers/factory';
import moduleForAcceptance from 'tahi/tests/helpers/module-for-acceptance';

var respondAuthorized, respondUnauthorized, setCurrentUserAdmin;

let server = null;

moduleForAcceptance('Integration: Navbar', {
  afterEach() {
    server.restore();
  },

  beforeEach() {
    server = setupMockServer();
    TestHelper.mockFindAll('paper');
    TestHelper.mockFindAll('invitation');
    TestHelper.mockFindAll('journal');

    let dashboardResponse = {
      dashboards: [
        {
          id: 1
        }
      ]
    };

    server.respondWith('GET', '/api/dashboards', [
      200, {
        'Content-Type': 'application/json'
      }, JSON.stringify(dashboardResponse)
    ]);

  }
});

respondAuthorized = function() {
  let adminJournalsResponse = {
    admin_journals: [
      {
        id: 1,
        name: 'Test Journal of America'
      }
    ]
  };

  server.respondWith('GET', '/api/admin/journals', [
    200, {
      'Content-Type': 'application/json'
    }, JSON.stringify(adminJournalsResponse)
  ]);

  server.respondWith('GET', '/api/admin/journals/authorization', [
    204, {
      'Content-Type': 'application/html'
    }, ''
  ]);
};

respondUnauthorized = function() {
  server.respondWith('GET', '/api/admin/journals/authorization', [
    403, {
      'content-type': 'application/html'
    }, ''
  ]);
};

setCurrentUserAdmin = function(bool) {
  const store = getStore();
  const userId = getCurrentUser().get('id');

  return store.find('user', userId).then(function(currentUser) {
    return currentUser.set('admin', bool);
  });
};

test('all users can see their username', function(assert) {
  respondUnauthorized();

  visit('/').then(function() {
    setCurrentUserAdmin(false);
  });

  andThen(function() {
    assert.elementFound( '#profile-dropdown-menu-trigger:contains("Fake User")');
  });
});

test('(200 response) can see the Admin link', function(assert) {
  respondAuthorized();
  visit('/');
  andThen(function() {
    assert.elementFound('.main-navigation-item:contains("Admin")');
  });
});

test('(403 response) cannot see the Admin link', function(assert) {
  respondUnauthorized();
  visit('/');
  andThen(function() {
    assert.elementNotFound('.main-navigation-item:contains("Admin")');
  });
});

test('(200 response) with permission can see Paper Tracker link', function(assert) {
  respondAuthorized();
  Ember.run(function(){
    getStore().createRecord('journal', {
      id: 1,
      name: 'Test Journal of America'
    });

    Factory.createPermission('Journal', 1, ['view_paper_tracker']);
  });
  visit('/');
  andThen(function() {
    assert.elementFound('#nav-paper-tracker');
  });
});

test('(200 response) without permission Paper Tracker link is hidden', function(assert) {
  respondAuthorized();
  Ember.run(function(){
    var store = getStore();
    store.createRecord('journal', {
      id: 1,
      name: 'Test Journal of America'
    });
  });
  visit('/');
  andThen(function() {
    assert.elementNotFound('#nav-paper-tracker');
  });
});

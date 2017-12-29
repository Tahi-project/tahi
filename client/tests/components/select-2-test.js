// Generated by CoffeeScript 1.10.0
import Ember from 'ember';
import { test, moduleForComponent } from 'ember-qunit';
import startApp from 'tahi/tests/helpers/start-app';
import setupMockServer from 'tahi/tests/helpers/mock-server';
var appendBasicComponent, fillInDropdown, selectObjectFromDropdown, server;

server = null;

moduleForComponent('select-2', 'Unit: components/select-2', {
  unit: true,
  beforeEach: function() {
    startApp();
    server = setupMockServer();
    return server.respondWith('GET', /filtered_objects.*/, [
      200, {
        "Content-Type": "application/json"
      }, JSON.stringify([
        {
          id: 1,
          text: 'Aaron'
        }
      ])
    ]);
  },
  afterEach: function() {
    return server.restore();
  }
});

fillInDropdown = function(object) {
  keyEvent('.select2-container input', 'keydown');
  fillIn('.select2-container input', object);
  return keyEvent('.select2-container input', 'keyup');
};

selectObjectFromDropdown = function(object) {
  fillInDropdown(object);
  return click('.select2-result-selectable', 'body');
};

appendBasicComponent = function(context) {
  Ember.run((function(_this) {
    return function() {
      context.component = context.subject();
      return context.component.setProperties({
        multiSelect: true,
        source: [
          {
            id: 1,
            text: '1'
          }, {
            id: 2,
            text: '2'
          }, {
            id: 3,
            text: '3'
          }
        ]
      });
    };
  })(this));
  return context.render();
};

test("User can make a selection from the dropdown", function(assert) {
  appendBasicComponent(this);
  selectObjectFromDropdown('1');
  return andThen(function() {
    return assert.ok($('.select2-container').select2('val').contains("1"), 'Selection made');
  });
});

test("User can remove a selection from the dropdown", function(assert) {
  appendBasicComponent(this);
  this.component.setProperties({
    selectedData: [
      {
        id: 1,
        text: '1'
      }
    ]
  });
  assert.ok($('.select2-container').select2('val').contains("1"), 'Selection made');
  return click('.select2-search-choice-close').then(function() {
    return assert.ok(!$('.select2-container').select2('val').contains("1"), 'removed');
  });
});

test("Making a selection should trigger a callback to add the object", function(assert) {
  var targetObject;
  appendBasicComponent(this);
  targetObject = {
    externalAction: function(choice) {
      return assert.equal(choice.id, '1');
    }
  };
  this.component.set('selectionSelected', 'externalAction');
  this.component.set('targetObject', targetObject);
  return selectObjectFromDropdown('1');
});

test("Removing a selection should trigger a callback to remove the object", function(assert) {
  var targetObject;
  appendBasicComponent(this);
  this.component.setProperties({
    selectedData: [
      {
        id: 1,
        text: '1'
      }
    ]
  });
  targetObject = {
    externalAction: function(choice) {
      return assert.equal(choice.id, '1');
    }
  };
  this.component.set('selectionRemoved', 'externalAction');
  this.component.set('targetObject', targetObject);
  return click('.select2-search-choice-close');
});

test("Typing more than 3 letters with a remote url should make a call to said remote url", function(assert) {
  Ember.run((function(_this) {
    return function() {
      _this.component = _this.subject();
      return _this.component.setProperties({
        multiSelect: true,
        source: [],
        remoteSource: {
          url: "filtered_objects",
          dataType: "json",
          data: function(term) {
            return {
              query: term
            };
          },
          results: function(data) {
            return {
              results: data
            };
          }
        }
      });
    };
  })(this));
  this.render();
  keyEvent('.select2-container input', 'keydown');
  fillIn('.select2-container input', 'Aaron');
  keyEvent('.select2-container input', 'keyup');
  waitForElement('.select2-result-selectable');
  return andThen(function() {
    return assert.ok(find('.select2-result-selectable', 'body').length);
  });
});

test("Event stream object added should add the object to the selected objects in the dropdown", function(assert) {
  Ember.run((function(_this) {
    return function() {
      _this.component = _this.subject();
      return _this.component.setProperties({
        multiSelect: true,
        source: [
          {
            id: 1,
            text: '1'
          }, {
            id: 2,
            text: '2'
          }, {
            id: 3,
            text: '3'
          }
        ]
      });
    };
  })(this));
  this.render();
  assert.ok(!$('.select2-container').select2('val').contains("4"));
  this.component.setProperties({
    selectedData: [
      {
        id: 4,
        text: '4'
      }
    ]
  });
  return assert.ok($('.select2-container').select2('val').contains("4"));
});

test("Event stream object removed should remove the object from the selected objects in the dropdown", function(assert) {
  appendBasicComponent(this);
  this.component.setProperties({
    selectedData: [
      {
        id: 4,
        text: '4'
      }
    ]
  });
  assert.ok($('.select2-container').select2('val').contains("4"));
  this.component.setProperties({
    selectedData: []
  });
  return assert.ok(!$('.select2-container').select2('val').contains("4"));
});

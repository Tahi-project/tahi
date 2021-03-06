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

import {moduleForComponent, test} from 'ember-qunit';
import startApp from 'tahi/tests/helpers/start-app';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';
import FakeCanService from 'tahi/tests/helpers/fake-can-service';

let app;
let decision;

moduleForComponent(
  'paper-reviewer-task',
  'Integration | Components | Tasks | Paper Reviewer Task', {
    integration: true,
    setup() {
      //startApp is only here to give us access to the
      //async test helpers (fillIn, click, etc) that
      //we're used to having in the full-app acceptance tests
      this.registry.register('service:can', FakeCanService.create().allowPermission('manage_invitations', newTask).asService());
      app = startApp();
      decision = Ember.Object.create({id: 2, draft: true, invitations: []});
    },

    teardown() {
      Ember.run(app, app.destroy);
    }
  }
);


test('User can add a new reviewer after tweaking the email of an existing user',
  function(assert){
    const context = this;
    assert.expect(2);

    stubAutocompleteUser({
      id: 30,
      full_name: 'Foo Magoo',
      email: 'foo@example.com'
    }, this);

    stubStoreCreateRecord((type, properties) => {
      assert.equal(type, 'invitation', 'Creates a new invitation');
      assert.equal(
        properties.email, 'Foo Magoo <foo@example.com>',
        'Has a well-formatted email');
      let newInvite = newInvitation(properties.email);
      decision.invitations.addObject(newInvite);
      return newInvite;
    }, this);

    setupEditableTask(this);

    fillIn('#invitation-recipient', 'foo@bar.com');
    click('.auto-suggest-item');

    // Tweak the existing email, as per scenario in APERTA-6811
    andThen(function() {
      const current = context.$('#invitation-recipient').val();
      context.$('#invitation-recipient').val(current).keyup();
    });

    click('.invitation-email-entry-button');
  }
);

const newInvitation = function(email) {
  return Ember.Object.create({
    state: 'pending',
    email: email,
    body: 'Hello',
    alternates: [],
    save() { return Ember.RSVP.resolve(this); },
    invite() { return Ember.RSVP.resolve(this); }
  });
};


const newTask = function() {
  return {
    id: 2,
    title: 'Paper Reviewer',
    type: 'TahiStandardTasks::PaperReviewerTask',
    completed: false,
    isMetadataTask: false,
    isSubmissionTask: false,
    assignedToMe: false,
    invitationTemplate: {
      salutation: 'Hi!',
      body: 'You are invited!'
    },

    paper: {
      draftDecision: decision,
      previousDecisions: [],
      decisions: {
        reload() {
          // noop
        }
      }
    },

    decisions: [
      decision
    ]
  };
};

const stubStoreCreateRecord = function(fn, context) {
  context.register('service:store', Ember.Object.extend({
    createRecord: fn
  }));
};

const stubAutocompleteUser = function(returnVal, context) {
  context.register('service:restless', Ember.Service.extend({
    get() {
      return new Ember.RSVP.Promise(function(resolve) {
        resolve({users:[returnVal]});
      });
    }
  }));
  context.inject.service('restless', { as: 'restless' });
};

const template = hbs`{{paper-reviewer-task task=task can=can container=container}}`;

const setupEditableTask = function(context, task) {
  task = task || newTask();
  const can = FakeCanService.create();
  can.allowPermission('edit', task);

  context.setProperties({
    can: can,
    task: task
  });

  context.render(template);
};

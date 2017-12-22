import {
  moduleForComponent,
  test
} from 'ember-qunit';

import Ember from 'ember';
import { initialize as initTruthHelpers }  from 'tahi/initializers/truth-helpers';
import hbs from 'htmlbars-inline-precompile';
import FakeCanService from 'tahi/tests/helpers/fake-can-service';
import customAssertions from 'tahi/tests/helpers/custom-assertions';

moduleForComponent('paper-sidebar', 'Integration | Component | paper sidebar', {
  integration: true,

  beforeEach() {
    initTruthHelpers();
    customAssertions();
  }
});

test('Shows the submit button when the paper is ready to submit and the user is authorized to submit', function(assert) {
  let paper = Ember.Object.create({isReadyForSubmission: true});
  this.set('paper', paper);

  this.registry.register('service:can', FakeCanService);
  let fake = this.container.lookup('service:can');
  fake.allowPermission('submit', paper);

  let template = hbs`{{paper-sidebar paper=paper}}`;
  this.render(template);
  assert.elementFound(
    '#sidebar-submit-paper',
    'the submit button should be visible when the user is authorized'
  );
});

test('does not show the submit button if the user is unauthorized', function(assert) {
  let paper = Ember.Object.create({isReadyForSubmission: true});
  this.set('paper', paper);

  this.registry.register('service:can', FakeCanService);
  let fake = this.container.lookup('service:can');
  let template = hbs`{{paper-sidebar paper=paper}}`;
  fake.rejectPermission('submit');
  this.render(template);
  assert.elementNotFound(
    '#sidebar-submit-paper',
    'the submit button should NOT be visible when the user is unauthorized'
  );

});

const createTask = function (opts={}) {
  return Ember.Object.create(Ember.merge({
    isSidebarTask: true
  }, opts));
};

test('rendering a list of tasks', function(assert) {
  assert.expect(4);

  const paper =  Ember.Object.create({
    tasks: [
      createTask({ type: 'bulbasaur',  viewable: false }),
      createTask({ type: 'mankey', isSubmissionTask: true, assignedToMe: false, viewable: true }),
      createTask({ type: 'charmander', isSubmissionTask: true, assignedToMe: true, viewable: true }),
    ]
  });
  this.set('paper', paper);

  this.registry.register('service:can', FakeCanService);
  let fake = this.container.lookup('service:can');
  fake.allowPermission('submit', paper);

  this.render(hbs`{{paper-sidebar paper=paper}}`);


  assert.equal(this.$('.task-disclosure').length, 2, 'tasks that are not viewable are filtered out');
  assert.ok(this.$('.task-disclosure').eq(0).hasClass(`task-type-charmander`), 'charmander comes first in the sort order');
  assert.notOk(this.$('.task-disclosure-heading').eq(0).hasClass(`disabled`));

  assert.elementNotFound('.task-disclosure.task-type-bulbasaur');
});
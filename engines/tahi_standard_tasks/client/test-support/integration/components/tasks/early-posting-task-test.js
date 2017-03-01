import { test, moduleForComponent } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { manualSetup, make } from 'ember-data-factory-guy';
import { createCard } from 'tahi/tests/factories/card';
import { createAnswer } from 'tahi/tests/factories/answer';
import registerCustomAssertions from 'tahi/tests/helpers/custom-assertions';
import FakeCanService from 'tahi/tests/helpers/fake-can-service';
import Ember from 'ember';

moduleForComponent('early-posting-task', 'Integration | Component | early posting task', {
  integration: true,
  beforeEach() {
    registerCustomAssertions();
    manualSetup(this.container);
  }
});

let template = hbs`{{early-posting-task task=task}}`;

test('checkbox should be checked', function(assert) {
  this.registry.register('service:can', FakeCanService);

  let task =  make('early-posting-task');
  let fake = this.container.lookup('service:can');
  fake.allowPermission('edit', task);

  createCard('TahiStandardTasks::EarlyPostingTask');
  createAnswer(task, 'early-posting--consent', { value: true });

  this.set('task', task);
  this.render(template);

  assert.elementFound('.early-posting-consent-description', 'Renders the consent statement');
  assert.elementFound('input[type=checkbox][name="early-posting--consent"]:checked');
});

import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import sinon from 'sinon';
import Ember from 'ember';

moduleForComponent('choose-new-card', 'Integration | Component | choose new card', {
  integration: true
});

const phase = Ember.Object.create({ name: 'my phase' });
const card = Ember.Object.create({ title: 'workflow customized card', addable: true, workflow_only: true, state: 'published' });
const draftCard = Ember.Object.create({ title: 'customized draft card', addable: false });
const save = sinon.spy();
const close = sinon.spy();

test('it shows two columns containing correct cards', function(assert) {
  this.set('phase', phase);
  this.set('cards', [card, draftCard]);
  this.on('save', save);
  this.on('close', close);

  const authorJournalTaskType = Ember.Object.create({ title: 'author jtt', roleHint: 'author' });
  const staffJournalTaskType = Ember.Object.create({ title: 'staff jtt', roleHint: 'staff' });
  const journalTaskTypes = [authorJournalTaskType, staffJournalTaskType];
  this.set('journalTaskTypes', journalTaskTypes);

  this.render(hbs`
    {{choose-new-card phase=phase
                      journalTaskTypes=journalTaskTypes
                      cards=cards
                      isLoading=false
                      onSave=(action 'save')
                      close=(action 'close')}}`);

  assert.textPresent('.author-task-cards label', 'author jtt');
  assert.textPresent('.staff-task-cards label', 'staff jtt');
  assert.textPresent('.staff-task-cards label', 'workflow customized card');
});

test('it makes call to save all selected cards', function(assert) {
  this.set('phase', phase);
  this.set('cards', [card]);
  this.on('save', save);
  this.on('close', close);

  const authorJournalTaskType = Ember.Object.create({ title: 'author jtt', roleHint: 'author' });
  const staffJournalTaskType = Ember.Object.create({ title: 'staff jtt', roleHint: 'staff' });
  const journalTaskTypes = [authorJournalTaskType, staffJournalTaskType];
  this.set('journalTaskTypes', journalTaskTypes);

  this.render(hbs`
    {{choose-new-card phase=phase
                      journalTaskTypes=journalTaskTypes
                      cards=cards
                      isLoading=false
                      onSave=(action 'save')
                      close=(action 'close')}}`);

  // select checkbox on all cards to be added
  this.$("input[type='checkbox']").click();

  // click add
  this.$('button.button-primary').click();
  assert.ok(save.calledWith(phase, [authorJournalTaskType, staffJournalTaskType, card]), 'Should call save action');
});

test('Cards with titles SUBCLASSME and "Custom Card" are not displayed', function(assert) {
  this.set('phase', phase);
  this.set('cards', [card]);
  this.on('save', save);
  this.on('close', close);

  const authorJournalTaskType = Ember.Object.create({ title: 'Custom Card', roleHint: 'author' });
  const staffJournalTaskType = Ember.Object.create({ title: 'SUBCLASSME', roleHint: 'staff' });
  const journalTaskTypes = [authorJournalTaskType, staffJournalTaskType];
  this.set('journalTaskTypes', journalTaskTypes);

  this.render(hbs`
    {{choose-new-card phase=phase
                      journalTaskTypes=journalTaskTypes
                      cards=cards
                      isLoading=false
                      onSave=(action 'save')
                      close=(action 'close')}}`);

  assert.textNotPresent('.author-task-cards label', 'Custom Card');
  assert.textNotPresent('.staff-task-cards label', 'SUBCLASSME');
});

test('Only published cards are displayed', function(assert) {
  let unpublishedCard = Ember.Object.create({ title: 'Unpublished card', addable: true, workflow_only: true, state: 'draft' });

  const authorJournalTaskType = Ember.Object.create({ title: 'author jtt', roleHint: 'author' });
  const staffJournalTaskType = Ember.Object.create({ title: 'staff jtt', roleHint: 'staff' });
  const journalTaskTypes = [authorJournalTaskType, staffJournalTaskType];
  this.set('journalTaskTypes', journalTaskTypes);

  this.set('phase', phase);
  this.set('cards', [card, unpublishedCard]);
  this.on('save', save);
  this.on('close', close);

  this.render(hbs`
    {{choose-new-card phase=phase
                      journalTaskTypes=journalTaskTypes
                      cards=cards
                      isLoading=false
                      onSave=(action 'save')
                      close=(action 'close')}}`);

  assert.textNotPresent('.staff-task-cards label', 'Unpublished card');
});

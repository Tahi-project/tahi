import { test, moduleForComponent } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { manualSetup, make } from 'ember-data-factory-guy';
import registerCustomAssertions from '../helpers/custom-assertions';
import wait from 'ember-test-helpers/wait';
import { createQuestion, createQuestionWithAnswer } from 'tahi/tests/factories/nested-question';
import Ember from 'ember';

/*
 * This set of tests are more like unit tests for the nested-question component,
 * but due to the number of collaborators involved and how important it is to get
 * the actual behavior of those collaborators right (nested-question's answerForOwner, etc)
 * and how much of a pain it would be to do a `needs: [foo:bar]` statement for those things,
 * I've made this a component integration test instead.
 * */

moduleForComponent('nested-question', 'Integration | Component | nested question', {
  integration: true,
  beforeEach() { registerCustomAssertions();
    this.registry.register('pusher:main', Ember.Object.extend({socketId: 'foo'}));
    manualSetup(this.container);
  },
  afterEach() {
    $.mockjax.clear();
  }
});

let template = hbs`
{{#nested-question
  ident="foo"
  owner=task
  decision=decision
  additionalData=additionalData
  as |q|}}
  <span class="question-text">
    {{if q.question q.question.text "no question"}}
  </span>
  {{#if q.answer}}
    {{input class="answer-value" value=q.answer.value}}
  {{else}}
    <span class="no-answer"> No answer</span>
  {{/if}}
  <button {{action q.save}}>Save</button>
{{/nested-question}}
`;

test('finds its question by ident and owner', function(assert) {
  // question is null if owner is null
  this.render(template);
  assert.textPresent('.question-text', 'no question', 'question is null if owner is null');
  let task = make('ad-hoc-task');
  let question = createQuestion(task, 'foo', 'test text');

  this.set('task', task);
  assert.textPresent('.question-text', 'test text', 'yields the question');
  this.set('additionalData', 'additional test data');
  assert.equal(
    question.get('additionalData'),
    'additional test data',
    `nested-question sets the additionalData on the question it
    finds if provided`
  );

});

test('finds its answer by ident, owner, and decision', function(assert) {
  // answer is null if owner is null
  // finds answer based on decision
  this.render(template);
  assert.elementFound('.no-answer', 'answer is null if owner is null');
  let task = make('ad-hoc-task');
  createQuestionWithAnswer(
    task,
    {ident: 'foo', text: 'test text'},
    'test answer'
  );
  this.set('task', task);
  assert.equal(
    this.$('.answer-value').val(),
    'test answer',
    'it yields the answer');
});

test('saves the answer on change events', function(assert) {
  let task = make('ad-hoc-task');
  createQuestionWithAnswer(task, 'foo', 'test answer');
  this.set('task', task);
  let template = hbs`
  {{#nested-question ident="foo" owner=task as |q|}}
    {{input class="answer-value" value=q.answer.value}}
  {{/nested-question}}
  `;

  $.mockjax({url: '/api/nested_questions/1/answers/1', type: 'PUT', status: 204, responseText: ''});
  this.render(template);
  this.$('.answer-value').change();
  return wait().then(() => {
    assert.mockjaxRequestMade('/api/nested_questions/1/answers/1', 'PUT', 'it saves the new answer on change');
  });
});

test('save action validates and then saves the answer', function(assert) {
  assert.expect(3);
  let task = make('ad-hoc-task');
  createQuestionWithAnswer(task, 'foo', 'test answer');
  this.set('task', task);
  this.set('validateStub', (ident, val) => {
    assert.equal(ident, 'foo');
    assert.equal(val, 'test answer');
  });
  let template = hbs`
  {{#nested-question
    ident="foo"
    validate=(action validateStub)
    owner=task as |q|}}
    {{input class="answer-value" value=q.answer.value}}
    <button {{action q.save}}>Save</button>
  {{/nested-question}}
  `;

  $.mockjax({url: '/api/nested_questions/1/answers/1', type: 'PUT', status: 204, responseText: ''});
  this.render(template);
  this.$('button').click();
  return wait().then(() => {
    assert.mockjaxRequestMade('/api/nested_questions/1/answers/1', 'PUT', 'it saves the new answer on change');
  });
});

test(
  `if the answer is deleted, nested-question will create
  a new blank answer in the store and display it`
, function(assert) {
  // assert that there's a different answer in the template than the
  // original one
  let task = make('ad-hoc-task');
  createQuestionWithAnswer(task, 'foo', 'test answer');
  this.set('task', task);
  let template = hbs`
  {{#nested-question
    ident="foo"
    owner=task as |q|}}
    <span class="answer-is-new">{{q.answer.isNew}}</span>
    {{input class="answer-value" value=q.answer.value}}
  {{/nested-question}}
  `;
  $.mockjax({url: '/api/nested_questions/1/answers/1', type: 'DELETE', status: 204, responseText: ''});
  this.render(template);
  assert.textPresent('.answer-is-new', 'false');
  this.$('.answer-value').val('').change();
  return wait().then(() => {
    assert.mockjaxRequestMade('/api/nested_questions/1/answers/1', 'DELETE', 'it deletes the answer');
    assert.textPresent('.answer-is-new', 'true');
  });

});

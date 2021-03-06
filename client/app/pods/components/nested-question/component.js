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
import { timeout, task as concurrencyTask } from 'ember-concurrency';

const { Component, computed } = Ember;

export default Component.extend({
  inputClassNames: null,
  debouncePeriod: 500, // in ms
  disabled: false,
  noResponseText: '[No response]',
  additionalData: null,

  textClassNames: ['question-text'],

  owner: null,
  question: computed('owner', 'ident', 'additionalData', function() {
    let owner = this.get('owner');
    if (!owner) return null;
    let ident=this.get('ident');
    Ember.assert("Expecting to be given an ident, but wasn't", this.get('ident'));
    let question = owner.findQuestion(ident);
    Ember.assert(`Expecting to find question matching ident '${ident}' but
      didn't. Make sure the owner's questions are loaded before this
      initializer is called.`,
      question
    );

    if (this.get('additionalData')) {
      question.set('additionalData', this.get('additionalData'));
    }

    return question;
  }),

  _cachedAnswer: null,
  answer: computed('owner', 'question', '_cachedAnswer.isDeleted', function() {
    let cachedAnswer = this.get('_cachedAnswer');
    if (cachedAnswer && !cachedAnswer.get('isDeleted')) { return cachedAnswer; }

    let newAnswer = this.lookupAnswer();
    this.set('_cachedAnswer', newAnswer);
    return newAnswer;
  }),

  lookupAnswer() {
    let question = this.get('question');
    if (!question) { return null; }

    return question.answerForOwner(this.get('owner'));
  },

  resetAnswer() {
    this.set('_cachedAnswer', this.lookupAnswer());
  },

  // displayQuestionText and displayQuestionAsPlaceholder are set externally.
  // internally we should read shouldDisplayQuestionText
  displayQuestionAsPlaceholder: false,
  displayQuestionText: true,

  shouldDisplayQuestionText: computed('displayQuestionText', 'displayQuestionAsPlaceholder', function() {
    return !this.get('displayQuestionAsPlaceholder') && this.get('displayQuestionText');
  }).readOnly(),

  // placeholder is passed in, but all internal stuff should use placeholderText
  placeholder: '',
  placeholderText: computed('displayQuestionAsPlaceholder', 'questionText', 'placeholder', function() {
    if (this.get('displayQuestionAsPlaceholder')) {
      return this.get('questionText');
    } else {
      return this.get('placeholder');
    }
  }).readOnly(),

  questionText: computed.reads('question.text'),

  errorPresent: computed('errors', function() {
    return !Ember.isEmpty(this.get('errors'));
  }),

  change(){
    this.save();
  },

  save(){
    return this.get('_debouncedAndThrottledSave').perform();
  },

  _debouncedAndThrottledSave: concurrencyTask(function * () {
    if(this.attrs.validate) {
      this.attrs.validate(this.get('ident'), this.get('answer.value'));
    }
    yield timeout(this.get('debouncePeriod'));
    return this.get('_throttledSave').perform();
  }).restartable(),

  _throttledSave: concurrencyTask(function * () {
    return yield this._saveAnswer(this.get('answer'));
  }).keepLatest(),

  _saveAnswer(answer){
    if(answer.get('owner.isNew') || answer.get('owner.cancelPendingAnswerSaves')){
      // no-op
    } else if(answer.get('wasAnswered')){
      // Handle the edge case where an answer was deleted in the UI, and two inputs get posted
      // before Ember sets the answer ID. This would create two answer records associated with
      // the nested question, and cause unexpected data changes in the view.
      if (answer.get('isSaving')) {
        answer.set('cachedSave', answer.get('value'));
      } else {
        return answer.save().then((session) => {
          let cachedSave = answer.get('cachedSave');
          if (cachedSave) {
            session.set('data.value', cachedSave);
            answer.set('value', cachedSave);
            answer.set('cachedSave', null);
            answer.save();
          }
        });
      }
    } else {
      return answer.destroyRecord().then(() => this.resetAnswer());
    }
  },

  actions: {
    save() {
      this.save();
    }
  }
});

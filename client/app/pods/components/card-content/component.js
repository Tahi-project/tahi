// This component is a thin layer around the card-content components;
// it takes a card-content and displays the right component to view
// that in a task. To change which component goes with which content
// type, edit client/lib/card-content-types.js

import Ember from 'ember';
import CardContentTypes from 'tahi/lib/card-content-types';
import { PropTypes } from 'ember-prop-types';
import { timeout, task as concurrencyTask } from 'ember-concurrency';

export default Ember.Component.extend({
  templateName: Ember.computed('content.contentType', function() {
    let type = this.get('content.contentType');
    let name = CardContentTypes.forType(type);
    return name;
  }),

  propTypes: {
    content: PropTypes.EmberObject.isRequired,
    disabled: PropTypes.bool,
    owner: PropTypes.EmberObject.isRequired,
    preview: PropTypes.bool.isRequired,
    hasAnswerContainer: PropTypes.bool,
    answerChanged: PropTypes.any
  },

  keepAnswerContainer: Ember.computed('content', function(){
    return !this.get('content.overrideAnswerContainer') && this.get('hasAnswerContainer');
  }),

  getDefaultProps() {
    return {
      preview: false,
      hasAnswerContainer: true
    };
  },

  tagName: '',
  debouncePeriod: 200, // in ms

  init() {
    this._super(...arguments);
    Ember.assert(
      `you must pass an owner to card-content`,
      Ember.isPresent(this.get('owner'))
    );
    Ember.assert(
      'this component must have content with a contentType',
      this.get('content.contentType')
    );
  },

  answer: Ember.computed('content', 'owner', function() {
    let answer = this.get('content').answerForOwner(this.get('owner'));
    // if in preview mode set default values on the answer
    if(this.get('preview') && answer) {
      this.prepareAnswerForPreview(answer);
    }
    return answer;
  }),

  _debouncedSave: concurrencyTask(function*() {
    yield timeout(this.get('debouncePeriod'));
    let answer = this.get('answer');
    return yield answer.save();
  }).restartable(),

  actions: {
    updateAnswer(newVal) {
      this.set('answer.value', newVal);
      if (this.get('answerChanged')) {
        this.get('answerChanged')(this.get('answer'));
      }
      if (this.get('preview')) {
        return;
      }
      this.get('_debouncedSave').perform();
    },

    updateAnnotation(e) {
      this.set('answer.annotation', e.target.value);
      if (!this.get('preview')) {
        this.get('_debouncedSave').perform();
      }
    }
  },

  // This sets default values on the client side and is used
  // when the component is being previewed. debounce doesnt
  // persist answers while in preview mode.
  prepareAnswerForPreview(answer){
    let defaultAnswer = this.get('content.defaultAnswerValue');
    let valueType = this.get('content.valueType');
    // some value types need to be mapped
    switch(valueType) {
    case 'boolean':
      answer.set('value', defaultAnswer === 'true' ? true: false);
      break;
    default:
      answer.set('value', defaultAnswer);
    }
    return answer;
  }
});

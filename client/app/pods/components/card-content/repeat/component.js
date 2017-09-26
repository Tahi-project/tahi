import Ember from 'ember';
import { PropTypes } from 'ember-prop-types';

export default Ember.Component.extend({
  classNames: ['card-content-repeat'],
  tagName: '',
  store: Ember.inject.service(),
  min: Ember.computed.readOnly('content.min'),
  max: Ember.computed.readOnly('content.max'),
  addButtonLabel: Ember.computed.readOnly('content.addButtonLabel'),
  deleteButtonLabel: Ember.computed.readOnly('content.deleteButtonLabel'),

  propTypes: {
    content: PropTypes.EmberObject.isRequired,
    disabled: PropTypes.bool,
    owner: PropTypes.EmberObject.isRequired,
    preview: PropTypes.bool,
    repetition: PropTypes.EmberObject
  },

  init() {
    this._super(...arguments);

    Ember.run.once(this, 'addMinimumRepetitions');
  },

  addMinimumRepetitions() {
    let toAdd =  this.get('min') - this.get('repetitions.length');
    for(let i = 0; i < toAdd; i++) {
      this.buildRepetition();
    }
  },

  repetitions: Ember.computed('content.repetitions.[]', 'repetition', function() {
    let parent = this.get('repetition');
    return this.get('content.repetitions').filter(function(rep) {
      if(parent) {
        return rep.get('parent') === parent;
      } else {
        return !rep.get('parent');
      }
    });
  }),

  addLabelText: Ember.computed('content', function() {
    let label = this.get('addButtonLabel');
    return label ? label : 'Add';
  }),

  deleteLabelText: Ember.computed('content', function() {
    let label = this.get('deleteButtonLabel');
    return label ? label : 'Delete';
  }),

  buildRepetition() {
    return this.get('store').createRecord('repetition', { cardContent: this.get('content'), parent: this.get('repetition') });
  },

  actions: {
    addRepetition() {
      let repetition = this.buildRepetition();

      if(!this.get('preview')) {
        repetition.save();
      }
    },

    deleteRepetition(repetition) {
      repetition.cascadingDestroy();
    },
  }
});

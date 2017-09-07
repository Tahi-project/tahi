import Ember from 'ember';

// This validation works for our pre-populated letter templates
// but we might want to change this up when users are allowed to create
// new templates.

export default Ember.Component.extend({
  store: Ember.inject.service(),
  routing: Ember.inject.service('-routing'),
  disabled: Ember.computed('template.subject', 'template.body', function() {
    return !this.get('template.subject') || !this.get('template.body');
  }),
  unsaved: true,
  subjectErrors: [],
  bodyErrors: [],
  subjectErrorPresent: Ember.computed.notEmpty('subjectErrors'),
  bodyErrorPresent: Ember.computed.notEmpty('bodyErrors'),
  actions: {
    save: function() {
      if (this.get('disabled') || this.get('template.isSaving')) {
        this.set('unsaved', false);
      } else {
        this.get('template').save()
          .then(() => {
            this.get('routing').transitionTo('admin.journals.emailtemplates', this.get('template.journal.id'));
          })
          .catch(error => {
            let subjectError = error.errors.filter((e) => e.source.pointer.includes('subject'));
            let bodyError = error.errors.filter((e) => e.source.pointer.includes('body'));
            if (subjectError.length) {
              this.set('subjectErrors', subjectError.map(s => s.detail));
            }
            if (bodyError.length) {
              this.set('bodyErrors', bodyError.map(s => s.detail));
            }
          });
      }
    }
  }
});


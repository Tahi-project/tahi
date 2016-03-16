import Ember from 'ember';
import TaskComponent from 'tahi/pods/components/task-base/component';
import ObjectProxyWithErrors from 'tahi/models/object-proxy-with-validation-errors';

const {
  computed
} = Ember;

const acknowledgementIdents = [
  'authors--persons_agreed_to_be_named',
  'authors--authors_confirm_icmje_criteria',
  'authors--authors_agree_to_submission',
];

const taskValidations = {
  'acknowledgements': [{
    type: 'equality',
    message: 'Please acknowledge the statements below',
    validation() {
      const author = this.get('task');

      return _.every(acknowledgementIdents, (ident) => {
        return author.answerForQuestion(ident).get('value');
      });
    }
  }]
};

export default TaskComponent.extend({
  validations: taskValidations,
  newAuthorFormVisible: false,
  newGroupAuthorFormVisible: false,

  validateData() {
    this.validateAll();
    const objs = this.get('sortedAuthorsWithErrors');
    objs.invoke('validateAll');

    const taskErrors    = this.validationErrorsPresent();
    const authorsErrors = ObjectProxyWithErrors.errorsPresentInCollection(objs);
    let newAuthorErrors = false;

    if(this.get('newAuthorFormVisible')) {
      const newAuthor= this.get('newAuthor');
      newAuthor.validateAll();

      if(newAuthor.validationErrorsPresent()) {
        newAuthorErrors = true;
      }
    }

    if(taskErrors || authorsErrors || newAuthorErrors) {
      this.set('validationErrors.completed', 'Please fix all errors');
    }
  },

  authors: computed('task.authors.@each.paper', function() {
    return this.get('task.authors').filterBy('paper', this.get('paper'));
  }),

  sortedAuthorsWithErrors: computed('task.allAuthors.[]', function() {
    return this.get('task.allAuthors').map(function(a) {
      return ObjectProxyWithErrors.create({
        object: a,
        validations: a.validations
      });
    });
  }),

  shiftAuthorPositions(author, newPosition) {
    author.set('position', newPosition).save();
  },

  actions: {
    toggleGroupAuthorForm() {
      this.toggleProperty('newGroupAuthorFormVisible');
    },

    toggleAuthorForm() {
      this.toggleProperty('newAuthorFormVisible');
    },

    saveNewAuthorSuccess() {
      this.set('newAuthorFormVisible', false);
    },

    saveNewGroupAuthorSuccess() {
      this.set('newGroupAuthorFormVisible', false);
    },

    changeAuthorPosition(author, newPosition) {
      this.shiftAuthorPositions(author, newPosition);
    },

    removeAuthor(author) {
      author.destroyRecord();
    },

    validateField(model, key, value) {
      model.validate(key, value);
    }
  }
});

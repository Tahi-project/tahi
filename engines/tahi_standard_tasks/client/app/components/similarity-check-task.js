import TaskComponent from 'tahi/pods/components/task-base/component';
import Ember from 'ember';

export default TaskComponent.extend({
  init: function() {
    this._super(...arguments);
    this.get('task.paper.similarityChecks');
  },
  flash: Ember.inject.service(),
  restless: Ember.inject.service(),
  classNames: ['similarity-check-task'],
  sortProps: ['id:desc'],
  latestVersionedText: Ember.computed.alias('task.paper.latestVersionedText'),
  latestVersionSimilarityChecks: Ember.computed.alias('latestVersionedText.similarityChecks.[]'),
  latestVersionSuccessfulChecks: Ember.computed.filterBy('latestVersionSimilarityChecks', 'state', 'report_complete'),
  latestVersionHasSuccessfulChecks: Ember.computed.notEmpty('latestVersionSuccessfulChecks.[]'),
  latestVersionFailedChecks: Ember.computed.filterBy('latestVersionSimilarityChecks', 'state', 'failed'),
  latestVersionPrimaryFailedChecks: Ember.computed.filterBy('latestVersionFailedChecks', 'dismissed', false),
  sortedChecks: Ember.computed.sort('latestVersionSimilarityChecks', 'sortProps'),
  latestVersionHasChecks: Ember.computed.notEmpty('latestVersionedText.similarityChecks.[]'),
  automatedReportsDisabled: Ember.computed.alias('task.paper.manuallySimilarityChecked'),
  automatedReportsOff: Ember.computed.equal('task.currentSettingValue', 'off'),

  versionedTextDescriptor: Ember.computed('task.currentSettingValue', function() {
    const setting = this.get('task.currentSettingValue');
    if (setting === 'at_first_full_submission') {
      return 'first full submission';
    } else if (setting === 'after_first_major_revise_decision') {
      return 'first major revision';
    } else if (setting === 'after_first_minor_revise_decision') {
      return 'first minor revision';
    } else if (setting === 'after_any_first_revise_decision') {
      return 'any first revision';
    }
  }),

  disableReports: Ember.computed('latestVersionHasChecks', 'automatedReportsDisabled', function() {
    //dont ever disable disable manual generation button if auto reports are disabled.
    return this.get('latestVersionHasChecks') &&  !this.get('automatedReportsDisabled');
  }),

  actions: {
    confirmGenerateReport() {
      this.set('confirmVisible', true);
    },
    cancel() {
      this.set('confirmVisible', false);
    },
    generateReport() {
      this.set('confirmVisible', false);
      const paper = this.get('task.paper');
      paper.get('versionedTexts').then(() => {
        const similarityCheck = this.get('store').createRecord('similarity-check', {
          paper: paper,
          versionedText: this.get('latestVersionedText')
        });
        similarityCheck.save();
      });
      // force paper to recalculate if auto reports are disabled
      paper.reload();
    },
    dismissMessage(message) {
      message.set('dismissed', true);
      message.save();
    }
  }
});

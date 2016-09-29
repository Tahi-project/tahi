import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'span',
  classNames: ['text-diff'],

  // This is the text of the version being viewed (left dropdown)
  viewingText: null,

  // This is the text of the version we're comparing with (right dropdown)
  comparisonText: null,

  // This is the default if nothing else is set
  default: '',

  diffManuscript: false,

  chunks: Ember.computed('comparisonText', 'viewingText', 'diffManuscript', function() {
    if (this.get('diffManuscript')) {
      return this.charDiff();
    }

    return this.diff();
  }),

  diff() {
    return JsDiff.diffSentences(
      String(this.get('comparisonText') || this.get('default')),
      String(this.get('viewingText') || this.get('default'))
    );
  },

  charDiff() {
    return JsDiff.diffWordsWithSpace(
      String(this.get('comparisonText') || this.get('default')),
      String(this.get('viewingText') || this.get('default'))
    );
  }
});

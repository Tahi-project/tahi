import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  paper: DS.belongsTo('paper', {
    async: true
  }),
  source: DS.belongsTo('snapshottable', {
    async: true,
    inverse: 'snapshots',
    polymorphic:  true
  }),
  // We have sourceId here to allow comparing sources without
  // *fetching* sources. *sigh* ember data.
  sourceId: DS.attr('string'),
  majorVersion: DS.attr('number'),
  minorVersion: DS.attr('number'),
  contents: DS.attr(),
  sanitizedContents: DS.attr(),
  createdAt: DS.attr('date'),
  fullVersion: Ember.computed('majorVersion', 'minorVersion', function() {
    return `${this.get('majorVersion')}.${this.get('minorVersion')}`;
  }),
  fileType: DS.attr('string'),

  createdAtOrNow: Ember.computed(
    'createdAt',
    function() {
      return (this.get('createdAt') || new Date());
    }),

  versionString: Ember.computed(
    'majorVersion', 'minorVersion',
    function() {
      if (Ember.isEmpty(this.get('majorVersion'))) {
        return '(draft)';
      } else {
        return `R${this.get('majorVersion')}.${this.get('minorVersion')}`;
      }
    }),

  hasDiff(otherSnapshot) {
    if (!otherSnapshot) {
      return true;
    }

    let string1 = JSON.stringify(this.get('sanitizedContents'));
    if(otherSnapshot){
      let string2 = JSON.stringify(otherSnapshot.get('sanitizedContents'));
      return string1 !== string2;
    } else {
      return false;
    }
  }
});
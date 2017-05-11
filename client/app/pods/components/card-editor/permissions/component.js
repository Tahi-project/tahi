import Ember from 'ember';
import { PropTypes } from 'ember-prop-types';

export default Ember.Component.extend({
  propTypes: {
    card: PropTypes.EmberObject.isRequired,
    turnOnPermission: PropTypes.func.isRequired,
    turnOffPermission: PropTypes.func.isRequired
  },
  roleSort: ['name:asc'],
  roles: Ember.computed.sort('card.journal.adminJournalRoles', 'roleSort')
});

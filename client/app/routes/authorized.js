import Ember from 'ember';

export default Ember.Route.extend({
  can: Ember.inject.service('can'),
  restless: Ember.inject.service('restless'),

  handleUnauthorizedRequest(transition) {
    transition.abort();
    this.transitionTo('dashboard').then(()=> {
      this.flash.displayRouteLevelMessage('error', "You don't have access to that content");
    });
  },

  actions: {
    error(response, transition) {
      if (!response) {
        this.handleUnauthorizedRequest(transition);
      }
      switch (response.status) {
        case 403:
          this.handleUnauthorizedRequest(transition);
      }
      if (response.errors[0].status == 403) {
        this.handleUnauthorizedRequest(transition);
      }
      return true;
    },
    _pusherEventsId() {
      // needed for the `wire` and `unwire` method to think we have `ember-pusher/bindings` mixed in
      return this.toString();
    }
  }
});

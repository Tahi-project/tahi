import Ember from 'ember';
import AnimateElement from 'tahi/mixins/routes/animate-element';
import RESTless from 'tahi/services/rest-less';

export default Ember.Route.extend(AnimateElement, {
  setupController: function(controller, model) {
    controller.set('model', model);
    if (this.currentUser) {
      // subscribe to user and system channels
      let userChannelName = `private-user@${ this.currentUser.get('id') }`;
      let pusher = this.get('pusher');
      pusher.wire(this, userChannelName, ["created", "updated"]);
      pusher.wire(this, "system", ["destroyed"]);

      RESTless.authorize(controller, '/api/admin/journals/authorization', 'canViewAdminLinks');
      RESTless.authorize(controller, '/api/user_flows/authorization', 'canViewFlowManagerLink');
    }
  },

  actions: {
    willTransition(transition) {
      let appController, currentRouteController;
      appController = this.controllerFor('application');
      currentRouteController = this.controllerFor(appController.get('currentRouteName'));
      if (currentRouteController.get('isUploading')) {
        if (confirm('You are uploading. Are you sure you want abort uploading?')) {
          currentRouteController.send('cancelUploads');
        } else {
          transition.abort();
          return;
        }
      }
      return appController.send('hideNavigation');
    },

    error(response, transition) {
      let oldState  = transition.router.oldState;
      let lastRoute = oldState.handlerInfos.get('lastObject.name');
      let transitionMsg;

      if(oldState) {
        transitionMsg = `Error in transition from ${lastRoute} to #{transition.targetName}`;
      } else {
        transitionMsg = `Error in transition into ${transition.targetName}`;
      }

      this.logError(transitionMsg + '\n' + response.message + '\n' + response.stack + '\n');

      transition.abort();
    },

    closeOverlay() {
      this.flash.clearAllMessages();
      this.disconnectOutlet({
        outlet: 'overlay',
        parentView: 'application'
      });
    },

    closeAction() {
      this.send('closeOverlay');
    },

    addPaperToEventStream(paper) {
      this.eventStream.addEventListener(paper.get('eventName'));
    },

    editableDidChange() { return null; },

    feedback() {
      this.render('overlays/feedback', {
        into: 'application',
        outlet: 'overlay',
        controller: 'overlays/feedback'
      });
    },

    created(payload) {
      console.log("created!", payload);
    },

    updated(payload) {
      console.log("updated!", payload);
    },

    destroyed(payload) {
      console.log("destroyed!", payload);
    },
  },

  _pusherEventsId() {
    // needed for the `wire` and `unwire` method to think we have `ember-pusher/bindings` mixed in
    return this.toString()
  }
});

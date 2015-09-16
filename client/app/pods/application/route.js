import Ember from 'ember';
import AnimateOverlay from 'tahi/mixins/animate-overlay';
import RESTless from 'tahi/services/rest-less';
import Utils from 'tahi/services/utils';

export default Ember.Route.extend(AnimateOverlay, {
  setupController(controller, model) {
    controller.set('model', model);
    if (this.currentUser) {
      // subscribe to user and system channels
      let userChannelName = `private-user@${ this.currentUser.get('id') }`;
      let pusher = this.get('pusher');
      pusher.wire(this, userChannelName, ["created", "updated", "destroyed"]);
      pusher.wire(this, "system", ["destroyed"]);

      RESTless.authorize(controller, '/api/admin/journals/authorization', 'canViewAdminLinks');
      RESTless.authorize(controller, '/api/user_flows/authorization', 'canViewFlowManagerLink');
    }
  },

  applicationSerializer: Ember.computed(function() {
    return this.get('container').lookup("serializer:application");
  }),

  cleanupAncillaryViews() {
    this.controllerFor('application').send('hideNavigation');

    this.animateOverlayOut().then(()=> {
      this.controllerFor('application').set('showOverlay', false);
    });
  },

  actions: {
    willTransition(transition) {
      let appController = this.controllerFor('application');
      let currentRouteController = this.controllerFor(appController.get('currentRouteName'));
      if (currentRouteController.get('isUploading')) {
        if (confirm('You are uploading. Are you sure you want abort uploading?')) {
          currentRouteController.send('cancelUploads');
        } else {
          transition.abort();
          return;
        }
      }

      this.cleanupAncillaryViews();
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

    openOverlay(options) {
      Ember.assert(
        'You must pass a template name to `openOverlay`',
        options.template
      );
      if(Ember.isEmpty(options.into))   { options.into   = 'application'; }
      if(Ember.isEmpty(options.outlet)) { options.outlet = 'overlay'; }

      this.controllerFor('application').set('showOverlay', true);
      this.render(options.template, options);
    },

    closeOverlay() {
      this.flash.clearAllMessages();
      this.cleanupAncillaryViews();
    },

    closeAction() {
      this.send('closeOverlay');
    },

    feedback() {
      this.controllerFor('overlays/feedback').set('feedbackSubmitted', false);

      this.send('openOverlay', {
        template: 'overlays/feedback',
        controller: 'overlays/feedback'
      });
    },

    created(payload) {
      let description = "Pusher: created";
      Utils.debug(description, payload);
      this.store.pushPayload(payload);
    },

    updated(payload) {
      let description = "Pusher: updated";
      Utils.debug(description, payload);
      this.store.pushPayload(payload);
    },

    destroyed(payload) {
      let description = "Pusher: destroyed";
      Utils.debug(description, payload);
      let type = this.get('applicationSerializer').modelNameFromPayloadKey(payload.type);
      payload.ids.forEach((id) => {
        let record;
        if (type === "task") {
          record = this.store.findTask(id);
        } else {
          record = this.store.getById(type, id);
        }
        if (record) {
          record.unloadRecord();
        }
      });
    }
  },

  _pusherEventsId() {
    // needed for the `wire` and `unwire` method to think we have `ember-pusher/bindings` mixed in
    return this.toString();
  }
});

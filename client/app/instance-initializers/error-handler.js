import Ember from 'ember';
import ENV from 'tahi/config/environment';

export default {
  name: 'errorHandler',

  initialize(instance) {
    let flash    = instance.container.lookup('service:flash');
    let logError = instance.container.lookup('logError:main');
    let bugsnagService = instance.lookup('service:bugsnag');

    // The global error handler for internal ember errors.
    // In production and staging send the error to bugsnag.
    // In development show the error in the flash, log to
    // the console and throw again.
    if (!Ember.testing) {
      Ember.onerror = function(error) {
        if (ENV.environment !== 'development') {
          if (typeof Bugsnag !== 'undefined' && Bugsnag && Bugsnag.notifyException) {
            if (error.errors && error.errors.length) {
              let meta = {
                errorInfo: {'error.errors': error.errors}
              };

              Bugsnag.notifyException(error, 'Uncaught Ember Error', meta);
            } else {
              Bugsnag.notifyException(error, 'Uncaught Ember Error');
            }
          }
        } else {
          flash.displayRouteLevelMessage('error', error);
          logError(error);
          throw error;
        }
      };
    }

    // Server response error handler
    $(document).ajaxError(function(event, jqXHR, ajaxSettings, thrownError) {
      let type       = ajaxSettings.type;
      let url        = ajaxSettings.url;
      let status     = jqXHR.status;
      let statusText = jqXHR.statusText;

      // don't blow up if xhr was aborted
      if (statusText === 'abort') { return; }
      // don't blow up in case of a 403 from rails
      if (status === 403) { return; }
      // a 404 could happen when pusher reloads, so either handle
      // it at the call site or let ember data pick it up.
      if (status === 404) { return; }
      // ember data should handle these errors.
      if (status === 422) { return; }
      // session invalid, redirect to sign in
      if (status === 401) { return document.location.href = '/users/sign_in'; }
      // health service handles its own alert messages, so we just return
      if (status === 500 && url.match(/\/health/) ) { return; }

      let msg = `Error with ${type} request to ${url}. Server returned ${status}: ${statusText}. ${thrownError}`;
      bugsnagService.notifyException(thrownError, msg);
      // TODO: Remove this condidition when we switch to run loop respecting http mocks
      if (!Ember.testing) { flash.displayRouteLevelMessage('error', msg); }
    });
  }
};

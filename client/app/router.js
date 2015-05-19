import Ember from 'ember';
import config from './config/environment';

let Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('dashboard', { path: '/' }, function() {});

  this.route('flow_manager');

  this.resource('paper', { path: '/papers/:paper_id' }, function() {
    this.route('edit');
    this.route('workflow');
    this.route('task', { path: '/tasks' }, function() {
      this.route('index', { path: '/:task_id' });
    });
  });

  this.route('profile', { path: '/profile' });

  this.resource('admin', function() {
    this.resource('admin.journals', { path: '/journals' }, function() {});

    this.resource('admin.journal', { path: '/journals/:journal_id' }, function() {
      this.resource('admin.journal.manuscript_manager_template', { path: '/manuscript_manager_templates' }, function() {
        this.route('new');
        this.route('edit', { path: '/:manuscript_manager_template_id/edit' });
      });

      this.route('flow_manager', { path: '/roles/:role_id/flow_manager' });
    });
  });

  this.route('styleguide');
});

export default Router;

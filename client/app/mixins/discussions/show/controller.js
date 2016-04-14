import Ember from 'ember';
import DiscussionsRoutePathsMixin from 'tahi/mixins/discussions/route-paths';
import getOwner from 'ember-getowner-polyfill';

export default Ember.Mixin.create(DiscussionsRoutePathsMixin, {
  participants: Ember.computed('model.discussionParticipants.@each.user', function() {
    return this.get('model.discussionParticipants').mapBy('user');
  }),

  replySort: ['createdAt:desc'],
  sortedReplies: Ember.computed.sort('model.discussionReplies', 'replySort'),

  getStore() {
    return getOwner(this).lookup('store:main');
  },

  actions: {
    saveTopic() {
      this.get('model').save();
    },

    postReply(body) {
      this.store.createRecord('discussion-reply', {
        discussionTopic: this.get('model'),
        replier: this.get('currentUser'),
        body: body
      }).save();
    },

    removeParticipantByUserId(userId) {
      this.get('model.discussionParticipants')
          .findBy('user.id', userId)
          .destroyRecord();
    },

    saveNewParticipant(newParticipant, availableParticipants) {
      let participant = availableParticipants.findBy('id', newParticipant.id);
      let user = this.store.findOrPush('user', participant);

      this.store.createRecord('discussion-participant', {
        discussionTopic: this.get('model'),
        user: user,
      }).save();
    }
  }
});

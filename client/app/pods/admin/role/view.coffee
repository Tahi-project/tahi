`import Ember from 'ember'`

RoleView = Ember.View.extend
  classNameBindings: [':admin-role', 'isEditing:is-editing:not-editing']

  isNew: Ember.computed.alias('controller.content.isNew')
  isEditing: Ember.computed.alias('controller.isEditing')

  _animateInIfNewRole: (->
    @$().hide().fadeIn(250) if @get('isNew')
  ).on('didInsertElement')

  focusObserver: (->
    if @get('controller.isEditing')
      Ember.run.schedule 'afterRender', =>
        @$('input:first').focus()
  ).observes('controller.isEditing')

  click: (e) ->
    unless @get 'isEditing'
      @set 'isEditing', true
      e.stopPropagation()

  actions:
    cancel: ->
      sendCancel = => @get('controller').send('cancel')

      if @get('isNew')
        @$().fadeOut 250, ->
          sendCancel()
      else
        sendCancel()

`export default RoleView`

`import Ember from 'ember'`
`import AuthorizedRoute from 'tahi/routes/authorized'`
`import EventStreamHandler from 'tahi/mixins/routes/event-stream-handler'`
`import LazyLoader from 'tahi/mixins/routes/lazy-loader'`
`import RESTless from 'tahi/services/rest-less'`
`import Heartbeat from 'tahi/services/heartbeat'`
`import ENV from 'tahi/config/environment'`
`import initializeVisualEditor from 'ember-cli-visualeditor/initializers/initialize_visual_editor'`

PaperEditRoute = AuthorizedRoute.extend EventStreamHandler,
  fromSubmitOverlay: false

  heartbeatService: null

  beforeModel: ->
    initializeVisualEditor(ENV)

  model: ->
    paper = @modelFor('paper')
    new Ember.RSVP.Promise((resolve, reject) ->
      paper.get('tasks').then((tasks) -> resolve(paper)))

  afterModel: (model) ->
    if model.get('editable')
      @set('heartbeatService', Heartbeat.create(resource: model))
      @startHeartbeat()
    else
      @replaceWith('paper.index', model)

  setupController: (controller, model) ->
    controller.set('model', model)
    controller.set('commentLooks', @store.all('commentLook'))
    if @currentUser
      RESTless.authorize(controller, "/papers/#{model.get('id')}/manuscript_manager", 'canViewManuscriptManager')

  deactivate: ->
    @endHeartbeat()

  startHeartbeat: ->
    if @isLockedByCurrentUser()
      @get('heartbeatService').start()

  endHeartbeat: ->
    @get('heartbeatService').stop()

  isLockedByCurrentUser: ->
    lockedBy = @modelFor('paper').get('lockedBy')
    lockedBy and lockedBy == @currentUser

  actions:
    viewCard: (task) ->
      paper = @modelFor('paper')
      redirectParams = ['paper.edit', @modelFor('paper')]
      @controllerFor('application').get('overlayRedirect').pushObject(redirectParams)
      @controllerFor('application').set('overlayBackground', 'paper/edit')
      @transitionTo('task', paper.id, task.id)

    startEditing: ->
      @startHeartbeat()

    stopEditing: ->
      @endHeartbeat()

    showConfirmSubmitOverlay: ->
      @render 'overlays/paperSubmit',
        into: 'application',
        outlet: 'overlay',
        controller: 'overlays/paperSubmit'
      @set 'fromSubmitOverlay', true

    editableDidChange: ->
      if !@fromSubmitOverlay
        @replaceWith('paper.index', @modelFor('paper'))
      else
        @set 'fromSubmitOverlay', false

    "es::paper::revised": (event) ->
      revisedPaperId = event.get("target.paper")
      @store.fetchById("paper", revisedPaperId).then (paper) =>
        if @modelFor("paper").get("id") == paper.get("id")
          @get("notificationManager").notify(event.get("name"))

`export default PaperEditRoute`

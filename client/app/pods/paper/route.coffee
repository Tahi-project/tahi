`import Ember from 'ember'`
`import RESTless from 'tahi/services/rest-less'`
`import Utils from 'tahi/services/utils'`
`import AuthorizedRoute from 'tahi/routes/authorized'`

PaperRoute = AuthorizedRoute.extend
  model: (params) ->
    @store.fetchById('paper', params.paper_id)

  channelName: (id) ->
    "private-paper@#{id}"

  afterModel: (model, transition) ->
    @get('pusher').wire(@, @channelName(model.get('id')), ["created", "updated"])

  setupController: (controller, model) ->
    controller.set('model', model)

    setFormats = (data) ->
      if !data then return # IHAT_URL is not set in rails.
      Ember.run ->
        supportedExportFormats = []
        for dataType in data.export_formats
          supportedExportFormats.pushObject({format: dataType, icon: "svg/#{dataType}-icon"})
        controller.set('supportedDownloadFormats', supportedExportFormats)

    Ember.$.getJSON('/api/formats', setFormats)

  deactivate: ->
    @get('pusher').unwire(@, @channelName(@modelFor('paper').get('id')))

  actions:
    addContributors: ->
      paper = @modelFor('paper')
      collaborations = paper.get('collaborations') || []
      controller = @controllerFor('overlays/showCollaborators')
      controller.setProperties
        paper: paper
        collaborations: collaborations
        initialCollaborations: collaborations.slice()
        allUsers: @store.find('user')

      @render('overlays/showCollaborators',
        into: 'application'
        outlet: 'overlay'
        controller: controller)

    showActivity: (name) ->
      paper = @modelFor('paper')
      controller = @controllerFor 'overlays/activity'
      controller.set 'isLoading', true

      RESTless.get("/api/papers/#{paper.get('id')}/activity/#{name}").then (data) =>
        controller.setProperties
          isLoading: false
          model: Utils.deepCamelizeKeys(data.feeds)

      @render 'overlays/activity',
        into: 'application',
        outlet: 'overlay',
        controller: controller

  _pusherEventsId: ->
    # needed for the `wire` and `unwire` method to think we have `ember-pusher/bindings` mixed in
    return @toString()

`export default PaperRoute`

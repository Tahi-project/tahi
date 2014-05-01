ETahi.TaskRoute = Ember.Route.extend
  model: (params) ->
    @set('paperId', params.paper_id)
    @store.find('task', params.task_id)

  setupController: (controller, model) ->
    # FIXME: Rename AdHocTask to Task (here, in views, and in templates)
    currentType = model.get('type')
    currentType = 'AdHocTask' if currentType == 'Task'
    baseObjectName = (currentType || 'AdHocTask').replace('Task', 'Overlay')
    @set('baseObjectName', baseObjectName)

    taskController = @controllerFor(baseObjectName)
    taskController.set('model', model)
    taskController.set('paperId', @get('paperId'))
    @set('taskController', taskController)

    if @controllerFor('application').get('overlayRedirect')
      taskController.set('onClose', 'redirect')

  renderTemplate: ->
    @render @get('baseObjectName'),
      into: 'application'
      outlet: 'overlay'
      controller: @get('taskController')
    @render(@controllerFor('application').get('overlayBackground'))

  deactivate: ->
    @send('closeOverlay')
    @controllerFor('application').setProperties(overlayRedirect: null, overlayBackground: null)

  actions:
    willTransition: (transition) ->
      unless transition.targetName == @controllerFor('application').get('overlayRedirect.firstObject')
        @controllerFor('application').set('cachedModel', null)

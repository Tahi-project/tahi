`import Ember from 'ember'`
`import AuthorizedRoute from 'tahi/routes/authorized'`

TaskRoute = AuthorizedRoute.extend
  model: (params) ->
    @store.find('paper', params.paper_id).then =>
      @store.find('task', params.task_id)

  setupController: (controller, model) ->
    # FIXME: Rename AdHocTask to Task (here, in views, and in templates)
    currentType = model.get('type')
    currentType = 'AdHocTask' if currentType == 'Task'
    baseObjectName = (currentType || 'AdHocTask').replace('Task', '')
    @set('baseObjectName', baseObjectName)

    taskController = @controllerFor("overlays/#{baseObjectName}")
    taskController.set('model', model)
    @set('taskController', taskController)

    taskComments = @store.filter 'comment', (part) ->
      part.get('task') == model
    taskController.set('comments', taskComments)

    taskParticipations = @store.filter 'participation', (part) ->
      part.get('task') == model
    taskController.set('participations', taskParticipations)

    if !Ember.isEmpty(@controllerFor('application').get('overlayRedirect'))
      taskController.set 'onClose', 'redirect'
    else
      taskController.set 'onClose', 'redirectToDashboard'

    taskController.trigger('didSetupController')

  resetController: (controller, isExiting, _transition) ->
    if isExiting
      controller.set('isNewTask', false)

  renderTemplate: ->
    @render "overlays/#{@get('baseObjectName')}",
      into: 'application'
      outlet: 'overlay'
      controller: @get('taskController')
    @render(@controllerFor('application').get('overlayBackground'))

  deactivate: ->
    @send('closeOverlay')
    @controllerFor('application').setProperties(overlayRedirect: [], overlayBackground: null)

  actions:
    willTransition: (transition) ->
      @get('taskController').send('routeWillTransition', transition)

`export default TaskRoute`

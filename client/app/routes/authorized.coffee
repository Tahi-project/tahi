`import Ember from 'ember'`

AuthorizedRoute = Ember.Route.extend
  handleUnauthorizedRequest: (transition) ->
    transition.abort()
    @transitionTo('dashboard').then =>
      @flash.displayMessage('error', "You don't have access to that content")

  actions:
    error: (response, transition) ->
      console.log(response)
      switch response.status
        when 403 then @handleUnauthorizedRequest(transition)
      console.log "Error in transition to #{transition.targetName}"
      true # bubble for other error handling

  _pusherEventsId: ->
    # needed for the `wire` and `unwire` method to think we have `ember-pusher/bindings` mixed in
    return this.toString()
`export default AuthorizedRoute`

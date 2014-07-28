#= require controllers/base_paper_controller
ETahi.PaperEditController = ETahi.BasePaperController.extend
  visualEditor: null
  saveState: false

  setupVisualEditor: (->
    @set('visualEditor', ETahi.VisualEditorService.create())
  ).on("init")

  errorText: ""

  addAuthorsTask: (->
    this.get('tasks').findBy('type', 'AuthorsTask')
  ).property()

  showPlaceholder: ( ->
    Ember.isBlank $(@get 'model.body').text()
  ).property('model.body')

  statusMessage: ( ->
    @get('processingMessage') || @get('userEditingMessage') || @get('saveStateMessage')
  ).property('processingMessage', 'userEditingMessage', 'saveStateMessage')

  processingMessage: (->
    if @get('status') is "processing"
      "Processing Manuscript"
    else
      null
  ).property('status')

  userEditingMessage: ( ->
    lockedBy = @get('lockedBy')
    if lockedBy and lockedBy isnt @getCurrentUser()
      "<span class='user-name'>#{lockedBy.get('fullName')}</span> <span>is editing</span>"
    else
      null
  ).property('lockedBy')

  locked: ( ->
    !Ember.isBlank(@get('processingMessage') || @get('userEditingMessage'))
  ).property('processingMessage', 'userEditingMessage')

  isEditing: (->
    lockedBy = @get('lockedBy')
    lockedBy and lockedBy is @getCurrentUser()
  ).property('lockedBy')

  canEdit: ( ->
    !@get('locked')
  ).property('locked')

  defaultBody: 'Type your manuscript here'

  saveStateDidChange: (->
    if @get('saveState')
      @setProperties
        saveStateMessage: "Saved"
        savedAt: new Date()
    else
      @setProperties
        saveStateMessage: null
        savedAt: null
  ).observes('saveState')

  actions:
    toggleEditing: ->
      if @get('lockedBy') #unlocking
        @set('body', @get('visualEditor.bodyHtml'))
        @set('lockedBy', null)
        @send('stopEditing')
        @get('model').save().then (paper) =>
          @set('saveState', true)
      else #locking
        @set('lockedBy', @getCurrentUser())
        @get('model').save().then (paper) =>
          @send('startEditing')
          @set('saveState', false)

    savePaper: ->
      return unless @get('model.editable')
      @get('model').save().then (paper) =>
        @set('saveState', true)

    updateDocumentBody: (content) ->
      @set('body', content)
      false

    confirmSubmitPaper: ->
      return unless @get('allMetadataTasksCompleted')
      @get('model').save()
      @transitionToRoute('paper.submit')

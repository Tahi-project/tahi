a = DS.attr
ETahi.Paper = DS.Model.extend
  assignees: DS.hasMany('user')
  authors: DS.hasMany('author')
  editors: DS.hasMany('user')
  figures: DS.hasMany('figure')
  supportingInformationFiles: DS.hasMany('supportingInformationFile')
  journal: DS.belongsTo('journal')
  phases: DS.hasMany('phase')
  reviewers: DS.hasMany('user')
  tasks: DS.hasMany('task', {async: true, polymorphic: true})

  body: a('string')
  shortTitle: a('string')
  submitted: a('boolean')
  title: a('string')
  paperType: a('string')

  availableReviewers: Ember.computed.alias('journal.reviewers')
  editor: Ember.computed.alias('editors.firstObject')
  relationshipsToSerialize: []

  displayTitle: (->
    @get('title') || @get('shortTitle')
  ).property('title', 'shortTitle')

  allMetadataTasks: (->
    @get('tasks').filterBy('isMetadataTask')
  ).property('tasks.content.@each.isMetadataTask')

  allMetadataTasksCompleted: ETahi.computed.all('allMetadataTasks', 'completed', true)

  editable: (->
    !(@get('allTasksCompleted') and @get('submitted'))
  ).property('allTasksCompleted', 'submitted')

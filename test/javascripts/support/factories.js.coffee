ETahi.Factory =
  withOne: (modelName, attrs) ->

  withMany: (modelName, attrs) ->

  create: (type, attrs) ->
    newObject = Ember.merge(ETahi.FactoryAttributes[type], attrs)
    newObject.withOne = @withOne
    newObject.withMany = @withMany

  createLitePaper: (paper, attrs) ->
    {short_title, title, id, submitted} = paper
    paper_id = id
    litePaperAttrs = {short_title, title, id, submitted, paper_id}
    Ember.merge(litePaperAttrs, attrs)

ETahi.FactoryAttributes = {}
ETahi.FactoryAttributes.journal =
  id: 1
  name: "Fake Journal"
  logo_url: "/images/no-journal-image.gif"
  paper_types: ["Research"]
  task_types: [
    "ReviewerReportTask"
    "PaperAdminTask"
    "UploadManuscript::Task"
    "PaperEditorTask"
    "Declaration::Task"
    "PaperReviewerTask"
    "RegisterDecisionTask"
    "StandardTasks::TechCheckTask"
    "StandardTasks::FigureTask"
    "StandardTasks::AuthorsTask"
    "SupportingInformation::Task"
    "DataAvailability::Task"
    "FinancialDisclosure::Task"
    "CompetingInterests::Task"
  ]
  manuscript_css: null

ETahi.FactoryAttributes.paper =
  id: 1
  short_title: "Paper"
  title: "Foo"
  body: null
  submitted: false
  paper_type: "Research"
  status: null
  phase_ids: []
  figure_ids: []
  author_group_ids: []
  supporting_information_file_ids: []
  assignee_ids: []
  editor_ids: []
  reviewer_ids: []
  tasks: []
  journal_id: 1

ETahi.FactoryAttributes.litePaper =
  id: 1
  title: "Foo"
  paper_id: 1
  short_title: "Paper"
  submitted: false

ETahi.FactoryAttributes.messageTask =
  id: 1
  title: "Message Time"
  type: "MessageTask"
  completed: false
  body: null
  paper_title: "Foo"
  role: "author"
  phase_id: 40
  paper_id: 1
  lite_paper_id: 1
  assignee_ids: []
  assignee_id: 1
  participant_ids: [1]
  comment_ids: []

ETahi.FactoryAttributes.comment =
  id: 1
  commenter_id: 1
  message_task_id: 1
  body: "A sample comment"
  created_at: null
  comment_look_id: null

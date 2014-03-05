NewCardButton = React.createClass
  displayName: "NewCardButton"
  render: ->
    {a} = React.DOM
    (a
      className: 'secondary-button react-choose-card-type-overlay',
      "data-assignees": JSON.stringify(@props.paper.assignees),
      "data-url": @props.paper.tasks_url,
      "data-phase_id": @props.phase_id,
      "data-paper_id": @props.paper.id,
      "data-paper_title": @props.paper.paper_short_title,
      href: "#",
        "Add New Card"
    )

ManuscriptHeader = React.createClass
  displayName: "ManuscriptHeader"
  render: ->
    {ul, div, section, img, h2, li, a, section} = React.DOM
    (div {id:'control-bar-container'},
      div {id:'control-bar'},
        section {},
          ul {},
            li {id:'paper-journal'},
              if @props.paper.journal_logo_url
                img {src: @props.paper.journal_logo_url}
              else
                div {}, @props.paper.journal_name
            li {id:'paper-short-title'},
              h2 {className:'tasks-paper-title'}, @props.paper.paper_short_title
          ul {},
            li {},
              a {href:@props.paper.edit_url}, "Manuscript")

Tahi.manuscriptManager =
  init: ()->
    if columns = document.getElementById('manuscript-manager')
      columns = Tahi.manuscriptManager.Columns flows: [], route: columns.getAttribute("data-url")
      React.renderComponent columns, document.getElementById('tahi-container')

  Columns: React.createClass
    displayName: "Columns"

    render: ->
      {ul, div} = React.DOM
      if @state.paper
        header = ManuscriptHeader {paper: @state.paper}
      (div {},
          header
        (ul {className: 'columns'},
          Tahi.manuscriptManager.ColumnAppender {
            addFunction: @addColumn
            bonusClass: 'first-add-column'
            position: -1}
          for flow, position in @state.flows
            Tahi.manuscriptManager.Column {
              addFunction: @addColumn,
              position: flow.position
              name: flow.name
              tasks: flow.tasks,
              phase_id: flow.id,
              paper: @state.paper
              removeCard: @removeCard
            }
      ))

    componentWillMount: ->
      @setState @props

    componentDidMount: ->
      Tahi.utils.bindColumnResize()

      $.getJSON @props.route, (data,status) =>
        @setState flows: data.flows, paper: data.paper

    componentDidUpdate: ->
      Tahi.utils.resizeColumnHeaders()

      $('.paper-profile h4').dotdotdot
        height: 40

    removeCard: (taskId, phaseId) ->
      $.ajax
        url: 'tasks/' + taskId
        method: 'DELETE'
        success: =>
          newFlows = @state.flows.slice(0)
          flow = _.findWhere(newFlows, {id: phaseId})
          flow.tasks = _.reject flow.tasks, (task) ->
            task.taskId == taskId
          @setState flows: newFlows

    addColumn: (position) ->
      newPosition = position + 1
      column =
        paper: @state.paper
        tasks: []
        position: newPosition
        name: "New Phase"
      $.ajax
        url: '/phases'
        method: 'POST'
        dataType: 'json'
        data:
          phase:
            task_manager_id: @state.paper.task_manager_id
            position: column.position
            name: column.name
        success: (data) =>
          newPhase = data.phase
          newPhase.paper = @state.paper
          newFlows = @state.flows.slice(0) #don't mutate old state
          newFlows.splice(newPosition, 0, newPhase)
          @setState flows: newFlows


  Column: React.createClass
    displayName: "Column"
    render: ->
      {h2, div, ul, li} = React.DOM
      (li {className: 'column'},
        Tahi.manuscriptManager.ColumnAppender {
          addFunction: @props.addFunction,
          position: @props.position}
        (h2 {}, @props.name),
        (div {className: 'column-content'},
          (ul {className: 'cards'},
            @manuscriptCards()
      )))

    manuscriptCards: ->
      {li} = React.DOM
      cards = _.map @props.tasks, (task) =>
        (li {}, Tahi.columnComponents.Card {task: task, removeCard: => @props.removeCard(task.taskId, @props.phase_id)})
      cards.concat((li {},
        NewCardButton {
          paper: @props.paper,
          phase_id: @props.phase_id
      }))


  ColumnAppender: React.createClass
    displayName: "ColumnAppender"
    render: ->
      @props.bonusClass ||= ""
      {span, i} = React.DOM
      (span {
        className: "add-column #{@props.bonusClass}",
        "data-toggle": "tooltip",
        "data-placement": "auto right",
        "title": "Add Phase"
        onClick: @handleClick},
        (i {className: 'glyphicon glyphicon-plus'}))

    handleClick: ->
      @props.addFunction(@props.position)


    componentDidMount: ->
      $(@getDOMNode()).tooltip()

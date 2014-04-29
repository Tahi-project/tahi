window.Tahi ||= {}
Tahi.utils =
  toCamel: (string) ->
    string.replace /(\-[a-z])/g, ($1) ->
      $1.toUpperCase().replace "-", ""

  windowHistory: ->
    window.history

  bindColumnResize: ->
    $(window).off('resize.columns').on 'resize.columns', =>
      @resizeColumnHeaders()

  resizeColumnHeaders: ->
    $children = $('.columns .column-header')
    return unless $children.length

    $children.css('height', '')
    heights = $children.find('h2').map ->
      $(this).outerHeight()

    max = Math.max.apply(Math, heights)

    $children.css('height', max)
    $('.column-content').css('top', max)

  setPropertyWithDelay: (obj, prop, startVal, endVal, ms) ->
    obj.set(prop, startVal)
    setTimeout( ->
      Ember.run.schedule("actions", obj, 'set', prop, endVal)
    ms)


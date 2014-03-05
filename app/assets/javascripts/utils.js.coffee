Tahi.utils =
  windowHistory: ->
    window.history

  bindColumnResize: ->
    $(window).off('resize.columns').on 'resize.columns', =>
      @resizeColumnHeaders()

  resizeColumnHeaders: ->
    $children = $('.columns h2')
    return unless $children.length

    $children.css('height', '')
    heights = $children.map ->
      $(this).outerHeight()

    max = Math.max.apply(Math, heights)

    $children.css('height', max)
    $('.column-content').css('top', max)

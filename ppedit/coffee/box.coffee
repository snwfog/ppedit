class Box

  constructor: (options)->

    # true if the user is currently leftclicking on the box.
    @mouseDown = false

    settings = $.extend(
      left:'50px'
      top:'50px'
      width:'100px'
      height:'200px'
    , options);

    @element = $('<div></div>')
    .addClass('ppedit-box')
    .attr('id', $.now())
    .css(settings)
    .mousedown =>
        @mouseDown = true
( ($) ->
  root = null
  $.fn.ppedit = () ->

    root = this.addClass("ppedit-container");

    createBoxbutton = $("<button>Create Box</button>")
    this.append(createBoxbutton);
    createBoxbutton.click ->
      createBox()

    return this;

  createBox = (options) ->
    settings = $.extend(
      left:'50px'
      top:'50px'
      width:'100px'
      height:'200px'
    , options);

    newBox = $('<div class="ppedit-box"><div>').css(settings)
    root.append(newBox)
) jQuery
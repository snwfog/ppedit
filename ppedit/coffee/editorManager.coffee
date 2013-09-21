class EditorManager
  constructor: (@root) ->

  createBox:(options) ->
    settings = $.extend(
      left:'50px'
      top:'50px'
      width:'100px'
      height:'200px'
    , options);

    newBox = $('<div class="ppedit-box"><div>').css(settings).resizable()
    @root.append(newBox)

  undo: ->

  redo: ->
#= require ICommand

class CreateBoxCommand extends ICommand

  constructor: (@root, @options) ->
    super @root
    @box = null

  execute: ->
    settings = $.extend(
      left:'50px'
      top:'50px'
      width:'100px'
      height:'200px'
    , @options);

    @box = $('<div class="ppedit-box"></div>').css(settings)
    @root.append @box

  undo: ->
    @root.remove @box

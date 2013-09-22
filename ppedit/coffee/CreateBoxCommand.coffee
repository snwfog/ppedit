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

    @box = $('<div></div>')
      .addClass('ppedit-box')
      .attr('id', $.now())
      .css(settings)
      .attr('draggable', true)
      .on 'dragstart', (event) ->

        # Save the offset from the mouse to the top-left corner of the box
        event.originalEvent.dataTransfer.setData 'mouseOffsetX', event.originalEvent.offsetX
        event.originalEvent.dataTransfer.setData 'mouseOffsetY', event.originalEvent.offsetY

        event.originalEvent.dataTransfer.setData 'boxId', this.id

    @root.append @box

  undo: ->
    @root.remove @box

#= require Box
#= require Command

class MoveBoxCommand extends Command

  constructor: (@box, @pageNum, @toPosition, @fromPosition) ->
    super()
    @boxIds.push @box.element.attr('id')
    @fromPosition = @box.currentPosition() if !fromPosition?

  execute: ->
    @box.setPosition @toPosition.left, @toPosition.top

  undo: ->
    @box.setPosition @fromPosition.left, @fromPosition.top

  getType: ->
    return 'Modify'

  getPageNum: ->
    return @pageNum
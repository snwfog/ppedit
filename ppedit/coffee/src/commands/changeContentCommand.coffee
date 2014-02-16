#= require Box
#= require Command

class ChangeBoxContentCommand extends Command

  constructor: (@box, @pageNum, @prevContent, @newContent) ->
    super()

    @boxIds.push @box.element.attr('id')

  execute: ->
    @box.element.html(@newContent)

  undo: ->
    @box.element.html(@prevContent)

  getType: ->
    return 'Modify'

  getPageNum: ->
    return @pageNum
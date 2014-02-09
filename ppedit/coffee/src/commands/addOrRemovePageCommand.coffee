#= require Box
#= require Command
#= require EditArea

class AddOrRemoveCommand extends Command

  constructor: (@editor, @addPage, @pageNum) ->
    super()

  execute: ->
    if @addPage
      @_addNewPage()

  undo: ->

    @changeOpacityToVal @prevVal

  _addNewPage: ->
    newArea = new EditArea @editor.element, @editor.areas.length
    newArea.buildElement()
    @editor.superContainer.append newArea.buildElement()
    newArea.bindEvents()
    @editor.panel.addNewTab()
    @editor.areas.push newArea

  _removePage:(pageNum) ->
    @editor.areas.splice(pageNum, 1).element.remove()
    @editor.panel.removeTab(pageNum)

  getType: ->
    return 'Modify'

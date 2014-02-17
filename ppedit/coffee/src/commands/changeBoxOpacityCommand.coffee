#= require Box
#= require Command

class ChangeBoxOpacityCommand extends Command

  constructor: (@editor, @pageNum, @boxId, @prevVal, @newVal) ->
    super()

  execute: ->
    @changeOpacityToVal @newVal

  undo: ->
    @changeOpacityToVal @prevVal

  changeOpacityToVal: (value) ->
    @editor.areas[@pageNum].boxesContainer.changeBoxOpacity @boxId, value
    @editor.panel.element.find("tr[ppedit-box-id="+ @boxId + "]").find('.ppedit-slider').slider('setValue', parseInt(value*100))

  getType: ->
    return 'Modify'

  getPageNum: ->
    return @pageNum

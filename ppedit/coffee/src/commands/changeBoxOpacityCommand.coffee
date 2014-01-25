#= require Box
#= require Command

class ChangeBoxOpacityCommand extends Command

  constructor: (@editor, @editPage, @boxId, @prevVal, @newVal) ->
    super()

  execute: ->
    @changeOpacityToVal @newVal

  undo: ->
    @changeOpacityToVal @prevVal

  changeOpacityToVal: (value) ->
    if @editPage
      @editor.area1.boxesContainer.changeBoxOpacity @boxId, value
      @editor.panel1.element.find("tr[ppedit-box-id="+ @boxId + "]").find('.ppedit-slider').slider('setValue', parseInt(value*100))
      console.log(parseInt(value*100))
    else
      @editor.area2.boxesContainer.changeBoxOpacity @boxId, value
      @editor.panel2.element.find("tr[ppedit-box-id="+ @boxId + "]").find('.ppedit-slider').slider('setValue', parseInt(value*100))


  getType: ->
    return 'Modify'

#= require Graphic
#= require EditArea
#= require Panel
#= require Grid
#= require Box
#= require CommandManager
#= require ControllerFactory
#= require Clipboard
#= require CommandFactory

###
Graphic acting a the main container of the PPEditor.
###
class PPEditor extends Graphic

  constructor: (@root) ->
    super @root

    @clipboard1 = new Clipboard
    @clipboard2 = new Clipboard
    @commandManager = new CommandManager
    @cmdFactory = new CommandFactory

    @controller = undefined
    # @area = undefined
    # @panel = undefined


  buildElement: ->
    @element = $('
      <div class="container" tabindex="0">
        <div class="row"></div>
      </div>
    ')

    @controller = ControllerFactory.getController @element

    row = @element.find('.row')
    @superContainer = $('
      <div class="superContainer">
      </div>
    ')
    @editContainer1 = $('
      <div class="editContainer1">
      </div>
    ')
    @editContainer2 = $('
      <div class="editContainer2">
      </div>
    ')
    @superPanel = $('
      <div class="superPanel" style="clear:both;">
      </div>
    ')
    @panelContainer1 = $('
      <div class="panelContainer1" style="clear:both;">
      </div>
    ')
    @panelContainer2 = $('
      <div class="panelContainer2" style="clear:both;">
      </div>
    ')

    @area1 = new EditArea row
    @area2 = new EditArea row

    @panel1 = new Panel row
    @panel2 = new Panel row
    @titlePanel = new TitlePanel row
    @fontPanel = new FontPanel row

    @area1.buildElement()
    @area2.buildElement()

    @panel1.buildElement()
    @panel2.buildElement()
    @titlePanel.buildElement()
    @fontPanel.buildElement()

    @editContainer1.append @area1.element
    @editContainer2.append @area2.element
    @superContainer.append @editContainer1
    @superContainer.append @editContainer2

    @panelContainer1.append @panel1.element
    @panelContainer2.append @panel2.element
    @superPanel.append @panelContainer1
    @superPanel.append @panelContainer2

    row.append @superContainer
    row.append @titlePanel.element
    row.append @fontPanel.element
    row.append @superPanel


  bindEvents: ->

    @element
      .on 'requestUndo', (event) =>
        console.log 'requestUndo'
        @commandManager.undo()

      .on 'requestRedo', (event) =>
        console.log 'requestRedo'
        @commandManager.redo()

      .on 'requestDelete', (event) =>
        if @area1.boxesContainer.getSelectedBoxes().length != 0
          @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, true, @area1.boxesContainer.getSelectedBoxes())
        if @area2.boxesContainer.getSelectedBoxes().length != 0
          @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, false, @area2.boxesContainer.getSelectedBoxes())

      .on 'requestCopy', (event) =>
        if @area1.boxesContainer.getSelectedBoxes().length != 0
          @clipboard1.pushItems @area1.boxesContainer.getSelectedBoxes()
        if @area2.boxesContainer.getSelectedBoxes().length != 0
          @clipboard2.pushItems @area2.boxesContainer.getSelectedBoxes()

      .on 'requestPaste', (event) =>
        editPage = false
        if @area1.boxesContainer.getSelectedBoxes().length != 0
          editPage = true
          items = @clipboard1.popItems()
          if items.length != 0
            @commandManager.pushCommand @cmdFactory.createCopyBoxesCommand(this, editPage, items)
        if @area2.boxesContainer.getSelectedBoxes().length != 0
          items = @clipboard2.popItems()
          if items.length != 0
            @commandManager.pushCommand @cmdFactory.createCopyBoxesCommand(this, editPage, items)

      .on 'textColorChanged', (event, hex) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeTextColorCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), hex)
        else
          @commandManager.pushCommand @cmdFactory.createChangeTextColorCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), hex)

      .on 'graphicContentChanged', (event, params) =>
        @commandManager.pushCommand(@cmdFactory.createCreateChangeBoxContentCommand(params.graphic, params.prevContent, params.newContent), false)

      .on 'boxMoved', (event, box, currentPosition, originalPosition) =>
        @commandManager.pushCommand(@cmdFactory.createMoveBoxCommand(box, currentPosition, originalPosition), false) 

    @element.find('.row')
      .on 'moveElementUpBtnClick', (event, editContainer) =>
        if editContainer
          boxes = @area1.boxesContainer.getSelectedBoxes()
        else
          boxes = @area2.boxesContainer.getSelectedBoxes()
        @commandManager.pushCommand @cmdFactory.createMoveUpCommand(this, editContainer, boxes) if boxes.length > 0

      .on 'moveElementDownBtnClick', (event, editContainer) =>
        if editContainer
          boxes = @area1.boxesContainer.getSelectedBoxes()
        else
          boxes = @area2.boxesContainer.getSelectedBoxes()
        @commandManager.pushCommand @cmdFactory.createMoveDownCommand(this, editContainer, boxes) if boxes.length > 0

      .on 'panelClickAddBtnClick', (event, editContainer) =>
        @commandManager.pushCommand @cmdFactory.createCreateBoxesCommand(this, editContainer)

      .on 'panelClickGridBtnClick', (event) =>
        @area1.grid.toggleGrid()
        @area2.grid.toggleGrid()
    
      .on 'panelClickClearAllBtnClick', (event, editContainer) =>
        if editContainer
          @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, editContainer, @area1.boxesContainer.getAllBoxes())
        else
          @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, editContainer, @area2.boxesContainer.getAllBoxes())

      .on 'onRowDeleteBtnClick', (event, editContainer, boxId) =>
        @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, editContainer, @root.find('#' + boxId))

     .on 'onRowSliderValChanged', (event, editContainer, boxId, opacityVal) =>
       if editContainer
         @area1.boxesContainer.changeBoxOpacity(boxId, opacityVal)
       else
         @area2.boxesContainer.changeBoxOpacity(boxId, opacityVal)

      .on 'onRowSliderStopValChanged', (event, editContainer, boxId, prevVal, newVal) =>
        if editContainer
          @commandManager.pushCommand @cmdFactory.createChangeOpacityCommand(this, true, boxId, prevVal, newVal)
        else
          @commandManager.pushCommand @cmdFactory.createChangeOpacityCommand(this, false, boxId, prevVal, newVal)

      .on 'addBoxRequested', (event, editContainer, boxCssOptions) =>
        @commandManager.pushCommand @cmdFactory.createCreateBoxesCommand(this, editContainer, [boxCssOptions])

      .on 'fontTypeChanged', (event, newFontType) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeFontTypeCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), newFontType)
        else
          @commandManager.pushCommand @cmdFactory.createChangeFontTypeCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), newFontType)

      .on 'fontSizeChanged', (event, newFontSize) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeFontSizeCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), newFontSize)
        else
          @commandManager.pushCommand @cmdFactory.createChangeFontSizeCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), newFontSize)

      .on 'fontWeightBtnEnableClick', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeFontWeightCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), true)
        else
          @commandManager.pushCommand @cmdFactory.createChangeFontWeightCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), true)

      .on 'fontWeightBtnDisableClick', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeFontWeightCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), false)
        else
          @commandManager.pushCommand @cmdFactory.createChangeFontWeightCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), false)

      .on 'fontUnderlinedBtnEnableClick', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeUnderlineFontCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), true)
        else
          @commandManager.pushCommand @cmdFactory.createChangeUnderlineFontCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), true)

      .on 'fontUnderlinedBtnDisableClick', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeUnderlineFontCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), false)
        else
          @commandManager.pushCommand @cmdFactory.createChangeUnderlineFontCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), false)

      .on 'fontItalicBtnEnableClick', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeItalicFontCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), true)
        else
          @commandManager.pushCommand @cmdFactory.createChangeItalicFontCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), true)

      .on 'fontItalicBtnDisableClick', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeItalicFontCommand(this, true, @area1.boxesContainer.getSelectedBoxes(), false)
        else
          @commandManager.pushCommand @cmdFactory.createChangeItalicFontCommand(this, false, @area2.boxesContainer.getSelectedBoxes(), false)

      .on 'rightAlignment', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createRightAlignmentCommand(this, true, @area1.boxesContainer.getSelectedBoxes())
        else
          @commandManager.pushCommand @cmdFactory.createRightAlignmentCommand(this, false, @area2.boxesContainer.getSelectedBoxes())

      .on 'leftAlignment', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createLeftAlignmentCommand(this, true, @area1.boxesContainer.getSelectedBoxes())
        else
          @commandManager.pushCommand @cmdFactory.createLeftAlignmentCommand(this, false, @area2.boxesContainer.getSelectedBoxes())

      .on 'centerAlignment', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createCenterAlignmentCommand(this, true, @area1.boxesContainer.getSelectedBoxes())
        else
          @commandManager.pushCommand @cmdFactory.createCenterAlignmentCommand(this, false, @area2.boxesContainer.getSelectedBoxes())

      .on 'bulletPointBtnEnableClick', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          selectedBoxes = @area1.boxesContainer.getSelectedBoxes()
          boxes = @area1.boxesContainer.getBoxesFromSelector(selectedBoxes.eq(0))
          box.addBulletPoint() for id, box of boxes
        else
          selectedBoxes = @area2.boxesContainer.getSelectedBoxes()
          boxes = @area2.boxesContainer.getBoxesFromSelector(selectedBoxes.eq(0))
          box.addBulletPoint() for id, box of boxes

      .on 'orderedPointBtnEnableClick', (event) =>
        boxSelected = @area1.boxesContainer.getSelectedBoxes()
        if boxSelected.length != 0
          selectedBoxes = @area1.boxesContainer.getSelectedBoxes()
          boxes = @area1.boxesContainer.getBoxesFromSelector(selectedBoxes.eq(0))
          box.addOrderedPointList() for id, box of boxes
        else
          selectedBoxes = @area2.boxesContainer.getSelectedBoxes()
          boxes = @area2.boxesContainer.getBoxesFromSelector(selectedBoxes.eq(0))
          box.addOrderedPointList() for id, box of boxes

      .on 'unSelectBoxes', (event, editContainer) =>
        if editContainer
          allSelectedBoxes = @area2.boxesContainer.getSelectedBoxes()
          if allSelectedBoxes.length !=0
            @area2.boxesContainer.element.find('.ppedit-box')
              .removeClass('ppedit-box-focus')
              .removeClass('ppedit-box-selected')
        else
          allSelectedBoxes = @area1.boxesContainer.getSelectedBoxes()
          if allSelectedBoxes.length !=0
            @area1.boxesContainer.element.find('.ppedit-box')
              .removeClass('ppedit-box-focus')
              .removeClass('ppedit-box-selected')

      .on 'boxSelected', (event, box) =>
        @fontPanel.setSettingsFromStyle box.element.get(0).style

    @area1.bindEvents()
    @area2.bindEvents()
    @panel1.bindEvents()
    @panel2.bindEvents()
    @fontPanel.bindEvents()
    @controller.bindEvents()

  ###
  Populates the editor with the boxes
  information defined in the passed json string.

  @param [String] jsonBoxes the JSON-formatted string containing
  the boxes information, this parameter look like the following :
  [
    {
      "box-id-1":'<div class="ppedit-box">box-id-1 contents in page 1</div>',
      "box-id-2":'<div class="ppedit-box">box-id-2 contents in page 1</div>'
    },
    {
      "box-id-3":'<div class="ppedit-box">box-id-1 contents in page 2</div>',
      "box-id-4":'<div class="ppedit-box">box-id-2 contents in page 2</div>'
    }
  ]
  ###
  load: (jsonBoxes) ->
    command = @cmdFactory.createLoadBoxesCommand this, jsonBoxes
    command.execute()

  ###
  Returns a JSON string containing a description of
  all the boxes currently existing in the editor.
  ###
  getAllHunks: ->
    return JSON.stringify [@area1.boxesContainer.getAllHunks(), @area2.boxesContainer.getAllHunks()]
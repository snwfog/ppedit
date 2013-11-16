#= require Graphic
#= require EditArea
#= require Panel
#= require Grid
#= require Box
#= require CommandManager
#= require ControllerFactory
#= require Clipboard
#= require CommandFactory

class PPEditor extends Graphic

  constructor: (@root) ->
    super @root

    @clipboard = new Clipboard
    @commandManager = new CommandManager
    @cmdFactory = new CommandFactory

    @controller = undefined
    @area = undefined
    @panel = undefined


  buildElement: ->
    @element = $('
      <div class="container">
        <div class="row"></div>
      </div>
    ')

    @controller = ControllerFactory.getController @element

    row = @element.find('.row')
    @area = new EditArea row
    @panel = new Panel row
    @fontPanel = new FontPanel row

    @area.buildElement()
    @panel.buildElement()
    @fontPanel.buildElement()

    row.append @area.element
    row.append @panel.element
    row.append @fontPanel.element

  bindEvents: ->

    @element
      .on 'requestUndo', (event) =>
        @commandManager.undo()

      .on 'requestRedo', (event) =>
        @commandManager.redo()

      .on 'requestDelete', (event) =>
        @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, @area.boxesContainer.getSelectedBoxes())

      .on 'requestCopy', (event) =>
        @clipboard.pushItems @area.boxesContainer.getSelectedBoxes()

      .on 'requestPaste', (event) =>
        items = @clipboard.popItems()
        if items.length != 0
          @commandManager.pushCommand @cmdFactory.createCopyBoxesCommand(this, items)

      .on 'textColorChanged', (event, hex) =>
        @commandManager.pushCommand @cmdFactory.createChangeTextColorCommand(this, @area.boxesContainer.getSelectedBoxes(), hex)

      .on 'graphicContentChanged', (event, params) =>
        @commandManager.pushCommand(@cmdFactory.createCreateChangeBoxContentCommand(params.graphic, params.prevContent, params.newContent), false)

    @element.find('.row')
      .on 'moveElementUpBtnClick', (event) =>
        boxes = @area.boxesContainer.getSelectedBoxes()
        @commandManager.pushCommand @cmdFactory.createMoveUpCommand(this, boxes) if boxes.length > 0

      .on 'moveElementDownBtnClick', (event) =>
        boxes = @area.boxesContainer.getSelectedBoxes()
        @commandManager.pushCommand @cmdFactory.createMoveDownCommand(this, boxes) if boxes.length > 0

      .on 'panelClickAddBtnClick', (event) =>
        @commandManager.pushCommand @cmdFactory.createCreateBoxesCommand(this)

      .on 'panelClickGridBtnClick', (event) =>
        @area.grid.toggleGrid()
    
      .on 'panelClickClearAllBtnClick', (event) =>
        @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, @area.boxesContainer.getAllBoxes())
    
      .on 'onRowDeleteBtnClick', (event, boxId) =>
        @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, @root.find('#' + boxId))

      .on 'onRowSliderValChanged', (event, boxId, opacityVal) =>
        @area.boxesContainer.chageBoxOpacity(boxId, opacityVal)

      .on 'addBoxRequested', (event, boxCssOptions) =>
        @commandManager.pushCommand @cmdFactory.createCreateBoxesCommand(this, [boxCssOptions])

      .on 'fontTypeChanged', (event, newFontType) =>
        @commandManager.pushCommand @cmdFactory.createChangeFontTypeCommand(this, @area.boxesContainer.getSelectedBoxes(), newFontType)

      .on 'fontSizeChanged', (event, newFontSize) =>
        @commandManager.pushCommand @cmdFactory.createChangeFontSizeCommand(this, @area.boxesContainer.getSelectedBoxes(), newFontSize)

      .on 'fontWeightBtnEnableClick', (event) =>
        @commandManager.pushCommand @cmdFactory.createChangeFontWeightCommand(this, @area.boxesContainer.getSelectedBoxes(), true)

      .on 'fontWeightBtnDisableClick', (event) =>
        @commandManager.pushCommand @cmdFactory.createChangeFontWeightCommand(this, @area.boxesContainer.getSelectedBoxes(), false)

      .on 'fontUnderlinedBtnEnableClick', (event) =>
        @commandManager.pushCommand @cmdFactory.createChangeUnderlineFontCommand(this, @area.boxesContainer.getSelectedBoxes(), true)

      .on 'fontUnderlinedBtnDisableClick', (event) =>
        @commandManager.pushCommand @cmdFactory.createChangeUnderlineFontCommand(this, @area.boxesContainer.getSelectedBoxes(), false)

      .on 'fontItalicBtnEnableClick', (event) =>
        @commandManager.pushCommand @cmdFactory.createChangeItalicFontCommand(this, @area.boxesContainer.getSelectedBoxes(), true)

      .on 'fontItalicBtnDisableClick', (event) =>
        @commandManager.pushCommand @cmdFactory.createChangeItalicFontCommand(this, @area.boxesContainer.getSelectedBoxes(), false)

      .on 'rightAlignment', (event) =>
        @commandManager.pushCommand @cmdFactory.createRightAlignmentCommand(this, @area.boxesContainer.getSelectedBoxes())

      .on 'leftAlignment', (event) =>
        @commandManager.pushCommand @cmdFactory.createLeftAlignmentCommand(this, @area.boxesContainer.getSelectedBoxes())

      .on 'centerAlignment', (event) =>
        @commandManager.pushCommand @cmdFactory.createCenterAlignmentCommand(this, @area.boxesContainer.getSelectedBoxes())

      .on 'bulletPointBtnEnableClick', (event) =>
        selectedBoxes = @area.boxesContainer.getSelectedBoxes()
        boxes = @area.boxesContainer.getBoxesFromSelector(selectedBoxes.eq(0))
        box.addBulletPoint() for id, box of boxes

      .on 'orderedPointBtnEnableClick', (event) =>
        selectedBoxes = @area.boxesContainer.getSelectedBoxes()
        boxes = @area.boxesContainer.getBoxesFromSelector(selectedBoxes.eq(0))
        box.addOrderedPointList() for id, box of boxes

    @area.boxesContainer.element
      .on 'boxMoved', (event, box, currentPosition, originalPosition) =>
        @commandManager.pushCommand(@cmdFactory.createMoveBoxCommand(box, currentPosition, originalPosition), false)

    @area.bindEvents()
    @panel.bindEvents()
    @fontPanel.bindEvents()
    @controller.bindEvents()

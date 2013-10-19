#= require Graphic
#= require EditArea
#= require Panel
#= require Grid
#= require Box
#= require CommandManager
#= require ControllerFactory
#= require RemoveBoxesCommand
#= require CreateBoxesCommand
#= require Clipboard
#= require CopyBoxesCommand
#= require ChangeFontWeightCommand
#= require ChangeFontSizeCommand
#= require ChangeFontTypeCommand
#= require UnderlineFontCommand
#= require ItalicFontCommand
#= require UnderlineFontCommand

class PPEditor extends Graphic

  constructor: (@root) ->
    super @root

    @clipboard = new Clipboard
    @commandManager = new CommandManager
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

    @area.buildElement()
    @panel.buildElement()

    row.append @area.element
    row.append @panel.element

  bindEvents: ->

    @element
      .on 'requestUndo', (event) =>
        @commandManager.undo()

      .on 'requestRedo', (event) =>
        @commandManager.redo()

      .on 'requestDelete', (event) =>
        @commandManager.pushCommand new RemoveBoxesCommand this, @area.boxesContainer.getSelectedBoxes()

      .on 'requestCopy', (event) =>
        @clipboard.saveItemsStyle @area.boxesContainer.getSelectedBoxes()

      .on 'requestPaste', (event) =>
        if @clipboard.items.length != 0
          @commandManager.pushCommand new CopyBoxesCommand this, @clipboard.items

    @element.find('.row')
      .on 'panelClickAddBtnClick', (event) =>
        @commandManager.pushCommand new CreateBoxesCommand this

      .on 'panelClickGridBtnClick', (event) =>
        @area.grid.toggleGrid()
    
      .on 'panelClickClearAllBtnClick', (event) =>
        @commandManager.pushCommand new RemoveBoxesCommand this, @area.boxesContainer.getAllBoxes()
    
      .on 'onRowDeleteBtnClick', (event, boxId) =>
        @commandManager.pushCommand new RemoveBoxesCommand this, @root.find('#' + boxId)

      .on 'onRowSliderValChanged', (event, boxId, opacityVal) =>
        @area.boxesContainer.chageBoxOpacity(boxId, opacityVal)

      .on 'addBoxRequested', (event, boxCssOptions) =>
        @commandManager.pushCommand new CreateBoxesCommand this, [boxCssOptions]

      .on 'fontTypeChanged', (event, newFontType) =>
        @commandManager.pushCommand new ChangeFontTypeCommand this, @area.boxesContainer.getSelectedBoxes(), newFontType

      .on 'fontSizeChanged', (event, newFontSize) =>
        @commandManager.pushCommand new ChangeFontSizeCommand this, @area.boxesContainer.getSelectedBoxes(), newFontSize

      .on 'fontWeightBtnEnableClick', (event) =>
        @commandManager.pushCommand new ChangeFontWeightCommand this, @area.boxesContainer.getSelectedBoxes(), true

      .on 'fontWeightBtnDisableClick', (event) =>
        @commandManager.pushCommand new ChangeFontWeightCommand this, @area.boxesContainer.getSelectedBoxes(), false

      .on 'fontUnderlinedBtnEnableClick', (event) =>
        @commandManager.pushCommand new UnderlineFontCommand this, @area.boxesContainer.getSelectedBoxes(), true

      .on 'fontUnderlinedBtnDisableClick', (event) =>
        @commandManager.pushCommand new UnderlineFontCommand this, @area.boxesContainer.getSelectedBoxes(), false

      .on 'fontItalicBtnEnableClick', (event) =>
        @commandManager.pushCommand new ItalicFontCommand this, @area.boxesContainer.getSelectedBoxes(), true

      .on 'fontItalicBtnDisableClick', (event) =>
        @commandManager.pushCommand new ItalicFontCommand this, @area.boxesContainer.getSelectedBoxes(), false

    @area.boxesContainer.element
      .on 'boxMoved', (event, box, currentPosition, originalPosition) =>
        @commandManager.pushCommand(new MoveBoxCommand(box, currentPosition, originalPosition), false)

    @area.bindEvents()
    @panel.bindEvents()
    @controller.bindEvents()

#= require Graphic
#= require EditArea
#= require Panel
#= require Grid
#= require Box
#= require CommandManager
#= require ControllerFactory
#= require Clipboard
#= require CommandFactory
#= require Constants

###
Graphic acting a the main container of the PPEditor.
###
class PPEditor extends Graphic

  constructor: (@root) ->
    super @root

    @clipboard = new Clipboard
    @commandManager = new CommandManager
    @cmdFactory = new CommandFactory
    @controller = undefined
    @panel = undefined

  buildElement: ->
    @element = $('
      <div class="container" tabindex="0">
      </div>
    ')

    @controller = ControllerFactory.getController @element
    
    @superContainer = $('
      <div class="superContainer">
      </div>
    ')

    @areas = []
    @panel = new Panel @element
    @mainPanel = new MainPanel @element

    @panel.buildElement()
    @mainPanel.buildElement()

    @element.append @mainPanel.element

    @element.append @panel.element
    @element.append @superContainer

  bindEvents: ->

    @element
      .on 'focus', (event) =>
        @element.blur()

      .on 'requestUndo', (event) =>
        @commandManager.undo()

      .on 'requestRedo', (event) =>
        @commandManager.redo()

      .on 'requestDelete', (event) =>
        for i in [0..Constants.INIT_NUM_OF_PAGES-1]
          if @areas[i].boxesContainer.getSelectedBoxes().length != 0
            @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, i, @areas[0].boxesContainer.getSelectedBoxes())

      .on 'requestCopy', (event) =>
        for i in [0..Constants.INIT_NUM_OF_PAGES-1]
          if @areas[i].boxesContainer.getSelectedBoxes().length != 0
            @clipboard.pushItems
              pageNum:i
              boxes:@areas[i].boxesContainer.getSelectedBoxes()
            break

      .on 'requestPaste', (event) =>
        items = @clipboard.popItems()
        if items.boxes? and items.boxes.length > 0
          @commandManager.pushCommand @cmdFactory.createCopyBoxesCommand(this, items.pageNum, items.boxes)

      .on 'textColorChanged', (event, hex) =>
        boxSelected = @getSelectedBoxes()
        if boxSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeTextColorCommand(this, boxSelected, hex)

      .on 'graphicContentChanged', (event, params) =>
        pageNum = @getPageNum params.graphic.element
        @commandManager.pushCommand(@cmdFactory.createCreateChangeBoxContentCommand(params.graphic, pageNum, params.prevContent, params.newContent), false)

        boxName = @panel.getBoxName params.graphic.element.attr 'id'
        clone = params.graphic.element.clone()
        clone.children().remove()
        newName = clone.html()
        if boxName.length == 0 and newName.length > 0
          @commandManager.pushCommand @cmdFactory.createChangeBoxNameCommand(this, params.graphic.element.attr('id'), pageNum, '', newName)

      .on 'boxMoved', (event, box, currentPosition, originalPosition) =>
        pageNum = @getPageNum box.element
        @commandManager.pushCommand(@cmdFactory.createMoveBoxCommand(box, pageNum, currentPosition, originalPosition), false)

      .on 'moveElementUpBtnClick', (event, tabIndex) =>
        boxes = @getSelectedBoxes()
        @commandManager.pushCommand @cmdFactory.createMoveUpCommand(this, tabIndex, boxes) if boxes.length > 0

      .on 'moveElementDownBtnClick', (event, tabIndex) =>
        boxes = @getSelectedBoxes()
        @commandManager.pushCommand @cmdFactory.createMoveDownCommand(this, tabIndex, boxes) if boxes.length > 0

      .on 'addTabBtnClick', (event) =>
        if @areas.length < Constants.MAX_NUM_OF_PAGES
          @commandManager.pushCommand @cmdFactory.createAddPageCommand(this)

      .on 'deleteTabBtnClick', (event, tabIndex) =>
        if @areas.length > Constants.INIT_NUM_OF_PAGES
          @commandManager.pushCommand @cmdFactory.createRemovePageCommand(this, tabIndex)

      .on 'panelClickAddBtnClick', (event, tabIndex) =>
        @commandManager.pushCommand @cmdFactory.createCreateBoxesCommand(this, tabIndex)

      .on 'panelClickGridBtnClick', (event) =>
        area.grid.toggleGrid() for area in @areas

      .on 'onRowDeleteBtnClick', (event, tabIndex, boxId) =>
        @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, tabIndex, @root.find('#' + boxId))

      .on 'onRowSliderValChanged', (event, tabIndex, boxId, opacityVal) =>
        @areas[tabIndex].boxesContainer.changeBoxOpacity(boxId, opacityVal)

      .on 'onRowSliderStopValChanged', (event, tabIndex, boxId, prevVal, newVal) =>
        @commandManager.pushCommand @cmdFactory.createChangeOpacityCommand(this, tabIndex, boxId, prevVal, newVal)

      .on 'addBoxRequested', (event, boxCssOptions) =>
        pageNum = @getPageNum $(event.target)
        @commandManager.pushCommand @cmdFactory.createCreateBoxesCommand(this, pageNum, [boxCssOptions])

      .on 'fontTypeChanged', (event, newFontType) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeFontTypeCommand(this, boxesSelected, newFontType)

      .on 'fontSizeChanged', (event, newFontSize) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeFontSizeCommand(this, boxesSelected, newFontSize)

      .on 'letterSpaceChanged', (event, newletterSpace) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeLetterSpaceCommand(this, boxesSelected, newletterSpace)

      .on 'lineHeightChanged', (event, newLineHeight) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeLineHeightCommand(this, boxesSelected, newLineHeight)

      .on 'paddingChanged', (event, newPadding) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangePaddingCommand(this, boxesSelected, newPadding)

      .on 'fontWeightBtnEnableClick', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeFontWeightCommand(this, boxesSelected, true)

      .on 'fontWeightBtnDisableClick', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeFontWeightCommand(this, boxesSelected, false)

      .on 'fontUnderlinedBtnEnableClick', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeUnderlineFontCommand(this, boxesSelected, true)

      .on 'fontUnderlinedBtnDisableClick', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeUnderlineFontCommand(this, boxesSelected, false)

      .on 'fontItalicBtnEnableClick', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeItalicFontCommand(this, boxesSelected, true)

      .on 'fontItalicBtnDisableClick', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createChangeItalicFontCommand(this, boxesSelected, false)

      .on 'rightAlignment', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createRightAlignmentCommand(this, boxesSelected)

      .on 'leftAlignment', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createLeftAlignmentCommand(this, boxesSelected)

      .on 'centerAlignment', (event) =>
        boxesSelected = @getSelectedBoxes()
        if boxesSelected.length != 0
          @commandManager.pushCommand @cmdFactory.createCenterAlignmentCommand(this, boxesSelected)

      .on 'bulletPointBtnEnableClick', (event) =>
        boxesSelected = @getSelectedBoxes()
        pageNum = @getPageNum(boxesSelected)
        boxes = @areas[pageNum].boxesContainer.getBoxesFromSelector(boxesSelected.eq(0))
        box.addBulletPoint() for id, box of boxes

      .on 'orderedPointBtnEnableClick', (event) =>
        boxesSelected = @getSelectedBoxes()
        pageNum = @getPageNum(boxesSelected)
        boxes = @areas[pageNum].boxesContainer.getBoxesFromSelector(boxesSelected.eq(0))
        box.addOrderedPointList() for id, box of boxes

      .on 'boxNameChanged', (event, boxid, pageNum, prevVal, newVal) =>
        @commandManager.pushCommand @cmdFactory.createChangeBoxNameCommand(this, boxid, pageNum, prevVal, newVal), false


    @panel.bindEvents()
    @controller.bindEvents()
    @mainPanel.bindEvents()

    for i in [0..Constants.INIT_NUM_OF_PAGES-1]
      cmd = @cmdFactory.createAddPageCommand(this)
      cmd.execute();

  ###
  Returns a selector to the currently selected boxes
  ###
  getSelectedBoxes: ->
    return @element.find '.ppedit-box:focus, .ppedit-box-selected, .ppedit-box-focus'

  getPageNum:(boxSelector) ->
    return boxSelector.parents('.editContainer').index()

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

    @commandManager.initNumOfPages = @areas.length

  ###
  Returns a JSON string containing a description of
  all the boxes currently existing in the editor.
  ###
  getAllHunks: ->
      return JSON.stringify (@area.boxesContainer.getAllHunks() for area in @areas)

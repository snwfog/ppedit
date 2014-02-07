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

  @NUMBER_OF_PAGES: 1

  constructor: (@root) ->
    super @root

    @clipboard = new Clipboard
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
    
    @superPanel = $('
      <div class="superPanel" style="clear:both;">
      </div>
    ')

    @areas = []
    @panels = []
    @mainPanel = new MainPanel @element
    @fontPanel = new FontPanel row

    for i in [0..PPEditor.NUMBER_OF_PAGES-1]
      @areas.push new EditArea row
      @panels.push new Panel row

    for i in [0..PPEditor.NUMBER_OF_PAGES-1]
      @areas[i].buildElement()
      @panels[i].buildElement()

    @mainPanel.buildElement()
    @fontPanel.buildElement()

    

    for i in [0..PPEditor.NUMBER_OF_PAGES-1]
      @superContainer.append $('<div class="editContainer  shadow-effect"></div>').append @areas[i].element
      @superPanel.append $('<div class="panelContainer" style="clear:both;"></div>').append @panels[i].element

    @element.append @mainPanel.element
    row.append @superContainer
    row.append @fontPanel.element
    row.append @superPanel

  bindEvents: ->

    @element
      .on 'requestUndo', (event) =>
        @commandManager.undo()

      .on 'requestRedo', (event) =>
        @commandManager.redo()

      .on 'requestDelete', (event) =>
        for i in [0..PPEditor.NUMBER_OF_PAGES-1]
          if @areas[i].boxesContainer.getSelectedBoxes().length != 0
            @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, i, @areas[0].boxesContainer.getSelectedBoxes())

      .on 'requestCopy', (event) =>
        for i in [0..PPEditor.NUMBER_OF_PAGES-1]
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
          @commandManager.pushCommand @cmdFactory.createChangeTextColorCommand(this, @getPageNum(boxSelected), @areas[0].boxesContainer.getSelectedBoxes(), hex)

      .on 'graphicContentChanged', (event, params) =>
        @commandManager.pushCommand(@cmdFactory.createCreateChangeBoxContentCommand(params.graphic, params.prevContent, params.newContent), false)

      .on 'boxMoved', (event, box, currentPosition, originalPosition) =>
        @commandManager.pushCommand(@cmdFactory.createMoveBoxCommand(box, currentPosition, originalPosition), false) 

    @element.find('.row')
      .on 'moveElementUpBtnClick', (event) =>
        boxes = @getSelectedBoxes()
        pageNum = @getPanelNum $(event.target)
        @commandManager.pushCommand @cmdFactory.createMoveUpCommand(this, pageNum, boxes) if boxes.length > 0

      .on 'moveElementDownBtnClick', (event) =>
        boxes = @getSelectedBoxes()
        pageNum = @getPanelNum $(event.target)
        @commandManager.pushCommand @cmdFactory.createMoveDownCommand(this, pageNum, boxes) if boxes.length > 0

      .on 'panelClickAddBtnClick', (event) =>
        pageNum = @getPanelNum $(event.target)
        @commandManager.pushCommand @cmdFactory.createCreateBoxesCommand(this, pageNum)

      .on 'panelClickGridBtnClick', (event) =>
        area.grid.toggleGrid() for area in @areas

      .on 'onRowDeleteBtnClick', (event, boxId) =>
        pageNum = @getPanelNum $(event.target)
        @commandManager.pushCommand @cmdFactory.createRemoveBoxesCommand(this, pageNum, @root.find('#' + boxId))

     .on 'onRowSliderValChanged', (event, boxId, opacityVal) =>
       pageNum = @getPanelNum $(event.target)
       @areas[pageNum].boxesContainer.changeBoxOpacity(boxId, opacityVal)

      .on 'onRowSliderStopValChanged', (event, boxId, prevVal, newVal) =>
        pageNum = @getPanelNum $(event.target)
        @commandManager.pushCommand @cmdFactory.createChangeOpacityCommand(this, pageNum, boxId, prevVal, newVal)

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

#      .on 'unSelectBoxes', (event) =>
#        @element.find('.ppedit-box')
#          .removeClass('ppedit-box-focus')
#          .removeClass('ppedit-box-selected')

      .on 'boxSelected', (event, box) =>
        @fontPanel.setSettingsFromStyle box.element.get(0).style

    for i in [0..PPEditor.NUMBER_OF_PAGES-1]
      @areas[i].bindEvents()
      @panels[i].bindEvents()

    @fontPanel.bindEvents()
    @controller.bindEvents()
    @mainPanel.bindEvents()

  ###
  Returns a selector to the currently selected boxes
  ###
  getSelectedBoxes: ->
    return @element.find '.ppedit-box:focus, .ppedit-box-selected, .ppedit-box-focus'

  getPageNum:(boxSelector) ->
    return boxSelector.parents('.editContainer').index()

  getPanelNum:(panelElement) ->
    return panelElement.parents('.panelContainer').index()

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
    return JSON.stringify (@area.boxesContainer.getAllHunks() for area in @areas)
#= require Graphic
#= require EditArea
#= require Panel
#= require Grid
#= require Box
#= require CommandManager
#= require ControllerFactory
#= require RemoveBoxesCommand
#= require CreateBoxCommand

class PPEditor extends Graphic

  constructor: (@root) ->
    super @root

    @controller = ControllerFactory.getController @root
    @commandManager = new CommandManager
    @area = undefined
    @panel = undefined

  buildElement: ->
    @element = $('
      <div class="container">
        <div class="row"></div>
      </div>
    ')

    row = @element.find('.row')
    @area = new EditArea row
    @panel = new Panel row
    @area.buildElement()
    @panel.buildElement()

    row.append @area.element
    row.append @panel.element

  bindEvents: ->

    @controller.bindEvents()
    @controller.root
      .on 'requestUndo', (event) =>
        @commandManager.undo()

      .on 'requestRedo', (event) =>
        @commandManager.redo()

      .on 'requestDelete', (event) =>
        @commandManager.pushCommand new RemoveBoxesCommand this, @area.boxesContainer.getSelectedBoxes()

    @element.find('.row')
      .on 'panelClickAddBtnClick', (event) =>
        @commandManager.pushCommand new CreateBoxCommand this

      .on 'panelClickGridBtnClick', (event) =>
        @area.grid.toggleGrid()
    
      .on 'panelClickClearAllBtnClick', (event) =>
        @commandManager.pushCommand new RemoveBoxesCommand this, @area.boxesContainer.getAllBoxes()
    
      .on 'onRowDeleteBtnClick', (event, boxId) =>
        @commandManager.pushCommand new RemoveBoxesCommand this, @root.find('#' + boxId)

      .on 'onRowSliderValChanged', (event, boxId, opacityVal) =>
        @area.boxesContainer.chageBoxOpacity(boxId, opacityVal)

    @area.boxesContainer.element.on 'boxMoved', (event, box, currentPosition, originalPosition) =>
      @commandManager.pushCommand(new MoveBoxCommand(box, currentPosition, originalPosition), false)

    @area.bindEvents()
    @panel.bindEvents()
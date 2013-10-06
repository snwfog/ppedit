#= require EditorManager
#= require Panel
#= require Grid
#= require Box
#= require CommandManager
#= require ControllerFactory
#= require RemoveBoxesCommand
#= require CreateBoxCommand

class PPEditor

  constructor: (@root) ->

    @controller = ControllerFactory.getController @root

    @commandManager = new CommandManager

    @element = $('
      <div class="container">
        <div class="row"></div>
      </div>
    ')
    @root.append(@element)

    @controller.bindEvents()
    @controller.root
      .on 'requestUndo', (event) =>
        @commandManager.undo()

      .on 'requestRedo', (event) =>
        @commandManager.redo()

      .on 'requestDelete', (event) =>
        @commandManager.pushCommand new RemoveBoxesCommand this, @editorManager.boxesContainer.getSelectedBoxes()

    row = @element.find('.row')
    @editorManager = new EditorManager row
    @panel = new Panel row

    row.on 'panelClickAddBtnClick', (event) =>
      @commandManager.pushCommand new CreateBoxCommand this

    row.on 'panelClickGridBtnClick', (event) =>
      @editorManager.grid.toggleGrid()
    
    row.on 'panelClickClearAllBtnClick', (event) =>
      @commandManager.pushCommand new RemoveBoxesCommand this, @editorManager.boxesContainer.getAllBoxes()
    
    row.on 'onRowDeleteBtnClick', (event, boxId) =>
      @commandManager.pushCommand new RemoveBoxesCommand this, @root.find('#' + boxId)

    row.on 'onRowSliderValChanged', (event, boxId, opacityVal) =>
      @editorManager.boxesContainer.chageBoxOpacity(boxId, opacityVal)

    @editorManager.boxesContainer.element.on 'boxMoved', (event, box, currentPosition, originalPosition) =>
      @commandManager.pushCommand(new MoveBoxCommand(box, currentPosition, originalPosition), false)

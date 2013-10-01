#= require EditorManager
#= require Panel
#= require Grid

class Controller

  constructor: (@root) ->
    @element = $('
      <div class="container">
        <div class="row"></div>
      </div>')
    @root.append(@element)

    row = @element.find('.row')
    @editorManager = new EditorManager row
    @panel = new Panel row

    row.on 'panelClickAddBtnClick', (event) =>
      @editorManager.createBox()

    row.on 'panelClickDeleteBtnClick', (event) =>
      @editorManager.removeBox()

    row.on 'panelClickGridBtnClick', (event) =>
      @editorManager.grid.toggleGrid()



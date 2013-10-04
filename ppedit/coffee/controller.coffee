#= require EditorManager
#= require Panel
#= require Grid
#= require Box

class Controller

  constructor: (@root) ->
    @element = $('
      <div class="container">
        <div class="row"></div>
      </div>
    ')
    @root.append(@element)

    row = @element.find('.row')
    @editorManager = new EditorManager row
    @panel = new Panel row

    row.on 'panelClickAddBtnClick', (event) =>
      box = @editorManager.boxesContainer.createBox()
      @panel.addElement "dataPanel", box.element.attr('id')

    row.on 'panelClickDeleteBtnClick', (event) =>
      @editorManager.boxesContainer.removeBox()

    row.on 'panelClickGridBtnClick', (event) =>
      @editorManager.grid.toggleGrid()

    row.on 'onRowSliderValChanged', (event, boxId, opacityVal) =>
      @editorManager.boxesContainer.chageBoxOpacity(boxId, opacityVal)



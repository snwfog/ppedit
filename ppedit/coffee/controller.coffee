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

    row.on 'panelClickGridBtnClick', (event) =>
      @editorManager.grid.toggleGrid()
    
    row.on 'panelClickClearAllBtnClick', (event) =>
      @editorManager.boxesContainer.removeBoxes()
    
    row.on 'onRowDeleteBtnClick', (event, boxId) =>
      @editorManager.boxesContainer.removeBoxes [boxId]

    row.on 'onRowSliderValChanged', (event, boxId, opacityVal) =>
      @editorManager.boxesContainer.chageBoxOpacity(boxId, opacityVal)

      



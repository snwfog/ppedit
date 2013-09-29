#= require EditorManager
#= require Panel

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
    createBoxbutton = $("<button>Create Box</button>")
    createRemovebutton = $("<button>Remove Box</button>")
    $('body').append(createBoxbutton);
    $('body').append(createRemovebutton);
    createBoxbutton.click =>
      @editorManager.createBox()
    createRemovebutton.click =>
      @editorManager.removeBox()




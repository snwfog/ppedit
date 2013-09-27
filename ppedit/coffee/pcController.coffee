#= require Controller
#= require EditorManager

class PCController extends Controller
  
  constructor: (@root) ->
    super @root

  onCtrlZPressed: ->
    $(document).bind 'keypress', 'Ctrl+z', (event) =>
      @editorManager.undo()

  onCtrlYPressed: ->
    $(document).bind 'keypress', 'Ctrl+y', (event) =>
      @editorManager.redo()

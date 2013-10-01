#= require Controller
#= require EditorManager

class PCController extends Controller
  
  constructor: (@root) ->
    super @root
    @editorManager.root.keydown (event) =>

      if event.keyCode == 90 && event.ctrlKey
        event.preventDefault()
        @editorManager.undo()

      if event.keyCode == 89 && event.ctrlKey
        event.preventDefault()
        @editorManager.redo()

      if event.keyCode == 46 || (event.keyCode == 46 && event.ctrlKey)
        event.preventDefault()
        @editorManager.deleteOnFocus()

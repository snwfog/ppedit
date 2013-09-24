#= require CreateBoxCommand
#= require MoveBoxCommand

class EditorManager

  constructor: (@root) ->
    @undoStack = []
    @redoStack = []
    @boxes = []
    @prevMousePosition = undefined
    @build()

  build: ->
    @root.addClass("ppedit-container")
      .mousemove (event) =>
        for box in @boxes
          do (box) =>
            if box.mouseDown && @prevMousePosition?
              delta =
                x: event.clientX - @prevMousePosition.x
                y: event.clientY - @prevMousePosition.y
              currentPos =
                x: parseInt(box.element.css('left'))
                y: parseInt(box.element.css('top'))
              box.element.css 'left', (delta.x + currentPos.x) + 'px'
              box.element.css 'top', (delta.y + currentPos.y) + 'px'

        @prevMousePosition =
          x: event.clientX
          y: event.clientY

      .mouseup =>
        box.mouseDown = false for box in @boxes
        @prevMousePosition = undefined

  createBox: (options) ->
    command = new CreateBoxCommand @root, options
    @pushCommand command
    @boxes.push command.box

  moveBox: (box, newX, newY) ->
    @pushCommand new MoveBoxCommand box, newX, newY

  pushCommand: (command, execute ) ->
    execute = false if !execute?
    command.execute() if execute
    @undoStack.push(command)

  undo: ->
    if @undoStack.length > 0
      lastExecutedCommand = @undoStack.pop
      lastExecutedCommand.undo()
      @redoStack.push(lastExecutedCommand)

  redo: ->
    if @redoStack.length > 0
      @pushCommand @redoStack.pop

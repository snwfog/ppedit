#= require Box

class BoxesContainer

  constructor: (@root) ->
    @boxes = {}
    @undoStack = []
    @redoStack = []

    @element = $('<div></div>')
      .addClass('ppedit-box-container')

    @root.append(@element)

    @element.on 'boxMoved', (event, box, currentPosition, originalPosition) =>
      @_pushCommand(new MoveBoxCommand(box, currentPosition, originalPosition), false)

  ###
  Selects the boxes contained in the passed rect.
  The rect position is relative to the root.
  ###
  selectBoxesInRect: (rect) ->
    # translate rectangle by the scrollPosition
    selectRect =
      topLeft:
        x:rect.topLeft.x + @element.scrollLeft()
        y:rect.topLeft.y + @element.scrollTop()
      size:rect.size

    if selectRect.size.width < 0
      selectRect.topLeft.x -= Math.abs(selectRect.size.width)
      selectRect.size.width = Math.abs(selectRect.size.width)

    if selectRect.size.height < 0
      selectRect.topLeft.y -= Math.abs(selectRect.size.height)
      selectRect.size.height = Math.abs(selectRect.size.height)

    @element.find('.ppedit-box').each (index, box) =>
      $(box).addClass 'ppedit-box-selected' if BoxesContainer._rectContainsRect selectRect, @boxBounds($(box))

  ###
  Returns the bounding rectangle of the box matching the
  passed box selector.
  ###
  boxBounds: (boxSelector) ->
    result =
      topLeft:
        x:boxSelector.position().left + @element.scrollLeft()
        y:boxSelector.position().top + @element.scrollTop()
      size:
        width:boxSelector.width()
        height:boxSelector.height()

  ###
  Creates a new box with the passed options ands adds it to the list.
  ###
  createBox: (options) ->
    @_pushCommand new CreateBoxCommand this, options

  removeBox: (options) ->
    @_pushCommand new RemoveBoxesCommand this

  ###
  Adds the passed Box Object to the Box List
  ###
  addBox: (box) ->
    @element.append box.element
    box.bindEvents()
    @boxes[box.element.attr('id')] = box

  ###
  Deletes the Box objects corresponding to the
  passed boxIds. Passing no arguments will delete
  all Box objects.
  ###
  removeBoxes: (boxIds) ->
    if !boxIds?
      box.element.remove() for boxId, box of @boxes
      @boxes = {}
    else
      for id in boxIds
        @boxes[id].element.remove()
        delete @boxes[id]

  ###
  Returns the Box objects corresponding to the
  passed boxIds. Passing no arguments will return
  all Box objects.
  ###
  getBoxesFromIds: (boxIds) ->
    if boxIds?
      return {id:@boxes[id]} for id in boxIds when @boxes[id]?
    else
      return $.extend(true, {}, @boxes)

  deleteSelectedBoxes: ->
    selectedBoxes = @element.find '.ppedit-box:focus, .ppedit-box-selected'
    if selectedBoxes.length > 0
      @_pushCommand new RemoveBoxesCommand this, selectedBoxes

  ###
  Undo the last executed command
  ###
  undo: ->
    if @undoStack.length > 0
      lastCommand = @undoStack.pop()
      lastCommand.undo()
      @redoStack.push lastCommand

  ###
  Redo the last executed command
  ###
  redo: ->
    if @redoStack.length > 0
      redoCommand = @redoStack.pop()
      redoCommand.execute()
      @undoStack.push redoCommand

  ###
  Inserts the passed command into the undo stack
  flow. This method execute the command by default, set
  the execute argument to false in order to prevent that behavior.
  ###
  _pushCommand: (command, execute ) ->
    command.execute() if !execute? or execute
    @undoStack.push command
    @redoStack.splice 0, @redoStack.length

  ###
  Returns true if the innerRect Rectangle is fully
  contained within the outerRect Rectangle, false otherwise.
  ###
  @_rectContainsRect: (outerRect, innerRect) ->
    return (innerRect.topLeft.x >= outerRect.topLeft.x &&
    innerRect.topLeft.y >= outerRect.topLeft.y &&
    innerRect.topLeft.x + innerRect.size.width <= outerRect.topLeft.x + outerRect.size.width &&
    innerRect.topLeft.y + innerRect.size.height <= outerRect.topLeft.y + outerRect.size.height)








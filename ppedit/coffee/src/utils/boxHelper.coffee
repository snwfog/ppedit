#= require ControllerFactory

###
This class is used to trigger graphicContentChanged Events
for a particular box. This event is fired whenever
the html of the corresponding graphic has changed
###
class BoxHelper

  constructor: (@graphic) ->
    @controller = undefined
    @content = undefined

  bindEvents: ->
    @controller = ControllerFactory.getController @graphic.element
    @graphic.element
      .on 'requestUndo', (event) =>
        @_checkNewContent false
        event.stopPropagation()

      .focus (event) =>
        @_checkNewContent true

      .blur (event) =>
        @_checkNewContent true


    @controller.bindEvents()

  ###
  Checks that the content of the graphic has changed and if it did,
  fire the graphicContentChanged event.
  if saveNewContent is true, the content new content will be saved
  for the next time this function will be called.
  ###
  _checkNewContent: (saveNewContent) ->
    graphicHtml = @graphic.element.html()
    if @content? && @content != graphicHtml
      @graphic.element.trigger 'graphicContentChanged', [{graphic:@graphic, prevContent:@content, newContent:graphicHtml}]
    @content = if saveNewContent then graphicHtml else undefined
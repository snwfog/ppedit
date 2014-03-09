#= require Graphic

class MainPanel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element = $('
            <div class="left-sidebar">
              <div class="main-panel-icon undoImg"></div>
              <div class="main-panel-icon redoImg"></div>
              <div class="main-panel-icon gridImg"></div>
              <div class="main-panel-icon snapImg"></div>
          </div>')

  bindEvents: ->
    @element.find('.snapImg').click =>
      if !$(event.target).hasClass("snapBtn-selected") 
        $(event.target).addClass("snapBtn-selected") 
      else
        $(event.target).removeClass("snapBtn-selected")

    @element.find(".gridImg").click =>
      @root.trigger 'panelClickGridBtnClick'

    @element.find(".undoImg").click =>
      @root.trigger 'requestUndo'

    @element.find(".redoImg").click =>
      @root.trigger 'requestRedo'
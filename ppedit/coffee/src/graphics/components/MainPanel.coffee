#= require Graphic

class MainPanel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element = $('
            <div class="left-sidebar">
              <button class="undoBtn btn btn-default icon-set" type="button"></button>
              <button class="redoBtn btn btn-default icon-set" type="button"></button>
              <button class="gridElementBtn btn btn-default icon-set" type="button"></button>
              <button class="snapBtn btn btn-default icon-set" type="button"></button>
            </div>')

  bindEvents: ->
    @element.find('.snapBtn.btn.btn-default').click =>
      if !$(event.target).hasClass("snapBtn-selected") 
        $(event.target).addClass("snapBtn-selected") 
      else
        $(event.target).removeClass("snapBtn-selected") 

    @element.find('.glyphicon.glyphicon-magnet').click =>
      if !$(event.target).parent().hasClass("snapBtn-selected") 
        $(event.target).parent().addClass("snapBtn-selected") 
      else
        $(event.target).parent().removeClass("snapBtn-selected") 

    @element.find(".gridElementBtn").click =>
      @root.find('.row').trigger 'panelClickGridBtnClick'

    @element.find(".undoBtn").click =>
      @root.find('.row').trigger 'requestUndo'

    @element.find(".redoBtn").click =>
      @root.find('.row').trigger 'requestRedo'
#= require Graphic

class MainPanel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element = $('
            <div class="col-xs-5">
              <button class="undoBtn btn btn-default" type="button"><span class="glyphicon glyphicon-arrow-left"></button>
              <button class="redoBtn btn btn-default" type="button"><span class="glyphicon glyphicon-arrow-right"></button>
              <button class="gridElementBtn btn btn-default" type="button"><span class="glyphicon glyphicon-th-large"></button>
              <button class="snapBtn btn btn-default" type="button"><span class="glyphicon glyphicon-magnet"></button>
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
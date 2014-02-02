#= require Graphic

class MainPanel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element = $('
            <div class="left-sidebar">
              <img class="icon-set undoImg" src="./ppedit/img/icons/glyphicons_221_unshare.png">
              <img class="icon-set redoImg" src="./ppedit/img//icons/glyphicons_222_share.png">
              <img class="icon-set gridImg" src="./ppedit/img/icons/glyphicons_155_show_big_thumbnails.png">
              <img class="icon-set snapImg" src="./ppedit/img/icons/glyphicons_023_magnet.png">
          </div>')

  bindEvents: ->
    @element.find('.snapImg').click =>
      if !$(event.target).hasClass("snapBtn-selected") 
        $(event.target).addClass("snapBtn-selected") 
      else
        $(event.target).removeClass("snapBtn-selected") 

    @element.find(".gridImg").click =>
      @root.find('.row').trigger 'panelClickGridBtnClick'

    @element.find(".undoImg").click =>
      @root.trigger 'requestUndo'

    @element.find(".redoImg").click =>
      @root.trigger 'requestRedo'
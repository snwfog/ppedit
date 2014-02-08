#= require Graphic

class MainPanel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element = $('
            <div class="left-sidebar">
              <img class="icon-set undoImg" src="./ppedit/img/icons/OFF/glyphicons_221_unshare.png">
              <img class="icon-set redoImg" src="./ppedit/img//icons/OFF/glyphicons_222_share.png">
              <img class="icon-set gridImg" src="./ppedit/img/icons/OFF/glyphicons_155_show_big_thumbnails.png">
              <img class="icon-set snapImg" src="./ppedit/img/icons/OFF/glyphicons_023_magnet.png">
          </div>')

  bindEvents: ->
    @element.find('.snapImg').click =>
      if !$(event.target).hasClass("snapBtn-selected") 
        $(event.target).addClass("snapBtn-selected") 
      else
        $(event.target).removeClass("snapBtn-selected") 
    
    @element.find('.snapImg').mouseover (event) =>
      $(event.target).attr('src', './ppedit/img/icons/ON/glyphicons_023_magnet.png')
    @element.find('.snapImg').mouseout (event) =>
      $(event.target).attr('src', './ppedit/img/icons/OFF/glyphicons_023_magnet.png')



    @element.find(".gridImg").click =>
      @root.find('.row').trigger 'panelClickGridBtnClick'

    @element.find('.gridImg').mouseover (event) =>
      $(event.target).attr('src', './ppedit/img/icons/ON/glyphicons_155_show_big_thumbnails.png')
    @element.find('.gridImg').mouseout (event) =>
      $(event.target).attr('src', './ppedit/img/icons/OFF/glyphicons_155_show_big_thumbnails.png')

    @element.find(".undoImg").click =>
      @root.trigger 'requestUndo'

    @element.find('.undoImg').mouseover (event) =>
      $(event.target).attr('src', './ppedit/img/icons/ON/glyphicons_221_unshare.png')
    @element.find('.undoImg').mouseout (event) =>
      $(event.target).attr('src', './ppedit/img/icons/OFF/glyphicons_221_unshare.png')

    @element.find(".redoImg").click =>
      @root.trigger 'requestRedo'

    @element.find('.redoImg').mouseover (event) =>
      $(event.target).attr('src', './ppedit/img/icons/ON/glyphicons_222_share.png')
    @element.find('.redoImg').mouseout (event) =>
      $(event.target).attr('src', './ppedit/img/icons/OFF/glyphicons_222_share.png')
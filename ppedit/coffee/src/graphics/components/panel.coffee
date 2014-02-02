#= require Graphic

###
Graphic containing the settings to apply to boxes.
###
class Panel extends Graphic
  constructor: (@root) ->
    @prevOpacityVal = undefined
    super @root

  buildElement: ->
    @element = $('
      <div>
          <!-- Sidebar Right -->
        <div class="menu-right-btn right-sidebar-btn shadow-effect">
            <span class="vertical-text">Page 1</span>
        </div>

        <div class="menu-right-container right-sidebar-container shadow-effect">

          <!-- Row 1 Menu  -->
          <span class="right-sidebar-menu1">
            <span class="moveElementUpBtn glyphicon glyphicon-arrow-up btn-lg"></span>
            <span class="moveElementDownBtn glyphicon glyphicon-arrow-down btn-lg"></span>
            <span class="addElementBtn glyphicon glyphicon-plus btn-lg"></span>
          </span>

          <!-- Row 2 Menu -->
          <span>
            <table class="right-sidebar-menu2" cellspacing="0px" cellpadding="0px">
            </table>
          </span>
        </div>

      </div>')

  bindEvents: ->

    @element.find(".addElementBtn").click =>
      @element.trigger 'panelClickAddBtnClick'

    @element.find('.moveElementUpBtn').click =>
      @element.trigger 'moveElementUpBtnClick'

    @element.find('.moveElementDownBtn').click =>
      @element.trigger 'moveElementDownBtnClick'

    @element.find('.menu-right-btn').click (event) =>
      el = $(event.target)
      if @element.find('.menu-right-btn').css("margin-right") == "350px"
        @element.find('.menu-right-container').animate {"margin-right": '-=350'}
        @element.find('.menu-right-btn').animate {"margin-right": '-=350'}
      else
        @element.find('.menu-right-container').animate {"margin-right": '+=350'}
        @element.find('.menu-right-btn').animate {"margin-right": '+=350'}


  ###
  Adds a row to be associated with the passed box id.
  ### 
  addBoxRow: (boxid, index) ->
    newRow = $('
        	<tr class="ppedit-panel-row">
        		<td style="width:10%">
        			<span class="deleteElementBtn glyphicon glyphicon-remove-sign btn-lg"></span>
    		    </td>
            <td style="width:50%">
            <input type="text" class="form-control" placeholder="Element 1">
            </td>
            <td style="width:40%">
              <div class="ppedit-slider"></div>
            </td>
    	    </tr>
    	      ')
    .attr('ppedit-box-id', boxid)

    if !index? or index == 0
      @element.find('.right-sidebar-menu2').prepend newRow
    else
      newRow.insertBefore @element.find('.ppedit-panel-row:nth-child("' + index + '")')

    newRow.find(".ppedit-slider")
      .slider(
          min: 0
          max: 100
          step: 1
          value: 100
        )
      .on 'slideStart', (event) =>
        @prevOpacityVal = $(event.target).val() or 100
      .on 'slide', (event) =>
        opacityVal = $(event.target).val()
        $(event.target).trigger 'onRowSliderValChanged', [boxid, parseInt(opacityVal)/100]
      .on 'slideStop', (event) =>
        opacityStopVal = $(event.target).val()
        if @prevOpacityVal != opacityStopVal
          $(event.target).trigger 'onRowSliderStopValChanged', [boxid, parseInt(@prevOpacityVal)/100, parseInt(opacityStopVal)/100]
        @prevOpacityVal = undefined

    newRow.find(".deleteElementBtn").on 'click', (event) =>
        $(event.target).trigger 'onRowDeleteBtnClick', [boxid]

  ###
  Removes the row associated with the passed box id.
  ###
  removeBoxRow: (boxId) ->
    @getRowWithBoxId(boxId).remove()

  ###
  Returns a selector matching the row associated with
  the passed box Id.
  ###
  getRowWithBoxId: (boxId) ->
    @element.find("tr[ppedit-box-id="+ boxId + "]").eq(0)

  ###
  Returns a selector matching the row at the specified index.
  ###
  getRowAtIndex: (index) ->
    @element.find(".ppedit-panel-row").eq(index)

  ###
  Sets the name of the row.
  ###
  setRowName: (boxId, name) ->
    @getRowWithBoxId(boxId).find('ppedit-rowName').val(name)

  ###
  Returns a selector matching with all rows.
  ###
  getRows: ->
    @element.find(".ppedit-panel-row")
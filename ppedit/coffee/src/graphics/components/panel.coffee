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
      <div class="menu-sidebar">
          <!-- Sidebar Right -->
        <div class="menu-tab-sidebar">
            <div class="minimize-sidebar-btn shadow-effect">
                <span class="minimize-text">&lt;&lt;</span>
            </div>
            <div class="menu-tab-pages">
               <div class="page-sidebar-tab menu-right-btn shadow-effect">
                      <span class="vertical-text">Page 1</span>
               </div>
            </div>
         </div>

        <div class="menu-right-container right-sidebar-container shadow-effect">

          <!-- Row 1 Menu  -->
          <div class="right-sidebar-menu1">
            <div class="moveElementUpBtn menu-panel-icon"></div>
            <div class="moveElementDownBtn menu-panel-icon"></div>
            <div class="addElementBtn menu-panel-icon"></div>
          </div>

          <!-- Row 2 Menu -->
          <span>
            <table class="right-sidebar-menu2" cellspacing="0px" cellpadding="2px">
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

    @element.find('.minimize-sidebar-btn').click (event) =>
      if @element.css("right") == "0px"
        @element.animate {"right": '+=350'}
      else
        @element.animate {"right": '-=350'}


  ###
  Adds a row to be associated with the passed box id.
  ### 
  addBoxRow: (boxid, index) ->
    newRow = $('
        	<tr class="ppedit-panel-row">
        		<td style="width:10%">
        			<div class="deleteElementBtn menu-panel-icon"></div>
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
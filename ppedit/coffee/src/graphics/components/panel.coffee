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
            </div>

            <div class="add-tab-sidebar-btn shadow-effect">
                <span class="add-text">+</span>
            </div>
        </div>

         <div class="right-sidebar-container shadow-effect">

            <!-- Row 1 Menu  -->
            <div class="right-sidebar-menu1">
              <div class="moveElementUpBtn menu-panel-icon"></div>
              <div class="moveElementDownBtn menu-panel-icon"></div>
              <div class="addElementBtn menu-panel-icon"></div>
            </div>

          </div>
      </div>')

  bindEvents: ->
    @element.find(".addElementBtn").click =>
      @element.trigger 'panelClickAddBtnClick', [@_getDisplayedTabIndex()]

    @element.find('.moveElementUpBtn').click =>
      @element.trigger 'moveElementUpBtnClick', [@_getDisplayedTabIndex()]

    @element.find('.moveElementDownBtn').click =>
      @element.trigger 'moveElementDownBtnClick', [@_getDisplayedTabIndex()]

    @element.find('.minimize-sidebar-btn').click (event) =>
      @element.toggleClass('menu-sidebar-open');

  addNewTab: ->
    @insertTab @element.find('.page-sidebar-tab').length

  insertTab: (tabIndex) ->
    newPageIndex = Math.max(tabIndex, @element.find('.page-sidebar-tab').length)

    # Add tab header
    tab = $('
           <a href="#ppedit-page-'+ (newPageIndex) + '">
                  <div class="page-sidebar-tab menu-right-btn shadow-effect">
                    <span class="vertical-text">Page ' + (newPageIndex + 1) + '</span>
                  </div>
           </a>
    ')

    if newPageIndex == 0
      @element.find('.menu-tab-pages').append(tab)
    else
      tab.insertAfter(@element.find('.menu-tab-pages a').eq(newPageIndex-1))

    tab
      .click (event) =>
        @_displayTab newPageIndex

      # Increment all subsequent tabIndexes by 1.
      .nextAll('a').each (el, index) =>
        $(el)
          .attr('href', '#ppedit-page-' + (newPageIndex + index + 1))
          .html('
            <div class="page-sidebar-tab menu-right-btn shadow-effect">
              <span class="vertical-text">Page ' + (newPageIndex + index + 2) + '</span>
            </div>
          ')
          .click =>
            @_displayTab newPageIndex + index + 1
        console.log el

    rowContainer = $('
      <!-- Row 2 Menu -->
      <div class="ppedit-row-container">
        <table class="right-sidebar-menu2" cellspacing="0px" cellpadding="2px">
        </table>
      </div>
    ')

    if newPageIndex == 0
      @element.find('.right-sidebar-container').append(rowContainer)
    else
      rowContainer.insertAfter(@element.find('.ppedit-row-container').eq(newPageIndex-1))

    @element
      .find('.ppedit-row-container')
      .removeClass('ppedit-row-container-active')
      .eq(newPageIndex)
      .addClass('ppedit-row-container-active')

  ###
  Adds a row to be associated with the passed box id.
  ### 
  addBoxRow: (tabIndex, boxid, index) ->
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
      @_getRowContainer(tabIndex).find('.right-sidebar-menu2').prepend newRow
    else
      newRow.insertBefore(@_getRowContainer(tabIndex).find('.ppedit-panel-row:nth-child("' + index + '")'))

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
        $(event.target).trigger 'onRowSliderValChanged', [tabIndex, boxid, parseInt(opacityVal)/100]
      .on 'slideStop', (event) =>
        opacityStopVal = $(event.target).val()
        if @prevOpacityVal != opacityStopVal
          $(event.target).trigger 'onRowSliderStopValChanged', [tabIndex, boxid, parseInt(@prevOpacityVal)/100, parseInt(opacityStopVal)/100]
        @prevOpacityVal = undefined

    newRow.find(".deleteElementBtn").on 'click', (event) =>
        $(event.target).trigger 'onRowDeleteBtnClick', [tabIndex, boxid]

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
  getRowAtIndex: (tabIndex, index) ->
    @_getRowContainer(tabIndex).find(".ppedit-panel-row").eq(index)

  ###
  Sets the name of the row.
  ###
  setRowName: (boxId, name) ->
    @getRowWithBoxId(boxId).find('ppedit-rowName').val(name)

  ###
  Returns a selector matching with all rows.
  ###
  getRows:(tabIndex) ->
    @_getRowContainer(tabIndex).find(".ppedit-panel-row")

  _displayTab:(tabIndex) ->
    @element
      .find('.ppedit-row-container')
      .removeClass('ppedit-row-container-active')
      .eq(tabIndex)
      .addClass('ppedit-row-container-active')

  removeTab:(tabIndex) ->
    @_getRowContainer(tabIndex).remove()
    @element
      .find('.page-sidebar-tab').eq(tabIndex)
      .remove()

  _getRowContainer:(tabIndex) ->
    @element.find('.ppedit-row-container').eq(tabIndex)

  _getDisplayedRowContainer: ->
    @element.find('.ppedit-row-container-active').eq(0)

  _getDisplayedTabIndex: ->
    @_getDisplayedRowContainer().index() - 1
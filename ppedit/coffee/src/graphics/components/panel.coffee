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
            <div class="col-xs-5">

              <form class="form-inline" role="form" style="padding-top: 5px;">
                <div class="form-group col-lg-20">
                  <fieldset style="padding-left: 15px;">

                      <button class="btn btn-sm btn-primary addElementBtn" type="button" style="width: 150px;"><span class="glyphicon glyphicon-plus-sign"></span> Add Element</button>

                      <button class="btn btn-sm btn-info moveElementUpBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-up"></span></button>
                      
                      <button class="btn btn-sm btn-info moveElementDownBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-down"></span></button> 

                      <table class="table table-hover dataPanel">
                          <thead>
                              <tr>
                                <th>Remove</th>
                                <th>Name of Element</th>
                                <th>Opacity</th>
                              </tr>
                          </thead>
                          <tbody>

                          </tbody>
                      </table>
                      <!-- <button type="submit" class="btn btn btn-success" style="float: right;">Save</button> -->
                  </fieldset>
                </div>
              </form>
            </div>')

  bindEvents: ->

    @element.find(".addElementBtn").click =>
      @element.trigger 'panelClickAddBtnClick'

    @element.find('.moveElementUpBtn').click =>
      @element.trigger 'moveElementUpBtnClick'

    @element.find('.moveElementDownBtn').click =>
      @element.trigger 'moveElementDownBtnClick'

  ###
  Adds a row to be associated with the passed box id.
  ### 
  addBoxRow: (boxid, index) ->
    newRow = $("
            <tr class='ppedit-panel-row'>
                <td><span class=\"glyphicon glyphicon-remove-sign icon-4x red deleteElementBtn\"></span></td>
                <td><p class='ppedit-rowName'></p>
                <td><div class=\"ppedit-slider\"></div></td>
            </tr>")
    .attr('ppedit-box-id', boxid)

    if !index? or index == 0
      @element.find('.dataPanel tbody').prepend newRow
    else
      newRow.insertBefore @element.find('tbody .ppedit-panel-rown:nth-child("' + index + '")')

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

    newRow.find(".deleteElementBtn")
      .on 'click', (event) =>
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
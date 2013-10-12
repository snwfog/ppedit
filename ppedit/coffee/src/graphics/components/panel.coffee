#= require Graphic

class Panel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element = $('
            <div class="col-xs-5">

               <!-- <button class="btn btn-sm btn-info moveElementUpBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-up"></span></button>
              <button class="btn btn-sm btn-info moveElementDownBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-down"></span></button> 
                -->
              <form class="form-inline" role="form" style="padding-top: 5px;">
                <div class="form-group col-lg-20">
                  <fieldset style="padding-left: 15px;">
                    <input class="form-control form-control input-lg" id="focusedInput" type="text" placeholder="Name of document">
                      <span class="help-block">Example: My Resume</span>

                      <hr>

                      <button class="btn btn-sm btn-primary addElementBtn" type="button"><span class="glyphicon glyphicon-plus-sign"></span> Add Element</button>

                      <button class="btn btn-primary btn-sm gridElementBtn" type="button"><span class="glyphicon glyphicon-th-large"></span> Grid</button>

                      <button class="btn btn-primary btn-sm" type="button"><span class="glyphicon glyphicon-magnet"></span> Snap</button>

                      <button class="btn btn-warning btn-sm clearAllElementBtn" type="button"><span class="glyphicon glyphicon-trash"></span> Clear All</button>


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
                    
                    <button type="submit" class="btn btn btn-success" style="float: right;">Save</button>
                  </fieldset>
                </div>
              </form>
            </div>')

  bindEvents: ->
    $(".addElementBtn").click =>
      @root.trigger 'panelClickAddBtnClick'

    $(".clearAllElementBtn").click =>
      @root.trigger 'panelClickClearAllBtnClick'

    $(".gridElementBtn").click =>
      @root.trigger 'panelClickGridBtnClick'

  moveElementUp: (panelID) ->

  moveElementUpDown: (panelID) ->

  ###
  Adds a row to be associated with the passed box id.
  ###
  addBoxRow: (boxid) ->
    newRow = $("
            <tr>
                <td><span class=\"glyphicon glyphicon-remove-sign icon-4x red deleteElementBtn\"></span></td>
                <td><input type=\"text\" class=\"input-block-level\" placeholder=\"Enter name\"></input></td>
                <td><div class=\"ppedit-slider\"></div></td>
            </tr>")
    .attr('ppedit-box-id', boxid)

    @element.find('.dataPanel tbody').append newRow

    newRow.find(".ppedit-slider")
      .slider(
          min: 0
          max: 100
          step: 1
          value: 100
        )
      .on 'slide', (event) =>
          opacityVal = $(event.target).val()
          @root.trigger 'onRowSliderValChanged', [boxid, parseInt(opacityVal)/100]

    newRow.find(".deleteElementBtn")
      .on 'click', (event) =>
          @root.trigger 'onRowDeleteBtnClick', [boxid]

  ###
  Removes the row associated with the passed box id.
  ###
  removeBoxRow: (boxId) ->
    @element.find("tr[ppedit-box-id="+ boxId + "]").remove()
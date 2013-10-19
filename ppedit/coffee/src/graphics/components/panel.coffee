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


               <select class="fontTypeBtn">
                 <option value="Times New Roman" selected>Times New Roman</option>
                 <option value="Arial">Arial</option>
                 <option value="Inconsolata">Inconsolata</option>
                 <option value="Glyphicons Halflings">Glyphicons Halflings</option>
               </select>
               
               <select class="fontSizeBtn">
                 <option value="6">6</option>
                 <option value="8">8</option>
                 <option value="10" selected>10</option>
                 <option value="11">11</option>
                 <option value="12">12</option>
                 <option value="14">14</option>
                 <option value="16">16</option>
                 <option value="20">20</option>
               </select>

               <button class="weightBtn" type="button">B</button>
               <button class="underlineBtn" type="button">U</button>
               <button class="italicBtn" type="button">I</button>

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

    @element.find("select.fontTypeBtn").change (event) =>
      newFontType = $(event.target).find("option:selected").val()
      @root.trigger 'fontTypeChanged', [newFontType]

    @element.find("select.fontSizeBtn").change (event) =>
      newFontSize = $(event.target).find("option:selected").val()+"0%"
      @root.trigger 'fontSizeChanged', [newFontSize]

    @element.find(".weightBtn").click (event) =>
      btn = $(event.target).toggleClass('.ppedit-btn-enabled');
      @root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'fontWeightBtnEnableClick' else 'fontWeightBtnDisableClick')

    @element.find(".underlineBtn").click (event) =>
      btn = $(event.target).toggleClass('.ppedit-btn-enabled');
      @root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'fontUnderlinedBtnEnableClick' else 'fontUnderlinedBtnDisableClick')

    @element.find(".italicBtn").click (event) =>
      btn = $(event.target).toggleClass('.ppedit-btn-enabled');
      @root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'fontItalicBtnEnableClick' else 'fontItalicBtnDisableClick')

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
class Panel
  constructor: (@root) ->

    @element = $('
        <div class="col-xs-5">
          
           <button class="btn btn-sm btn-info moveElementUpBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-up"></span></button>

           <button class="btn btn-sm btn-info moveElementDownBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-down"></span></button>

          <button class="btn btn-sm btn-primary addElementBtn" type="button"><span class="glyphicon glyphicon-plus-sign"></span> Add Element</button>


          <button class="btn btn-sm btn-primary removeElementBtn" type="button"><span class="glyphicon glyphicon-minus-sign"></span> Delete Element</button>
          
          <button class="btn btn-primary btn-sm gridElementBtn" type="button"><span class="glyphicon glyphicon-th-large"></span> Grid</button>
          
          <table class="table table-hover" id="dataPanel">
              <thead>   
                  <tr>
                    <th>Selector</th>
                    <th>Name of Element</th>
                    <th>Opacity</th>
                  </tr>
              </thead>
              <tbody>
                

              </tbody>
          </table>
        </div>')

    @root.append(@element)

    $(".moveElementUpBtn").click =>
        @moveElementUp "dataPanel"

    $(".moveElementDownBtn").click =>
        @moveElementDown "dataPanel"

    $(".addElementBtn").click =>
        @addElement "dataPanel"
        @root.trigger 'panelClickAddBtnClick', []       

    $(".removeElementBtn").click =>
        @deleteElement "dataPanel"
        @root.trigger 'panelClickDeleteBtnClick', []   

    $(".gridElementBtn").click =>
        @root.trigger 'panelClickGridBtnClick', [] 

    @createSlider $(".ppedit-slider")

  moveElementUp: (panelID) ->
    try
      checkboxRow = document.getElementById(panelID)
      rowCount = panel.rows.length
      i = 0

      while i < rowCount
        row = panel.rows[i]
        chkbox = row.cells[0].childNodes[0]
        if null isnt chkbox and true is chkbox.checked
          if rowCount <= 1
            alert "Please select a row."
            break
          checkboxRow.moveRow chkbox.checked, checkboxRow.rows.length + 1 #move first row to the end of the table instead
        i++
    catch e
      alert e
 
  moveElementUpDown: (panelID) ->
    newRow = $("
        <tr>
            <td><input type=\"checkbox\" name=\"chkk\"></input></td>
            <td><input type=\"text\" class=\"input-block-level\" placeholder=\"Enter name\"></input></td>
            <td><div class=\"ppedit-slider\"></div></td>
        </tr>")
    $("#" + panelID + " tbody").append newRow
    @createSlider newRow.find(".ppedit-slider")

  addElement: (panelID) ->
    newRow = $("
        <tr>
            <td><input type=\"checkbox\" name=\"chkk\"></input></td>
            <td><input type=\"text\" class=\"input-block-level\" placeholder=\"Enter name\"></input></td>
            <td><div class=\"ppedit-slider\"></div></td>                    
        </tr>")
    $("#" + panelID + " tbody").append newRow
    @createSlider newRow.find(".ppedit-slider")

  deleteElement: (panelID) ->
    try
      panel = document.getElementById(panelID)
      rowCount = panel.rows.length
      i = 0

      while i < rowCount
        row = panel.rows[i]
        chkbox = row.cells[0].childNodes[0]
        if null isnt chkbox and true is chkbox.checked
          if rowCount <= 1
            alert "Cannot delete all the rows."
            break
          panel.deleteRow i
          rowCount--
          i--
        i++
    catch e
      alert e

  createSlider: (selector) ->
    selector.slider(
      min: 0
      max: 100
      step: 1
      value: 100
    )

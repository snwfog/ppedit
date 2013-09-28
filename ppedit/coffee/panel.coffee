class Panel
  constructor: (@root) ->
    @element = $('
  <div class="col-xs-6">
      
       <button class="btn btn-info" id="moveElementUpBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-up"></span></button>

       <button class="btn btn-info" id="moveElementDownBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-down"></span></button>

      <button class="btn btn-primary" id="addElementBtn" type="button"><span class="glyphicon glyphicon-plus-sign"></span> Add Element</button>


      <button class="btn btn-primary" id="removeElementBtn" type="button"><span class="glyphicon glyphicon-minus-sign"></span> Delete Element</button>
      
      
      <table class="table table-hover" id="dataPanel">
          <thead>   
              <tr>
                <th>Selector</th>
                <th>Name of Element</th>
                <th>Opacity</th>
              </tr>
          </thead>
          <tbody>
              <tr>
                      <td><input type="checkbox" name="chkk"></input></td>
                      <td><input type="text" class="input-block-level" placeholder="Enter name"></input></td>
                      <td><div class="slider"></div></td>
                    
              </tr>

          </tbody>
      </table>
	</div>')
    @root.append(@element)
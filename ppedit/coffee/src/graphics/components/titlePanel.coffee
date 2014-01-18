#= require Graphic

class TitlePanel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element = $('
            <div class="col-xs-5">

              <form class="form-inline" role="form" style="padding-top: 5px;">
                <div class="form-group col-lg-20">
                  <fieldset style="padding-left: 15px;width: 370px">
                    <input class="form-control form-control input-lg" id="focusedInput" type="text" placeholder="Name of document">
                      <span class="help-block">Example: My Resume</span>
                  </fieldset>
                </div>
              </form>
            </div>')


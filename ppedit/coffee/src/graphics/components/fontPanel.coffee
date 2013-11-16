#= require Graphic

class FontPanel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element =$('
            <div class="col-xs-5" style ="padding-left: 30px">
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
               <button class="colorPicker" id="picker">A</button>
               <button class="weightBtn" type="button">B</button>
               <button class="underlineBtn" type="button">U</button>
               <button class="italicBtn" type="button">I</button>
               <br />
               <button class="leftAlignBtn" type="button"><span class="glyphicon glyphicon-align-left"></button>
               <button class="centerAlignBtn" type="button"><span class="glyphicon glyphicon-align-center"></button>
               <button class="rightAlignBtn" type="button"><span class="glyphicon glyphicon-align-right"></button>
			   <br />
               <button class="bulletPointBtn" type="button">. -</button>
               <button class="orderedPointBtn" type="button">1.</button>
                </div>')

  bindEvents: ->
    @element.find("select.fontTypeBtn").change (event) =>
      newFontType = $(event.target).find("option:selected").val()
      @root.trigger 'fontTypeChanged', [newFontType]

    @element.find("select.fontSizeBtn").change (event) =>
      newFontSize = $(event.target).find("option:selected").val()+"pt"
      @root.trigger 'fontSizeChanged', [newFontSize]

    @element.find(".colorPicker").click (event) =>
      $(event.target).colpick ({
        colorScheme:'dark',
        layout:'rgbhex' ,
        color:'ff8800' ,
        onSubmit: (hsb, hex, rgb, el) =>
          @element.trigger 'textColorChanged', [hex]
          $(el).colpickHide()
      })

    @element.find(".weightBtn").click (event) =>
      btn = $(event.target).toggleClass('.ppedit-btn-enabled')
      @root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'fontWeightBtnEnableClick' else 'fontWeightBtnDisableClick')

    @element.find(".underlineBtn").click (event) =>
      btn = $(event.target).toggleClass('.ppedit-btn-enabled')
      @root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'fontUnderlinedBtnEnableClick' else 'fontUnderlinedBtnDisableClick')

    @element.find(".italicBtn").click (event) =>
      btn = $(event.target).toggleClass('.ppedit-btn-enabled')
      @root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'fontItalicBtnEnableClick' else 'fontItalicBtnDisableClick')

    @element.find(".rightAlignBtn").click (event) =>
      @root.trigger 'rightAlignment'

    @element.find(".leftAlignBtn").click (event) =>
      @root.trigger 'leftAlignment'

    @element.find(".centerAlignBtn").click (event) =>
      @root.trigger 'centerAlignment'

    @element.find(".bulletPointBtn").click (event) =>
      #btn = $(event.target).toggleClass('.ppedit-btn-enabled')
      #@root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'bulletPointBtnEnableClick' else 'bulletPointBtnDisableClick')
      @root.trigger 'bulletPointBtnEnableClick'

    @element.find(".orderedPointBtn").click (event) =>
      #btn = $(event.target).toggleClass('.ppedit-btn-enabled')
      #@root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'bulletPointBtnEnableClick' else 'bulletPointBtnDisableClick')
      @root.trigger 'orderedPointBtnEnableClick'

  changeColor: (hsb, hex, rgb, el) ->
    $(el).css('background-color', '#'+hex)
    $(el).colpickHide()

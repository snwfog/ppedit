#= require Graphic

###
Graphic containing the font settings to apply to boxes.
###
class FontPanel extends Graphic
  constructor: (@root) ->
    super @root

  buildElement: ->
    @element =$('
            <div class="col-xs-5" style ="padding-left: 30px;padding-bottom: 10px">
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
               <button class="colorPicker btn btn-default" id="picker"><span class="glyphicon glyphicon-font"></button>
               <div class="btn-group" data-toggle="buttons">
                <label class="wbtn btn btn-default">
                  <input type="checkbox"><span class="weightBtn glyphicon glyphicon-bold"></span>
                </label>
                <label class="ubtn btn btn-default">
                  <input type="checkbox"><span class="underlineBtn glyphicon glyphicon-text-width"></span>
                </label>
                <label class="ibtn btn btn-default">
                  <input type="checkbox"><span class="italicBtn glyphicon glyphicon-italic"></span>
                </label>
               </div>

               <br />
               
               <div class="btn-group" data-toggle="buttons">
                <label class="leftAlignBtn btn btn-default">
                  <input type="radio" id="option1"><span class="glyphicon glyphicon-align-left">
                </label>
                <label class="centerAlignBtn btn btn-default">
                  <input type="radio" id="option2"><span class="glyphicon glyphicon-align-center">
                </label>
                <label class="rightAlignBtn btn btn-default">
                  <input type="radio" id="option3"><span class="glyphicon glyphicon-align-right">
                </label>
               </div>
               
			   <br />
               <div class="btn-group" data-toggle="buttons">
                <label class="bulletPointBtn btn btn-default">
                  <input type="radio" id="option1"><span class="glyphicon glyphicon-list">
                </label>
                <label class="orderedPointBtn btn btn-default">
                  <input type="radio" id="option2"><span class="glyphicon glyphicon-list-alt">
                </label>
               </div>
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

    @element.find(".wbtn").click (event) =>
      btn = $(event.target).toggleClass('.ppedit-btn-enabled')
      @root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'fontWeightBtnEnableClick' else 'fontWeightBtnDisableClick')

    @element.find(".ubtn").click (event) =>
      btn = $(event.target).toggleClass('.ppedit-btn-enabled')
      @root.trigger(if btn.hasClass('.ppedit-btn-enabled') then 'fontUnderlinedBtnEnableClick' else 'fontUnderlinedBtnDisableClick')

    @element.find(".ibtn").click (event) =>
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

    @element.find(".gridElementBtn").click =>
      @root.trigger 'panelClickGridBtnClick'

    @element.find('.snapBtn').click =>
      if !$(event.target).hasClass("snapBtn-selected") 
        $(event.target).addClass("snapBtn-selected") 
      else
        $(event.target).removeClass("snapBtn-selected") 
      
  changeColor: (hsb, hex, rgb, el) ->
    $(el).css('background-color', '#'+hex)
    $(el).colpickHide()

  setSettingsFromStyle: (style) ->
    @element
      .find('.fontTypeBtn')
      .children()
      .removeAttr('selected')
      .filter('option[value=' + style['font-family'] + ']')
      .attr('selected', 'selected')

    @element
      .find('.fontSizeBtn')
      .children()
      .removeAttr('selected')
      .filter('option[value="' + parseInt(style['font-size']) + '"]')
      .attr('selected', 'selected')

    @_switchBtn '.wbtn', style['font-weight'] == 'bold'
    @_switchBtn '.ubtn', style['text-decoration'].indexOf('underline') != -1
    @_switchBtn '.ibtn', style['font-style'] == 'italic'

    @element.find(".centerAlignBtn").removeClass("active")
    @element.find(".leftAlignBtn").removeClass("active")
    @element.find(".rightAlignBtn").removeClass("active")

    if style['text-align'] == "left"
      @element.find(".leftAlignBtn").addClass("active")
    else if style['text-align'] == "center"
      @element.find(".centerAlignBtn").addClass("active")
    else if style['text-align'] == "right"
      @element.find(".rightAlignBtn").addClass("active")

  _switchBtn: (selector, switchOn) ->
    if switchOn
      @element.find(selector).addClass 'ppedit-btn-enabled active'
    else
      @element.find(selector).removeClass 'ppedit-btn-enabled active'



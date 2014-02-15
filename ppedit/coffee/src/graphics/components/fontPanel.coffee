#= require Graphic

###
Graphic containing the font settings to apply to boxes.
###
class FontPanel extends Graphic
  constructor: (@root) ->
    super @root
    console.log(@root)

  buildElement: ->
    @element =$('
          <div class="edit-menu FontPanel shadow-effect">
            <div class="edit-menu-row1">
               <select class="fontTypeBtn from-control edit-menu-row1-dd-ff">
                 <option value="Times New Roman" selected>Times New Roman</option>
                 <option value="Arial">Arial</option>
                 <option value="Inconsolata">Inconsolata</option>
                 <option value="Glyphicons Halflings">Glyphicons Halflings</option>
               </select>
               
               <select class="fontSizeBtn from-control edit-menu-row1-dd-fs">
                 <option value="6">6</option>
                 <option value="8">8</option>
                 <option value="10" selected>10</option>
                 <option value="11">11</option>
                 <option value="12">12</option>
                 <option value="14">14</option>
                 <option value="16">16</option>
                 <option value="20">20</option>
               </select>

               

               <div class="boldButton boldButtonDisable font-panel-icon-row"></div>
               <div class="italicButton italicButtonDisable font-panel-icon-row"></div>
               <div class="underlineButton underlineButtonDisable font-panel-icon-row"></div>
             </div>
             <div class="edit-menu-row2">
                <div class="leftAlignBtn leftAlignButtonEnable font-panel-icon-row"></div>
                <div class="centerAlignBtn centerAlignButtonDisable font-panel-icon-row"></div>
                <div class="rightAlignBtn rightAlignButtonDisable font-panel-icon-row"></div>

               <div>
               <img class="icon-set letter-space-img" src="./ppedit/img/icons/text_letterspacing25.png" style="float:left;display:inline;">
               <select class="letter-space from-control edit-menu-row1-dd-fs">
                 <option value="0" selected>0</option>
                 <option value="1">1</option>
                 <option value="2">2</option>
                 <option value="3">3</option>
                 <option value="4">4</option>
                 <option value="5">5</option>
               </select>
               </div>

               <div>
               <img class="icon-set line-height-img" src="./ppedit/img/icons/text-line-spacing25.png" style="float:left;display:inline;">
               <select class="line-height from-control edit-menu-row1-dd-fs">
                 <option value="117" selected>1.0</option>
                 <option value="175">1.5</option>
                 <option value="233">2.0</option>
                 <option value="291">2.5</option>
                 <option value="349">3.0</option>
                 <option value="407">3.5</option>
                 <option value="465">4.0</option>
               </select>
               </div>

               <div>
               <img class="icon-set line-height-img" src="./ppedit/img/icons/text-padding25.png" style="float:left;display:inline;">
               <select class="padding from-control edit-menu-row1-dd-fs">
                 <option value="0" selected>0</option>
                 <option value="5">0.5</option>
                 <option value="10">1.0</option>
                 <option value="15">1.5</option>
                 <option value="20">2.0</option>
                 <option value="25">2.5</option>
                 <option value="30">3.0</option>
                 <option value="35">3.5</option>
                 <option value="40">4.0</option>
               </select>
               </div>

             </div>
            </div>')

  bindEvents: ->
    @element.find("select.fontTypeBtn").change (event) =>
      newFontType = $(event.target).find("option:selected").val()
      @root.trigger 'fontTypeChanged', [newFontType]

    @element.find("select.letter-space").change (event) =>
      newletterSpace = $(event.target).find("option:selected").val()+"px"
      @root.trigger 'letterSpaceChanged', [newletterSpace]

    @element.find("select.fontSizeBtn").change (event) =>
      newFontSize = $(event.target).find("option:selected").val()+"pt"
      @root.trigger 'fontSizeChanged', [newFontSize]

    @element.find("select.line-height").change (event) =>
      newLineHeight = $(event.target).find("option:selected").val()
      if(newLineHeight != 'normal')
        newLineHeight += "%"
      @root.trigger 'lineHeightChanged', [newLineHeight]

    @element.find("select.padding").change (event) =>
      newPadding = $(event.target).find("option:selected").val()+'px'
      @root.trigger 'paddingChanged', [newPadding]

    @element.find(".colorPicker").click (event) =>
      $(event.target).colpick ({
        colorScheme:'dark',
        layout:'rgbhex' ,
        color:'ff8800' ,
        onSubmit: (hsb, hex, rgb, el) =>
          @element.trigger 'textColorChanged', [hex]
          $(el).colpickHide()
      })

    @element.find('.boldButton').click (event) =>
      if $(event.target).hasClass('boldButtonDisable')
        btn = $(event.target).attr('class','boldButton boldButtonEnable font-panel-icon-row')
        btn.trigger(if btn.hasClass('boldButtonEnable font-panel-icon-row') then 'fontWeightBtnEnableClick' else 'fontWeightBtnDisableClick')
      else
        btn = $(event.target).attr('class','boldButtonDisable font-panel-icon-row')
        btn.trigger(if btn.hasClass('.boldButtonDisable font-panel-icon') then 'fontWeightBtnEnableClick' else 'fontWeightBtnDisableClick')

    @element.find('.italicButton').click (event) =>
      if $(event.target).hasClass('italicButtonDisable')
        btn = $(event.target).attr('class','italicButtonEnable font-panel-icon-row')
        btn.trigger(if btn.hasClass('italicButtonEnable font-panel-icon-row') then 'fontItalicBtnEnableClick' else 'fontItalicBtnDisableClick')
      else
        btn = $(event.target).attr('class','italicButtonDisable font-panel-icon-row')
        btn.trigger(if btn.hasClass('.italicButtonDisable font-panel-icon') then 'fontItalicBtnEnableClick' else 'fontItalicBtnDisableClick')

    @element.find('.underlineButton').click (event) =>
      if $(event.target).hasClass('underlineButtonDisable')
        btn = $(event.target).attr('class','underlineButtonEnable font-panel-icon-row')
        btn.trigger(if btn.hasClass('underlineButtonEnable font-panel-icon-row') then 'fontUnderlinedBtnEnableClick' else 'fontUnderlinedBtnDisableClick')
      else
        btn = $(event.target).attr('class','underlineButtonDisable font-panel-icon-row')
        btn.trigger(if btn.hasClass('.underlineButtonDisable font-panel-icon-row') then 'fontUnderlinedBtnEnableClick' else 'fontUnderlinedBtnDisableClick')

    @element.find('.centerAlignBtn').click (event) =>
      if $(event.target).hasClass('centerAlignButtonDisable')
        btn = $(event.target).attr('class','centerAlignButtonEnable font-panel-icon-row')
        @element.find('.leftAlignBtn').attr('class','leftAlignButtonDisable font-panel-icon-row')
        @element.find('.rightAlignBtn').attr('class','rightAlignButtonDisable font-panel-icon-row')
        btn.trigger(if btn.hasClass('centerAlignButtonEnable font-panel-icon-row') then '' else '')
      else
        btn = $(event.target).attr('class','centerAlignButtonDisable font-panel-icon-row')
        @element.find('.leftAlignBtn').attr('class','leftAlignButtonEnable font-panel-icon-row') 
        @element.find('.rightAlignBtn').attr('class','rightAlignButtonDisable font-panel-icon-row') 
        btn.trigger(if btn.hasClass('leftAlignButtonDisable font-panel-icon-row') then '' else '')



    @element.find(".rightAlignBtn").click (event) =>
      $(event.target).trigger 'rightAlignment'

    @element.find(".leftAlignBtn").click (event) =>
      console.log 'leftAlignBtn'
      $(event.target).trigger 'leftAlignment'

    @element.find(".centerAlignBtn").click (event) =>
      $(event.target).trigger 'centerAlignment'

    @element.find(".bulletPointBtn").click (event) =>
      $(event.target).trigger 'bulletPointBtnEnableClick'

    @element.find(".orderedPointBtn").click (event) =>
      $(event.target).trigger 'orderedPointBtnEnableClick'

    @element.find(".gridElementBtn").click =>
      $(event.target).trigger 'panelClickGridBtnClick'

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
    console.log(parseInt(style['padding']))
    @element
      .find('.letter-space')
      .children()
      .removeAttr('selected')
      .filter('option[value="' + parseInt(style['letter-spacing']) + '"]')
      .attr('selected', 'selected')

    @element
      .find('.line-height')
      .children()
      .removeAttr('selected')
      .filter('option[value="' + parseInt(style['line-height']) + '"]')
      .attr('selected', 'selected')

    @element
      .find('.padding')
      .children()
      .removeAttr('selected')
      .filter('option[value="' + parseInt(style['padding']) + '"]')
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



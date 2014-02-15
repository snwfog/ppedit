#= require Graphic

###
Graphic containing the font settings to apply to boxes.
###
class FontPanel extends Graphic
  constructor: (@root) ->
    super @root

    @prevPosition = undefined
    @prevMouseDownTime = 0  

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
               
               <select class="line-space from-control edit-menu-row1-dd-fs">
                 <option value="double">6</option>
                 <option value="single">8</option>
                 <option value="triple" selected>single</option>
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
                <div class="colorPicker colorPickerButton font-panel-icon-row"></div>
                <div class="orderedPointBtn orderedBulletPointButtonDisable font-panel-icon-row"></div>
                <div class="bulletPointBtn bulletPointButtonDisable font-panel-icon-row"></div>                 
             </div>
            </div>')




  bindEvents: ->
    @element
      .mousedown (event) =>
        event.stopPropagation()
        event.preventDefault()

        @selectFontPanel()
        @prevMouseDownTime = event.timeStamp

      .mouseup (event) =>
        event.preventDefault()
        @stopMoveFontPanel()

      .click (event) =>
        event.stopPropagation()
        event.preventDefault()

      .on 'containerMouseMove', (event, containerMouseEvent, delta) =>
        if event.target == @element.get(0)
          @moveFontPanel delta.x, delta.y if @element.hasClass('ppedit-panel-selected') && delta?

      .on 'containerMouseLeave', () =>
        @stopMoveFontPanel()

    .keydown (event) =>
      @_processKeyDownEvent(event) if!@isFocused()

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
        btn = $(event.target).attr('class','centerAlignBtn centerAlignButtonEnable font-panel-icon-row')        
        @element.find('.leftAlignBtn').attr('class','leftAlignBtn leftAlignButtonDisable font-panel-icon-row')
        @element.find('.rightAlignBtn').attr('class','rightAlignBtn rightAlignButtonDisable font-panel-icon-row')
        btn.trigger 'centerAlignment'
      else
        btn = $(event.target).attr('class','centerAlignBtn centerAlignButtonDisable font-panel-icon-row')
        @element.find('.leftAlignBtn').attr('class','leftAlignBtn leftAlignButtonEnable font-panel-icon-row')
        @element.find('.rightAlignBtn').attr('class','rightAlignBtn rightAlignButtonDisable font-panel-icon-row')
        $(event.target).trigger 'leftAlignment'

    @element.find('.rightAlignBtn').click (event) =>
      if $(event.target).hasClass('rightAlignButtonDisable')
        btn = $(event.target).attr('class','rightAlignBtn rightAlignButtonEnable font-panel-icon-row')      
        @element.find('.leftAlignBtn').attr('class','leftAlignBtn leftAlignButtonDisable font-panel-icon-row')
        @element.find('.centerAlignBtn').attr('class','centerAlignBtn centerAlignButtonDisable font-panel-icon-row')
        btn.trigger 'rightAlignment'
      else
        btn = $(event.target).attr('class','rightAlignBtn rightAlignButtonDisable font-panel-icon-row')
        @element.find('.leftAlignBtn').attr('class','leftAlignBtn leftAlignButtonEnable font-panel-icon-row')
        @element.find('.centerAlignBtn').attr('class','centerAlignBtn centerAlignButtonDisable font-panel-icon-row')
        $(event.target).trigger 'leftAlignment'

    @element.find('.leftAlignBtn').click (event) =>
      if $(event.target).hasClass('leftAlignButtonDisable')
        btn = $(event.target).attr('class','leftAlignBtn leftAlignButtonEnable font-panel-icon-row')      
        @element.find('.rightAlignBtn').attr('class','rightAlignBtn rightAlignButtonDisable font-panel-icon-row')
        @element.find('.centerAlignBtn').attr('class','centerAlignBtn centerAlignButtonDisable font-panel-icon-row')
        btn.trigger 'leftAlignment'

    @element.find(".rightAlignBtn").click (event) =>
      $(event.target).trigger 'rightAlignment'

    @element.find(".leftAlignBtn").click (event) =>
      $(event.target).trigger 'leftAlignment'

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

  selectFontPanel: ->
    @element.addClass('ppedit-panel-selected')
    @prevPosition = @currentFontPanelPosition()

  moveFontPanel: (deltaX, deltaY) ->
    currentPos = @currentFontPanelPosition()
    @setFontPanelPosition deltaX + currentPos.left, deltaY + currentPos.top

  stopMoveFontPanel: ->
    @element.removeClass('ppedit-panel-selected')
    @root.trigger 'boxMoved' , [@,$.extend(true, {}, @currentFontPanelPosition()), $.extend(true,{},@prevPosition)]
  
  currentFontPanelPosition: ->
    @element.position()

  setFontPanelPosition: (x,y) ->
    @element.css 'left', x + 'px'
    @element.css 'top', y + 'px'
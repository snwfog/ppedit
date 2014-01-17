#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe 'A test for issue "CAP-48 : As a user, I want to copy and paste aggregate elements in my work area"', ->

  it "copies and past one box", ->
    addBox 1

    box = $('.ppedit-box')
    simulateBoxDblClick box, ->

      # If Mac
      $('.ppedit-box-container').simulate "key-combo", {combo: "meta+shift+c"}
      $('.ppedit-box-container').simulate "key-combo", {combo: "meta+shift+v"}

      # If Windows
      $('.ppedit-box-container').simulate "key-combo", {combo: "ctrl+shift+c"}
      $('.ppedit-box-container').simulate "key-combo", {combo: "ctrl+shift+v"}

      expect($('.ppedit-box')).toHaveLength(2)
    
  it "copies and past multiple boxes", ->

    addBox 2

    boxes = $('.ppedit-box')
    moveBox boxes.eq(0), {dx:200, dy:0}

    canvas = $('.ppedit-canvas')

    # Select the two upperMost Rectangles
    selectRectangle canvas,
      topLeft:
        left:viewPortPosition(canvas).left + 49
        top:viewPortPosition(canvas).top + 49
      size:
        width:500
        height:100

    # If Mac
    $('.ppedit-box-container').simulate "key-combo", {combo: "meta+shift+c"} # if Mac
    $('.ppedit-box-container').simulate "key-combo", {combo: "meta+shift+v"} # if Windows

    # If Windows
    $('.ppedit-box-container').simulate "key-combo", {combo: "ctrl+shift+c"} # if Mac
    $('.ppedit-box-container').simulate "key-combo", {combo: "ctrl+shift+v"} # if Windows

    expect($('.ppedit-box')).toHaveLength(4)

  it "does not copy and past one box if not pressing the shift button", ->
    addBox 1

    box = $('.ppedit-box')
    simulateBoxDblClick box, ->

      # If Mac
      $('.ppedit-box-container').simulate "key-combo", {combo: "meta+c"}
      $('.ppedit-box-container').simulate "key-combo", {combo: "meta+v"}

      # If Windows
      $('.ppedit-box-container').simulate "key-combo", {combo: "ctrl+c"}
      $('.ppedit-box-container').simulate "key-combo", {combo: "ctrl+v"}

      expect($('.ppedit-box')).toHaveLength(1)

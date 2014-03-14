#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe 'A test for issue CAP-40 : "As a user, I want my elements in my work area to snap to a predefined and adjustable grid system.', ->

  it "snap the position of box to closest sanpping point after moving the box", ->

    addBox 1

    $('.snapImg').simulate 'click'

    box = $('.ppedit-box')
    box
      .simulate 'mousedown',
        clientX:box.position().left + 1
        clientY:box.position().top + 1

      .simulate "mousemove",
        clientX:box.position().left + 1
        clientY:box.position().top + 1

      .simulate "mousemove",
        clientX:box.position().left + 83
        clientY:box.position().top + 83

      .simulate 'mouseup',
        clientX:box.position().left + 83
        clientY:box.position().top + 83

    expect(box.position()).toBeEqualToPosition
      top: 128
      left: 128

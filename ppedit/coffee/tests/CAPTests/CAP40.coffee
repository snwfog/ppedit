#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe 'A test for issue CAP-40 : "As a user, I want my elements in my work area to snap to a predefined and adjustable grid system.', ->

  it "snap the position of box to closest sanpping point after moving the box", ->

    addBox 1

    box = $('.ppedit-box')
    snapBtn = $('.snapBtn')

    snapBtn.simulate 'click'
    
    box
      .simulate 'click',
        clientX:box.position().left
        clientY:box.position().top

      .simulate "mousemove",
        clientX:box.position().left
        clientY:box.position().top

      .simulate "mousemove",
        clientX:box.position().left + 81
        clientY:box.position().top + 81

      .simulate 'click',
        clientX:box.position().left + 81
        clientY:box.position().top + 81

      .simulate 'mouseup',
        clientX:box.position().left + 81
        clientY:box.position().top + 81
    
    expect(box.position()).toBeEqualToPosition
      top: 128
      left: 128

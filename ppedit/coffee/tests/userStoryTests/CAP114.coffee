#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe "A test for issue CAP-114 : As a user, I want to be able to enter text inside an element", ->

  it "can enter text inside a Box", ->
    addBox 1

    box = $('.ppedit-box')

    moveBox box, {dx:0, dy:200}

    box.simulate 'dblclick',
      clientX:viewPortPosition(box).left
      clientY:viewPortPosition(box).top

    expect(box.get(0)).toEqual(document.activeElement)

    # Enter Some Text
    box.val 'Lorem ipsum dolor sin amet'
    expect(box).toHaveValue('Lorem ipsum dolor sin amet')


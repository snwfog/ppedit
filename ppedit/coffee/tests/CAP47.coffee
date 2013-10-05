#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe "A test for issue CAP-47 : As a user, I want to select and move aggregated elements in my workspace", ->

  it "can select and move elements in the workspace", ->

    $(".addElementBtn").click()
    $(".addElementBtn").click()
    $(".addElementBtn").click()


    boxes = $('.ppedit-box')
    expect(boxes).toHaveLength(3)

    moveBox boxes.eq(0), {dx:200, dy:0}


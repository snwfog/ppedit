#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe "A test for issue CAP-14 : As a user, I want to reposition elements visible on my work area", ->

  it "adds a box on add element button click", ->

    $(".addElementBtn").click()
    expect($(".editor").find('.ppedit-box')).toHaveLength(1)

  it "repositions elements with the mouse", ->

    $(".addElementBtn").click()
    $(".addElementBtn").click()
    expect($(".editor").find('.ppedit-box')).toHaveLength(2)

    moveBox $('.ppedit-box'), {dx:150, dy:180}
    moveBox $('.ppedit-box'), {dx:100, dy:100}
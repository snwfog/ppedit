#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe 'A test for issue CAP-116 : "Cannot Undo Box moved" bug.', ->

  it "can undo a box move command", ->

    addBox 1

    box = $('.ppedit-box')
    moveBox box, {dx:0, dy:200}

    $('.ppedit-box-container').simulate "key-combo", {combo: "meta+z"} # if Mac
    $('.ppedit-box-container').simulate "key-combo", {combo: "ctrl+z"} # if Windows

    expect($('.ppedit-box')).toHaveLength(1)
    expect(box.position()).toBeEqualToPosition(
      top: 50
      left: 50
    )


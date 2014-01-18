#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe 'A test for issue CAP-118 : "Moving a box containing new lines moves it too far away" bug.', ->

  it "can move a box containing a new line by the right amount", ->

    addBox 1

    box = $('.ppedit-box').html("<br/><br/>")
    moveBox box, {dx:0, dy:200}
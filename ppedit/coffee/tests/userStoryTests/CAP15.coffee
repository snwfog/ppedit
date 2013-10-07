#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe "A test for issue CAP-15 : As a user, I want to resize the bounding box of elements on my work area", ->

  it "can resize a box with the mouse", ->
    addBox 1
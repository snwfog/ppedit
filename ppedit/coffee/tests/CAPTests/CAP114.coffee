#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe "A test for issue CAP-114 : As a user, I want to be able to enter text inside an element", ->

  it "can enter text inside a Box", ->
    addBox 1
    box = $('.ppedit-box')

    box.simulate 'dblclick'
    expect(box).toBeFocused()

    box.simulate "key-sequence", {
      sequence: "Lorem ipsum dolor sin amet"
      callback: ->
        expect(box).toHaveHtml('Lorem ipsum dolor sin amet')
    }
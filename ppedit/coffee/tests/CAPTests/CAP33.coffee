#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe 'A test for issue CAP-33 : "As a user, I want to create ordered and unordered bullet points in my work area."', ->

  it "can inserts an ordered list inside an empty box", ->
    addBox 1
    box = $('.ppedit-box')

    $('.orderedPointBtn').simulate 'dblclick'
    expect(box).toHaveHtml '<ol><li></li></ol>'

  it "can inserts an unordered list inside an empty box", ->
    addBox 1
    box = $('.ppedit-box')

    $('.bulletPointBtn').simulate 'dblclick'
    expect(box).toHaveHtml '<ul><li></li></ul>'

  it "can inserts an ordered list that wraps an existing text inside a box", ->
    addBox 1

    box = $('.ppedit-box')
    box
      .simulate("dblclick")
      .simulate "key-sequence",
        sequence: "Lorem ipsum dolor sin amet"
        callback: ->
          $('.orderedPointBtn').simulate 'click'
          expect(box).toContainHtml '<ol><li>Lorem ipsum dolor sin amet</li></ol>'

  it "can inserts an unordered list that wraps an existing text inside a box", ->
    addBox 1

    box = $('.ppedit-box')
    box
      .simulate("dblclick")
      .simulate "key-sequence",
        sequence: "Lorem ipsum dolor sin amet"
        callback: ->
          $('.bulletPointBtn').simulate 'click'
          expect(box).toContainHtml '<ul><li>Lorem ipsum dolor sin amet</li></ul>'
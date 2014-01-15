#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe "A test for issue CAP-37 : As a user, I want to arrange the elements depth.", ->

  it "can change the index of the element row one above the table element", ->
    addBox 3

    boxes = $('.ppedit-box')
    expect(boxes).toHaveLength(3)

    simulateBoxDblClick boxes.eq(2), =>
      $('.moveElementDownBtn').simulate 'click'
      expect(boxes.eq(2)).toHaveCss {'z-index': '1'}
      expect($('.ppedit-panel-row').eq(1)).toHaveAttr 'ppedit-box-id', boxes.eq(2).attr('ppedit-box-id')
#= require <ppeditTest.coffee>

ppeditDescribe "A test for issue CAP-35 : As a user,   I want to have horizontal and vertical alignment of my paragraphs.", ->
  
  it "change to left alignment by click left alignment button on the panel", ->
    
    addBox 1

    simulateBoxDblClick $('.ppedit-box'), =>
      $('.leftAlignBtn').simulate 'click'
      expect($(".ppedit-box")).toHaveCss({'text-align': "left"})

  it "change to right alignment by click left alignment button on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')
    btn = $('.rightAlignBtn')

    simulateBoxDblClick box, =>
      btn.simulate 'click'
      expect($(".ppedit-box")).toHaveCss({'text-align': "right"})

  it "change to center alignment by click left alignment button on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')
    btn = $('.centerAlignBtn')

    simulateBoxDblClick box, =>
      btn.simulate 'click'
      expect($(".ppedit-box")).toHaveCss({'text-align': "center"})
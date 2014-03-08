#= require <ppeditTest.coffee>

ppeditDescribe "A test for issue CAP-13 : As a user, I want to change font settings of my text documents.", ->
  
  it "change font family on select font family on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    simulateBoxDblClick box, =>
      $('.fontTypeBtn').val('Glyphicons Halflings').change()
      expect($(".ppedit-box")).toHaveCss({'font-family': "'Glyphicons Halflings'"})

  it "change font size on select font size on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    simulateBoxDblClick box, =>
      $('.fontSizeBtn').val('12').change()
      expect(Math.round(parseInt(box.css('font-size')))).toEqual(16)

  it "change font weight on font bold on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    simulateBoxDblClick box, =>
      $('.boldButton').simulate 'click'
      expect($(".ppedit-box").css('font-weight')).toEqual('bold')

  it "change font underline on font underline on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    simulateBoxDblClick box, =>
      $('.underlineButton').simulate 'click'
      expect(box.css('text-decoration')).toMatch(/underline/)

  it "change font italic on font italic on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    simulateBoxDblClick box, =>
      $('.italicButton').simulate 'click'
      expect($(".ppedit-box").css('font-style')).toEqual('italic')
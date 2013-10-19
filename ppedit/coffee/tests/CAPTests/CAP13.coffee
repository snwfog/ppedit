#= require <ppeditTest.coffee>

ppeditDescribe "A test for issue CAP-44 : As a user,   I want to change font settings of my text documents.", ->
  
  it "change font family on select font family on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    box.simulate 'click'
    $('.fontTypeBtn').val('Glyphicons Halflings').change()
    expect($(".ppedit-box")).toHaveCss({'font-family': "'Glyphicons Halflings'"})

  it "change font size on select font size on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    box.simulate 'click'
    $('.fontSizeBtn').val('12').change()
    expect($(".ppedit-box").css('font-size')).toEqual('16px')

  it "change font weight on font bold on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    box.simulate 'click'
    $('.weightBtn').simulate 'click'
    expect($(".ppedit-box").css('font-weight')).toEqual('bold')

  it "change font underline on font underline on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    box.simulate 'click'
    $('.underlineBtn').simulate 'click'
    expect($(".ppedit-box").css('text-decoration')).toEqual('underline')

  it "change font italic on font italic on the panel", ->
    
    addBox 1
    box = $('.ppedit-box')

    box.simulate 'click'
    $('.italicBtn').simulate 'click'
    expect($(".ppedit-box").css('font-style')).toEqual('italic')

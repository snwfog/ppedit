#= require <ppeditTest.coffee>

ppeditDescribe "A test for issue CAP-15 : As a user, I want to resize the bounding box of elements on my work area.", ->

  it "resize bounding boxof elements", ->

    # $(".ppedit-slider").click()
    expect($(".editor").find('.ppedit-box')).toHaveLength(1)
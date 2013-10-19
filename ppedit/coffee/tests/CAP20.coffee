#= require <ppeditTest.coffee>

ppeditDescribe "A test for issue CAP-20 : As a user, I want to clean my work area, so that I can start on a fresh new page, but I want to be able to remedy in the case of a mistake.", ->
  it " remove boxes when delete element button click", ->

    $(".removeElementBtn").click()

    expect($(".editor").find('.ppedit-box')).toHaveLength(0)
describe "A test for issue CAP-14 : As a user, I want to reposition elements visible on my work area", ->
  it "adds a box on add element button click", ->

    $(".editor").ppedit()
    $(".addElementBtn").click()

    expect($(".editor").find('.ppedit-box')).toHaveLength(1)
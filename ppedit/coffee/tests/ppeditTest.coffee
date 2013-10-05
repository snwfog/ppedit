ppeditDescribe = (suitDescription, specDefinitions) ->

  describe '', ->

    beforeEach ->
      $(".editor").ppedit()

    afterEach ->
      $('.editor').children().remove()

    describe suitDescription, specDefinitions
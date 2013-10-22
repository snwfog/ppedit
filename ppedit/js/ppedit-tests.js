// Generated by CoffeeScript 1.6.3
(function() {
  var addBox, moveBox, ppeditDescribe, ppeditMatchers, selectRectangle, viewPortPosition;

  ppeditMatchers = {
    /*
    Returns True if the expected position equals
    the passed position
    */

    toBeEqualToPosition: function(expected) {
      return expected.top === this.actual.top && expected.left === this.actual.left;
    }
  };

  ppeditDescribe = function(suitDescription, specDefinitions) {
    return describe('', function() {
      beforeEach(function() {
        this.addMatchers(ppeditMatchers);
        return $(".editor").ppedit();
      });
      afterEach(function() {
        return $('.editor').children().remove();
      });
      return describe(suitDescription, specDefinitions);
    });
  };

  /*
  Returns the position of the first element in the set of matched
  elements relative to the browser viewport.
  */


  viewPortPosition = function(jQuerySelector) {
    return {
      left: jQuerySelector.offset().left + jQuerySelector.scrollLeft(),
      top: jQuerySelector.offset().top + jQuerySelector.scrollTop()
    };
  };

  /*
  Adds a given number of boxes on an EMPTY box container
  */


  addBox = function(numOfBoxes) {
    var i, _i, _ref;
    for (i = _i = 0, _ref = numOfBoxes - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      $(".addElementBtn").click();
    }
    return expect($('.ppedit-box')).toHaveLength(numOfBoxes);
  };

  /*
  Simulates moving the passed box
  by the specified distance amount
  */


  moveBox = function(boxSelector, distance) {
    var previousPosition;
    previousPosition = viewPortPosition(boxSelector);
    boxSelector.simulate('click', {
      clientX: previousPosition.left + 1,
      clientY: previousPosition.top + 1
    }).simulate("mousemove", {
      clientX: previousPosition.left + 1,
      clientY: previousPosition.top + 1
    }).simulate("mousemove", {
      clientX: previousPosition.left + 1 + distance.dx,
      clientY: previousPosition.top + 1 + distance.dy
    }).simulate('click', {
      clientX: previousPosition.left + 1 + distance.dx,
      clientY: previousPosition.top + 1 + distance.dy
    }).simulate('mouseup', {
      clientX: previousPosition.left + 1 + distance.dx,
      clientY: previousPosition.top + 1 + distance.dy
    });
    return expect(viewPortPosition(boxSelector)).toBeEqualToPosition({
      left: previousPosition.left + distance.dx,
      top: previousPosition.top + distance.dy
    });
  };

  /*
  Simulates a rectangular selection on the passed
  canvas with the parameter specified by the passed rect
  */


  selectRectangle = function(canvasSelector, rect) {
    return canvasSelector.simulate("mousedown", {
      clientX: rect.topLeft.left,
      clientY: rect.topLeft.top
    }).simulate("mousemove", {
      clientX: rect.topLeft.left,
      clientY: rect.topLeft.top
    }).simulate("mousemove", {
      clientX: rect.topLeft.left + rect.size.width,
      clientY: rect.topLeft.top + rect.size.height
    }).simulate("mouseup", {
      clientX: rect.topLeft.left + rect.size.width,
      clientY: rect.topLeft.top + rect.size.height
    });
  };

  ppeditDescribe("A ppedit Jasmine test template", function() {
    return it("contains spec with an expectation", function() {
      return expect(true).toBe(true);
    });
  });

  ppeditDescribe('A test for issue "CAP-48 : As a user, I want to copy and paste aggregate elements in my work area"', function() {
    it("copies and past one box", function() {
      var box;
      addBox(1);
      box = $('.ppedit-box');
      box.simulate('click');
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "meta+c"
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "meta+v"
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "ctrl+c"
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "ctrl+v"
      });
      return expect($('.ppedit-box')).toHaveLength(2);
    });
    return it("copies and past multiple boxes", function() {
      var boxes, canvas;
      addBox(2);
      boxes = $('.ppedit-box');
      moveBox(boxes.eq(0), {
        dx: 200,
        dy: 0
      });
      canvas = $('.ppedit-canvas');
      selectRectangle(canvas, {
        topLeft: {
          left: viewPortPosition(canvas).left + 49,
          top: viewPortPosition(canvas).top + 49
        },
        size: {
          width: 500,
          height: 100
        }
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "meta+c"
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "meta+v"
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "ctrl+c"
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "ctrl+v"
      });
      return expect($('.ppedit-box')).toHaveLength(4);
    });
  });

  ppeditDescribe("A test for issue CAP-47 : As a user, I want to select and move aggregated elements in my workspace", function() {
    return it("can select and move elements in the workspace", function() {
      var boxes, canvas;
      $(".addElementBtn").click();
      $(".addElementBtn").click();
      $(".addElementBtn").click();
      boxes = $('.ppedit-box');
      expect(boxes).toHaveLength(3);
      moveBox(boxes.eq(0), {
        dx: 200,
        dy: 0
      });
      moveBox(boxes.eq(1), {
        dx: 0,
        dy: 200
      });
      canvas = $('.ppedit-canvas');
      selectRectangle(canvas, {
        topLeft: {
          left: viewPortPosition(canvas).left + 49,
          top: viewPortPosition(canvas).top + 49
        },
        size: {
          width: 500,
          height: 100
        }
      });
      return expect($('.ppedit-box-selected')).toHaveLength(2);
    });
  });

  ppeditDescribe("A test for issue CAP-44 : As a user,  I want options to show or hide the grid, and snap or unsnap my elements in the work area.", function() {
    return it("adds a box on grid button click", function() {
      expect($(".ppedit-grid")).toHaveCss({
        display: "block"
      });
      $(".gridElementBtn").click();
      return expect($(".ppedit-grid")).toHaveCss({
        display: "none"
      });
    });
  });

  ppeditDescribe("A test for issue CAP-42 : As a user, I want to change the opacity of elements in my work area.", function() {
    return it("drag the slider button to change the box opacity", function() {});
  });

  ppeditDescribe("A test for issue CAP-35 : As a user,   I want to have horizontal and vertical alignment of my paragraphs.", function() {
    it("change to left alignment by click left alignment button on the panel", function() {
      var box, btn;
      addBox(1);
      box = $('.ppedit-box');
      btn = $('.leftAlignBtn');
      box.simulate('click');
      btn.simulate('click');
      return expect($(".ppedit-box")).toHaveCss({
        'text-align': "left"
      });
    });
    it("change to right alignment by click left alignment button on the panel", function() {
      var box, btn;
      addBox(1);
      box = $('.ppedit-box');
      btn = $('.rightAlignBtn');
      box.simulate('click');
      btn.simulate('click');
      return expect($(".ppedit-box")).toHaveCss({
        'text-align': "right"
      });
    });
    return it("change to center alignment by click left alignment button on the panel", function() {
      var box, btn;
      addBox(1);
      box = $('.ppedit-box');
      btn = $('.centerAlignBtn');
      box.simulate('click');
      btn.simulate('click');
      return expect($(".ppedit-box")).toHaveCss({
        'text-align': "center"
      });
    });
  });

  ppeditDescribe("A test for issue CAP-25 : As a user, I want to name my document, so that I can distinguish between my documents", function() {
    return it("can input text inside the textarea to name document", function() {
      $('.addElementBtn').val('documentName');
      return expect($('.addElementBtn')).toHaveValue('documentName');
    });
  });

  ppeditDescribe("A test for issue CAP-20 : As a user, I want to clean my work area, so that I can start on a fresh new page, but I want to be able to remedy in the case of a mistake.", function() {
    return it(" remove boxes when delete element button click", function() {
      $(".removeElementBtn").click();
      return expect($(".editor").find('.ppedit-box')).toHaveLength(0);
    });
  });

  ppeditDescribe("A test for issue CAP-15 : As a user, I want to resize the bounding box of elements on my work area", function() {
    return it("can resize a box with the mouse", function() {
      return addBox(1);
    });
  });

  ppeditDescribe("A test for issue CAP-14 : As a user, I want to reposition elements visible on my work area", function() {
    it("adds a box when clicking the add element button once", function() {
      return addBox(1);
    });
    it("adds multiples boxes when clicking the add element button multiple times", function() {
      return addBox(10);
    });
    it("adds a box when doubleclicking the container", function() {
      $(".ppedit-box-container").simulate('dblclick');
      return expect($('.ppedit-box')).toHaveLength(1);
    });
    it("adds 2 boxes when doubleclicking the container twice", function() {
      $(".ppedit-box-container").simulate('dblclick');
      $(".ppedit-box-container").simulate('dblclick');
      return expect($('.ppedit-box')).toHaveLength(2);
    });
    it("repositions elements with the mouse", function() {
      addBox(2);
      moveBox($('.ppedit-box'), {
        dx: 150,
        dy: 180
      });
      return moveBox($('.ppedit-box'), {
        dx: 100,
        dy: 100
      });
    });
    return it("deletes a box when clicking on ctrl+delete", function() {
      addBox(1);
      $('.ppedit-box').simulate('click');
      expect($('.ppedit-box-selected')).toHaveLength(1);
      $('.ppedit-box-container').simulate('key-combo', {
        combo: 'ctrl+46'
      });
      $('.ppedit-box-container').simulate('key-combo', {
        combo: 'meta+8'
      });
      return expect($('.ppedit-box')).toHaveLength(0);
    });
  });

  ppeditDescribe("A test for issue CAP-13 : As a user,   I want to change font settings of my text documents.", function() {
    it("change font family on select font family on the panel", function() {
      var box;
      addBox(1);
      box = $('.ppedit-box');
      box.simulate('click');
      $('.fontTypeBtn').val('Glyphicons Halflings').change();
      return expect($(".ppedit-box")).toHaveCss({
        'font-family': "'Glyphicons Halflings'"
      });
    });
    it("change font size on select font size on the panel", function() {
      var box;
      addBox(1);
      box = $('.ppedit-box');
      box.simulate('click');
      $('.fontSizeBtn').val('12').change();
      return expect($(".ppedit-box").css('font-size')).toEqual('16px');
    });
    it("change font weight on font bold on the panel", function() {
      var box;
      addBox(1);
      box = $('.ppedit-box');
      box.simulate('click');
      $('.weightBtn').simulate('click');
      return expect($(".ppedit-box").css('font-weight')).toEqual('bold');
    });
    it("change font underline on font underline on the panel", function() {
      var box;
      addBox(1);
      box = $('.ppedit-box');
      box.simulate('click');
      $('.underlineBtn').simulate('click');
      return expect($(".ppedit-box").css('text-decoration')).toEqual('underline');
    });
    return it("change font italic on font italic on the panel", function() {
      var box;
      addBox(1);
      box = $('.ppedit-box');
      box.simulate('click');
      $('.italicBtn').simulate('click');
      return expect($(".ppedit-box").css('font-style')).toEqual('italic');
    });
  });

  ppeditDescribe('A test for issue CAP-116 : "Cannot Undo Box moved" bug.', function() {
    return it("can undo a box move command", function() {
      var box;
      addBox(1);
      box = $('.ppedit-box');
      moveBox(box, {
        dx: 0,
        dy: 200
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "meta+z"
      });
      $('.ppedit-box-container').simulate("key-combo", {
        combo: "ctrl+z"
      });
      expect($('.ppedit-box')).toHaveLength(1);
      return expect(box.position()).toBeEqualToPosition({
        top: 50,
        left: 50
      });
    });
  });

  ppeditDescribe("A test for issue CAP-114 : As a user, I want to be able to enter text inside an element", function() {
    return it("can enter text inside a Box", function() {
      var box;
      addBox(1);
      box = $('.ppedit-box');
      box.simulate('dblclick');
      expect(box).toBeFocused();
      return box.simulate("key-sequence", {
        sequence: "Lorem ipsum dolor sin amet",
        callback: function() {
          return expect(box).toHaveHtml('Lorem ipsum dolor sin amet');
        }
      });
    });
  });

}).call(this);

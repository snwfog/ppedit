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
    boxSelector.simulate("mousedown", {
      clientX: previousPosition.left + 1,
      clientY: previousPosition.top + 1
    }).simulate("mousemove", {
      clientX: previousPosition.left + 1,
      clientY: previousPosition.top + 1
    }).simulate("mousemove", {
      clientX: previousPosition.left + 1 + distance.dx,
      clientY: previousPosition.top + 1 + distance.dy
    }).simulate("mouseup", {
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

  ppeditDescribe("A ppedit Jasmine test template", function() {
    return it("contains spec with an expectation", function() {
      return expect(true).toBe(true);
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

  ppeditDescribe("A test for issue CAP-15 : As a user, I want to resize the bounding box of elements on my work area", function() {
    return it("can resize a box with the mouse", function() {
      var box, prevSize, previousPosition;
      addBox(1);
      box = $('.ppedit-box');
      prevSize = {
        width: box.width(),
        height: box.height()
      };
      previousPosition = viewPortPosition(box);
      box.resize({
        width: 200,
        height: 300
      });
      expect(box.width()).toEqual(200);
      return expect(box.height()).toEqual(300);
    });
  });

  ppeditDescribe("A test for issue CAP-14 : As a user, I want to reposition elements visible on my work area", function() {
    it("adds a box on add element button click", function() {
      $(".addElementBtn").click();
      return expect($(".editor").find('.ppedit-box')).toHaveLength(1);
    });
    return it("repositions elements with the mouse", function() {
      $(".addElementBtn").click();
      $(".addElementBtn").click();
      expect($(".editor").find('.ppedit-box')).toHaveLength(2);
      moveBox($('.ppedit-box'), {
        dx: 150,
        dy: 180
      });
      return moveBox($('.ppedit-box'), {
        dx: 100,
        dy: 100
      });
    });
  });

}).call(this);

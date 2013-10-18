// Generated by CoffeeScript 1.6.3
/*
Abstract Class, represents an Dom node
*/


(function() {
  var Box, BoxesContainer, Canvas, CommandManager, ControllerFactory, CreateBoxCommand, EditArea, Geometry, Graphic, Grid, MacController, MoveBoxCommand, PCController, PPEditor, Panel, RemoveBoxesCommand,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Graphic = (function() {
    /*
    Create a new graphic using the passed jQuery selector matching
    the element this dom node will be appended to.
    */

    function Graphic(root) {
      this.root = root;
      this.element = void 0;
    }

    /*
    Creates the element node and append it
    to the passed root
    */


    Graphic.prototype.buildElement = function() {};

    /*
    Method called after the element has been appended
    to the DOM.
    */


    Graphic.prototype.bindEvents = function() {};

    return Graphic;

  })();

  Geometry = (function() {
    function Geometry() {}

    /*
    Returns true if the innerRect Rectangle is fully
    contained within the outerRect Rectangle, false otherwise.
    */


    Geometry.rectContainsRect = function(outerRect, innerRect) {
      return innerRect.topLeft.left >= outerRect.topLeft.left && innerRect.topLeft.top >= outerRect.topLeft.top && innerRect.topLeft.left + innerRect.size.width <= outerRect.topLeft.left + outerRect.size.width && innerRect.topLeft.top + innerRect.size.height <= outerRect.topLeft.top + outerRect.size.height;
    };

    /*
    Returns true if the passed point is contained
     within the passed rectangle, false otherwise.
    */


    Geometry.rectContainsPoint = function(rect, point) {
      return point.left >= rect.topLeft.left && point.top >= rect.topLeft.top && point.left <= rect.topLeft.left + rect.size.width && point.top <= rect.topLeft.top + rect.size.height;
    };

    /*
    Returns true if the passed points have the
    same coordinate, false otherwise.
    */


    Geometry.pointEqualToPoint = function(point1, point2) {
      return point1.left === point2.left && point1.top === point2.top;
    };

    return Geometry;

  })();

  Box = (function(_super) {
    __extends(Box, _super);

    function Box(root, options) {
      this.root = root;
      this.options = options;
      Box.__super__.constructor.call(this, this.root);
      this.prevPosition = void 0;
    }

    Box.prototype.buildElement = function() {
      var settings;
      settings = $.extend({
        left: '50px',
        top: '50px',
        width: '75px',
        height: '50px'
      }, this.options);
      return this.element = $('<div></div>').addClass('ppedit-box').attr('tabindex', 0).attr('contenteditable', true).attr('id', $.now()).css(settings);
    };

    Box.prototype.bindEvents = function() {
      var _this = this;
      return this.element.mousedown(function(event) {
        event.stopPropagation();
        return event.preventDefault();
      }).click(function(event) {
        event.stopPropagation();
        event.preventDefault();
        return _this.toggleSelect();
      }).dblclick(function() {
        event.stopPropagation();
        event.preventDefault();
        _this.stopMoving();
        return _this.toggleFocus();
      }).on('containerMouseMove', function(event, mouseMoveEvent, delta) {
        if (_this.element.hasClass('ppedit-box-selected') && (delta != null)) {
          return _this.move(delta.x, delta.y);
        }
      }).on('containerMouseLeave', function() {
        return _this.stopMoving();
      }).on('containerKeyDown', function(event, keyDownEvent) {
        if (_this.element.hasClass('ppedit-box-selected')) {
          return _this._processKeyDownEvent(keyDownEvent);
        }
      }).keydown(function(event) {
        if (!_this.isFocused()) {
          return _this._processKeyDownEvent(event);
        }
      });
    };

    /*
    Matches directional arrows event
    to pixel-by-pixel movement
    */


    Box.prototype._processKeyDownEvent = function(event) {
      var moved, previousPosition;
      previousPosition = this.currentPosition();
      moved = false;
      if (event.which === 37) {
        event.preventDefault();
        moved = true;
        this.move(-1, 0);
      }
      if (event.which === 38) {
        event.preventDefault();
        moved = true;
        this.move(0, -1);
      }
      if (event.which === 39) {
        event.preventDefault();
        moved = true;
        this.move(1, 0);
      }
      if (event.which === 40) {
        event.preventDefault();
        moved = true;
        this.move(0, 1);
      }
      if (moved) {
        return this.root.trigger('boxMoved', [this, this.currentPosition(), previousPosition]);
      }
    };

    Box.prototype.stopMoving = function() {
      this.element.removeClass('ppedit-box-selected');
      if ((this.prevPosition != null) && !Geometry.pointEqualToPoint(this.currentPosition(), this.prevPosition)) {
        this.root.trigger('boxMoved', [this, this.currentPosition(), $.extend(true, {}, this.prevPosition)]);
      }
      return this.prevPosition = void 0;
    };

    Box.prototype.move = function(deltaX, deltaY) {
      var currentPos;
      currentPos = this.currentPosition();
      return this.setPosition(deltaX + currentPos.x, deltaY + currentPos.y);
    };

    Box.prototype.setPosition = function(x, y) {
      this.element.css('left', x + 'px');
      return this.element.css('top', y + 'px');
    };

    Box.prototype.currentPosition = function() {
      return {
        x: parseInt(this.element.css('left')),
        y: parseInt(this.element.css('top'))
      };
    };

    /*
    Marks the box as selected
    */


    Box.prototype.select = function() {
      this.element.addClass('ppedit-box-selected');
      return this.prevPosition = this.currentPosition();
    };

    /*
    Returns true if the element is currently focused, false otherwise
    */


    Box.prototype.isFocused = function() {
      return this.element.get(0) === document.activeElement;
    };

    Box.prototype.toggleSelect = function() {
      if (this.element.hasClass('ppedit-box-selected')) {
        return this.stopMoving();
      } else {
        return this.select();
      }
    };

    Box.prototype.toggleFocus = function() {
      if (this.isFocused()) {
        return this.element.blur();
      } else {
        return this.element.focus();
      }
    };

    return Box;

  })(Graphic);

  RemoveBoxesCommand = (function() {
    function RemoveBoxesCommand(editor, boxesSelector) {
      var box, boxArray;
      this.editor = editor;
      boxArray = boxesSelector.toArray();
      this.boxIds = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = boxArray.length; _i < _len; _i++) {
          box = boxArray[_i];
          _results.push(box.id);
        }
        return _results;
      })();
      this.boxes = this.editor.area.boxesContainer.getBoxesFromIds(this.boxIds);
    }

    RemoveBoxesCommand.prototype.execute = function() {
      var boxId, _i, _len, _ref, _results;
      this.editor.area.boxesContainer.removeBoxes(this.boxIds);
      _ref = this.boxIds;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        boxId = _ref[_i];
        _results.push(this.editor.panel.removeBoxRow(boxId));
      }
      return _results;
    };

    RemoveBoxesCommand.prototype.undo = function() {
      var box, _i, _len, _ref, _results;
      _ref = this.boxes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        box = _ref[_i];
        this.editor.area.boxesContainer.addBox(box);
        _results.push(this.editor.panel.addBoxRow(box.element.attr('id')));
      }
      return _results;
    };

    return RemoveBoxesCommand;

  })();

  MoveBoxCommand = (function() {
    function MoveBoxCommand(box, toPosition, fromPosition) {
      this.box = box;
      this.toPosition = toPosition;
      this.fromPosition = fromPosition;
      if (fromPosition == null) {
        this.fromPosition = this.box.currentPosition();
      }
    }

    MoveBoxCommand.prototype.execute = function() {
      return this.box.setPosition(this.toPosition.x, this.toPosition.y);
    };

    MoveBoxCommand.prototype.undo = function() {
      return this.box.setPosition(this.fromPosition.x, this.fromPosition.y);
    };

    return MoveBoxCommand;

  })();

  /*
  A command that creates a new box with the passed options
  ands adds it to the list.
  */


  CreateBoxCommand = (function() {
    function CreateBoxCommand(editor, options) {
      this.editor = editor;
      this.options = options;
      this.box = void 0;
    }

    CreateBoxCommand.prototype.execute = function() {
      if (this.box == null) {
        this.box = new Box(this.editor.area.boxesContainer.element, this.options);
      }
      this.editor.area.boxesContainer.addBox(this.box);
      return this.editor.panel.addBoxRow(this.box.element.attr('id'));
    };

    CreateBoxCommand.prototype.undo = function() {
      this.editor.area.boxesContainer.removeBoxes([this.box.element.attr('id')]);
      return this.editor.panel.removeBoxRow([this.box.element.attr('id')]);
    };

    return CreateBoxCommand;

  })();

  /*
  Class that manages a set of commands to undo/redo.
  */


  CommandManager = (function() {
    function CommandManager() {
      this.undoStack = [];
      this.redoStack = [];
    }

    /*
    Inserts the passed command into the undo stack
    flow. This method executes the command by default, set
    the execute argument to false in order to prevent that behavior.
    */


    CommandManager.prototype.pushCommand = function(command, execute) {
      if ((execute == null) || execute) {
        command.execute();
      }
      this.undoStack.push(command);
      return this.redoStack.splice(0, this.redoStack.length);
    };

    /*
    Undo the last executed command
    */


    CommandManager.prototype.undo = function() {
      var lastCommand;
      if (this.undoStack.length > 0) {
        lastCommand = this.undoStack.pop();
        lastCommand.undo();
        return this.redoStack.push(lastCommand);
      }
    };

    /*
    Redo the last executed command
    */


    CommandManager.prototype.redo = function() {
      var redoCommand;
      if (this.redoStack.length > 0) {
        redoCommand = this.redoStack.pop();
        redoCommand.execute();
        return this.undoStack.push(redoCommand);
      }
    };

    return CommandManager;

  })();

  PCController = (function() {
    function PCController(root) {
      this.root = root;
    }

    PCController.prototype.bindEvents = function() {
      var _this = this;
      return this.root.keydown(function(event) {
        if (event.keyCode === 90 && event.ctrlKey) {
          event.preventDefault();
          _this.root.trigger('requestUndo');
        }
        if (event.keyCode === 89 && event.ctrlKey) {
          event.preventDefault();
          _this.root.trigger('requestRedo');
        }
        if (event.keyCode === 46 || (event.keyCode === 46 && event.ctrlKey)) {
          event.preventDefault();
          return _this.root.trigger('requestDelete');
        }
      });
    };

    return PCController;

  })();

  MacController = (function() {
    MacController.COMMAND_LEFT_KEY_CODE = 91;

    MacController.COMMAND_RIGHT_KEY_CODE = 93;

    MacController.Z_KEY_CODE = 90;

    MacController.Y_KEY_CODE = 89;

    MacController.DELETE_KEY_CODE = 8;

    function MacController(root) {
      this.root = root;
      this.leftCmdKeyPressed = false;
      this.rightCmdKeyPressed = false;
    }

    MacController.prototype.bindEvents = function() {
      var _this = this;
      return this.root.keydown(function(event) {
        if (event.keyCode === MacController.COMMAND_LEFT_KEY_CODE) {
          return _this.leftCmdKeyPressed = true;
        } else if (event.keyCode === MacController.COMMAND_RIGHT_KEY_CODE) {
          return _this.rightCmdKeyPressed = true;
        } else if (event.keyCode === MacController.Z_KEY_CODE && _this._cmdKeyIsPressed()) {
          event.preventDefault();
          return _this.root.trigger('requestUndo');
        } else if (event.keyCode === MacController.Y_KEY_CODE && _this._cmdKeyIsPressed()) {
          event.preventDefault();
          return _this.root.trigger('requestRedo');
        } else if (event.keyCode === MacController.DELETE_KEY_CODE && _this._cmdKeyIsPressed()) {
          event.preventDefault();
          return _this.root.trigger('requestDelete');
        }
      }).keyup(function(event) {
        if (event.keyCode === MacController.COMMAND_LEFT_KEY_CODE) {
          _this.leftCmdKeyPressed = false;
        }
        if (event.keyCode === MacController.COMMAND_RIGHT_KEY_CODE) {
          return _this.rightCmdKeyPressed = false;
        }
      });
    };

    MacController.prototype._cmdKeyIsPressed = function() {
      return this.rightCmdKeyPressed || this.leftCmdKeyPressed;
    };

    return MacController;

  })();

  /*
  the ControllerFactory determines which controller
  to used based on the user's Operating System.
  */


  ControllerFactory = (function() {
    function ControllerFactory() {}

    ControllerFactory.getController = function(root) {
      if (navigator.userAgent.match(/Macintosh/) !== null) {
        return new MacController(root);
      } else {
        return new PCController(root);
      }
    };

    return ControllerFactory;

  })();

  BoxesContainer = (function(_super) {
    __extends(BoxesContainer, _super);

    BoxesContainer.CLICK_TIME_INTERVAL = 200;

    function BoxesContainer(root) {
      this.root = root;
      BoxesContainer.__super__.constructor.call(this, this.root);
      this.boxes = {};
      this.lastDownEvent = void 0;
    }

    BoxesContainer.prototype.buildElement = function() {
      return this.element = $('<div></div>').addClass('ppedit-box-container');
    };

    BoxesContainer.prototype.bindEvents = function() {
      var _this = this;
      return this.element.mousedown(function(event) {
        return _this.lastDownEvent = event;
      }).mouseup(function(event) {
        if ((_this.lastDownEvent != null) && event.timeStamp - _this.lastDownEvent.timeStamp < BoxesContainer.CLICK_TIME_INTERVAL) {
          return _this.unSelectAllBoxes();
        }
      }).dblclick(function(event) {
        var boxCssOptions;
        event.preventDefault();
        boxCssOptions = _this.getPointClicked(event);
        if (_this.getSelectedBoxes().length === 0) {
          return _this.root.trigger('addBoxRequested', [boxCssOptions]);
        }
      });
    };

    /*
    Selects the boxes contained in the passed rect.
    The rect position is relative to the root.
    */


    BoxesContainer.prototype.selectBoxesInRect = function(rect) {
      var selectRect,
        _this = this;
      selectRect = {
        topLeft: {
          left: rect.topLeft.left + this.element.scrollLeft(),
          top: rect.topLeft.top + this.element.scrollTop()
        },
        size: rect.size
      };
      if (selectRect.size.width < 0) {
        selectRect.topLeft.left -= Math.abs(selectRect.size.width);
        selectRect.size.width = Math.abs(selectRect.size.width);
      }
      if (selectRect.size.height < 0) {
        selectRect.topLeft.top -= Math.abs(selectRect.size.height);
        selectRect.size.height = Math.abs(selectRect.size.height);
      }
      return this.getAllBoxes().each(function(index, box) {
        if (Geometry.rectContainsRect(selectRect, _this.boxBounds($(box)))) {
          return _this.boxes[box.id].select();
        }
      });
    };

    /*
    Returns the bounding rectangle of the box matching the
    passed box selector.
    */


    BoxesContainer.prototype.boxBounds = function(boxSelector) {
      var result;
      return result = {
        topLeft: {
          left: boxSelector.position().left + this.element.scrollLeft(),
          top: boxSelector.position().top + this.element.scrollTop()
        },
        size: {
          width: boxSelector.width(),
          height: boxSelector.height()
        }
      };
    };

    /*
    Adds the passed Box Object to the Box List
    */


    BoxesContainer.prototype.addBox = function(box) {
      if (box.element == null) {
        box.buildElement();
      }
      this.element.append(box.element);
      box.bindEvents();
      return this.boxes[box.element.attr('id')] = box;
    };

    /*
    Given an array of box ids, deletes all box objects
    with those ids.
    */


    BoxesContainer.prototype.removeBoxes = function(boxIds) {
      var id, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = boxIds.length; _i < _len; _i++) {
        id = boxIds[_i];
        this.boxes[id].element.removeClass('ppedit-box-selected').remove();
        _results.push(delete this.boxes[id]);
      }
      return _results;
    };

    /*
    Returns an array of Box objects corresponding to the
    passed boxIds.
    */


    BoxesContainer.prototype.getBoxesFromIds = function(boxIds) {
      var id;
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = boxIds.length; _i < _len; _i++) {
          id = boxIds[_i];
          if (this.boxes[id] != null) {
            _results.push(this.boxes[id]);
          }
        }
        return _results;
      }).call(this);
    };

    /*
    Returns a selector matching all boxes
    */


    BoxesContainer.prototype.getAllBoxes = function() {
      return this.element.find('.ppedit-box');
    };

    /*
    Returns a selector to the currently selected boxes
    */


    BoxesContainer.prototype.getSelectedBoxes = function() {
      return this.element.find('.ppedit-box:focus, .ppedit-box-selected');
    };

    /*
    Returns a selector to the currently selected boxes,
    excluding the focused one, if any.
    */


    BoxesContainer.prototype.getNotFocusedSelectedBoxes = function() {
      return this.element.find('.ppedit-box-selected');
    };

    BoxesContainer.prototype.chageBoxOpacity = function(boxid, opacityVal) {
      return this.boxes[boxid].element.css("opacity", opacityVal);
    };

    BoxesContainer.prototype.unSelectAllBoxes = function() {
      var box, id, _ref, _results;
      _ref = this.boxes;
      _results = [];
      for (id in _ref) {
        box = _ref[id];
        _results.push(box.stopMoving());
      }
      return _results;
    };

    /*
    Returns the position relative to the top left corner
    of the element from the passed mouseEvent.
    */


    BoxesContainer.prototype.getPointClicked = function(mouseEvent) {
      return {
        left: event.offsetX + this.element.scrollLeft(),
        top: event.offsetY + this.element.scrollTop()
      };
    };

    return BoxesContainer;

  })(Graphic);

  Canvas = (function(_super) {
    __extends(Canvas, _super);

    function Canvas(root) {
      this.root = root;
      Canvas.__super__.constructor.call(this, this.root);
      this.downPosition = void 0;
      this.rectSize = void 0;
      this._context = void 0;
    }

    Canvas.prototype.buildElement = function() {
      return this.element = $('<canvas></canvas>').addClass('ppedit-canvas').attr('width', '600px').attr('height', '960px');
    };

    Canvas.prototype.bindEvents = function() {
      var _this = this;
      this.element.on('containerMouseDown', function(event, mouseEvent) {
        _this.downPosition = {
          left: mouseEvent.offsetX,
          top: mouseEvent.offsetY
        };
        return _this.rectSize = {
          width: 0,
          height: 0
        };
      }).on('containerMouseMove', function(event, mouseMoveEvent, delta) {
        if ((_this.downPosition != null) && (_this.rectSize != null) && (delta != null)) {
          _this.rectSize.width += delta.x;
          _this.rectSize.height += delta.y;
          return _this.drawRect(_this.downPosition, _this.rectSize);
        }
      }).on('containerMouseLeave', function() {
        return _this.clear();
      }).on('containerMouseUp', function() {
        if ((_this.downPosition != null) && (_this.rectSize != null)) {
          _this.root.trigger('canvasRectSelect', [
            {
              topLeft: _this.downPosition,
              size: _this.rectSize
            }
          ]);
        }
        return _this.clear();
      });
      return this._context = this.element.get(0).getContext('2d');
    };

    Canvas.prototype.drawRect = function(topLeft, size) {
      this._context.clearRect(0, 0, this.element.width(), this.element.height());
      this._context.globalAlpha = 0.2;
      this._context.beginPath();
      this._context.rect(topLeft.left, topLeft.top, size.width, size.height);
      this._context.fillStyle = 'blue';
      return this._context.fill();
    };

    Canvas.prototype.clear = function() {
      this._context.clearRect(0, 0, this.element.width(), this.element.height());
      this.downPosition = void 0;
      return this.rectSize = void 0;
    };

    return Canvas;

  })(Graphic);

  Grid = (function(_super) {
    __extends(Grid, _super);

    function Grid(root) {
      this.root = root;
      Grid.__super__.constructor.call(this, this.root);
    }

    Grid.prototype.buildElement = function() {
      return this.element = $('\
       <div class="ppedit-grid">\
            <svg width="100%" height="100%">\
              <defs>\
                <pattern id="smallGrid" width="8" height="8" patternUnits="userSpaceOnUse">\
                  <path d="M 8 0 L 0 0 0 8" fill="none" stroke="gray" stroke-width="0.5"/>\
                </pattern>\
                <pattern id="grid" width="80" height="80" patternUnits="userSpaceOnUse">\
                  <rect width="80" height="80" fill="url(#smallGrid)"/>\
                  <path d="M 80 0 L 0 0 0 80" fill="none" stroke="gray" stroke-width="1"/>\
                </pattern>\
              </defs>\
\
              <rect width="100%" height="100%" fill="url(#grid)" />\
            </svg>\
      </div>');
    };

    Grid.prototype.toggleGrid = function() {
      return this.element.toggle();
    };

    return Grid;

  })(Graphic);

  EditArea = (function(_super) {
    __extends(EditArea, _super);

    function EditArea(root) {
      this.root = root;
      EditArea.__super__.constructor.call(this, this.root);
      this.prevMouseMoveEvent = void 0;
      this.canvas = void 0;
      this.grid = void 0;
      this.boxesContainer = void 0;
    }

    EditArea.prototype.buildElement = function() {
      this.element = $('<div></div>').addClass("ppedit-container").addClass("col-xs-8").attr('tabindex', 0);
      this.boxesContainer = new BoxesContainer(this.element);
      this.canvas = new Canvas(this.element);
      this.grid = new Grid(this.element);
      this.boxesContainer.buildElement();
      this.canvas.buildElement();
      this.grid.buildElement();
      this.element.append(this.boxesContainer.element);
      this.element.append(this.canvas.element);
      return this.element.append(this.grid.element);
    };

    EditArea.prototype.bindEvents = function() {
      var _this = this;
      this.element.mousedown(function() {
        if (_this.boxesContainer.getNotFocusedSelectedBoxes().length === 0) {
          return _this.canvas.element.trigger('containerMouseDown', [event]);
        }
      }).mousemove(function(event) {
        var delta;
        delta = void 0;
        if (_this.prevMouseMoveEvent != null) {
          delta = {
            x: event.clientX - _this.prevMouseMoveEvent.clientX,
            y: event.clientY - _this.prevMouseMoveEvent.clientY
          };
        }
        _this.element.find('*').trigger('containerMouseMove', [event, delta]);
        return _this.prevMouseMoveEvent = event;
      }).mouseleave(function() {
        _this.element.find('*').trigger('containerMouseLeave');
        return _this.prevMouseMoveEvent = void 0;
      }).mouseup(function(event) {
        _this.element.find('*').trigger('containerMouseUp', [event]);
        return _this.prevMouseMoveEvent = void 0;
      }).keydown(function(event) {
        return _this.element.find('*').trigger('containerKeyDown', [event]);
      }).on('canvasRectSelect', function(event, rect) {
        return _this.boxesContainer.selectBoxesInRect(rect);
      });
      this.boxesContainer.bindEvents();
      this.canvas.bindEvents();
      return this.grid.bindEvents();
    };

    return EditArea;

  })(Graphic);

  Panel = (function(_super) {
    __extends(Panel, _super);

    function Panel(root) {
      this.root = root;
      Panel.__super__.constructor.call(this, this.root);
    }

    Panel.prototype.buildElement = function() {
      return this.element = $('\
            <div class="col-xs-5">\
\
               <!-- <button class="btn btn-sm btn-info moveElementUpBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-up"></span></button>\
              <button class="btn btn-sm btn-info moveElementDownBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-down"></span></button> \
                -->\
              <form class="form-inline" role="form" style="padding-top: 5px;">\
                <div class="form-group col-lg-20">\
                  <fieldset style="padding-left: 15px;">\
                    <input class="form-control form-control input-lg" id="focusedInput" type="text" placeholder="Name of document">\
                      <span class="help-block">Example: My Resume</span>\
\
                      <hr>\
\
                      <button class="btn btn-sm btn-primary addElementBtn" type="button"><span class="glyphicon glyphicon-plus-sign"></span> Add Element</button>\
\
                      <button class="btn btn-primary btn-sm gridElementBtn" type="button"><span class="glyphicon glyphicon-th-large"></span> Grid</button>\
\
                      <button class="btn btn-primary btn-sm" type="button"><span class="glyphicon glyphicon-magnet"></span> Snap</button>\
\
                      <button class="btn btn-warning btn-sm clearAllElementBtn" type="button"><span class="glyphicon glyphicon-trash"></span> Clear All</button>\
\
\
                      <table class="table table-hover dataPanel">\
                          <thead>\
                              <tr>\
                                <th>Remove</th>\
                                <th>Name of Element</th>\
                                <th>Opacity</th>\
                              </tr>\
                          </thead>\
                          <tbody>\
\
\
                          </tbody>\
                      </table>\
                    \
                    <button type="submit" class="btn btn btn-success" style="float: right;">Save</button>\
                  </fieldset>\
                </div>\
              </form>\
            </div>');
    };

    Panel.prototype.bindEvents = function() {
      var _this = this;
      $(".addElementBtn").click(function() {
        return _this.root.trigger('panelClickAddBtnClick');
      });
      $(".clearAllElementBtn").click(function() {
        return _this.root.trigger('panelClickClearAllBtnClick');
      });
      return $(".gridElementBtn").click(function() {
        return _this.root.trigger('panelClickGridBtnClick');
      });
    };

    Panel.prototype.moveElementUp = function(panelID) {};

    Panel.prototype.moveElementUpDown = function(panelID) {};

    /*
    Adds a row to be associated with the passed box id.
    */


    Panel.prototype.addBoxRow = function(boxid) {
      var newRow,
        _this = this;
      newRow = $("            <tr>                <td><span class=\"glyphicon glyphicon-remove-sign icon-4x red deleteElementBtn\"></span></td>                <td><input type=\"text\" class=\"input-block-level\" placeholder=\"Enter name\"></input></td>                <td><div class=\"ppedit-slider\"></div></td>            </tr>").attr('ppedit-box-id', boxid);
      this.element.find('.dataPanel tbody').append(newRow);
      newRow.find(".ppedit-slider").slider({
        min: 0,
        max: 100,
        step: 1,
        value: 100
      }).on('slide', function(event) {
        var opacityVal;
        opacityVal = $(event.target).val();
        return _this.root.trigger('onRowSliderValChanged', [boxid, parseInt(opacityVal) / 100]);
      });
      return newRow.find(".deleteElementBtn").on('click', function(event) {
        return _this.root.trigger('onRowDeleteBtnClick', [boxid]);
      });
    };

    /*
    Removes the row associated with the passed box id.
    */


    Panel.prototype.removeBoxRow = function(boxId) {
      return this.element.find("tr[ppedit-box-id=" + boxId + "]").remove();
    };

    return Panel;

  })(Graphic);

  PPEditor = (function(_super) {
    __extends(PPEditor, _super);

    function PPEditor(root) {
      this.root = root;
      PPEditor.__super__.constructor.call(this, this.root);
      this.controller = void 0;
      this.commandManager = new CommandManager;
      this.area = void 0;
      this.panel = void 0;
    }

    PPEditor.prototype.buildElement = function() {
      var row;
      this.element = $('\
      <div class="container">\
        <div class="row"></div>\
      </div>\
    ');
      this.controller = ControllerFactory.getController(this.element);
      row = this.element.find('.row');
      this.area = new EditArea(row);
      this.panel = new Panel(row);
      this.area.buildElement();
      this.panel.buildElement();
      row.append(this.area.element);
      return row.append(this.panel.element);
    };

    PPEditor.prototype.bindEvents = function() {
      var _this = this;
      this.element.on('requestUndo', function(event) {
        return _this.commandManager.undo();
      }).on('requestRedo', function(event) {
        return _this.commandManager.redo();
      }).on('requestDelete', function(event) {
        return _this.commandManager.pushCommand(new RemoveBoxesCommand(_this, _this.area.boxesContainer.getSelectedBoxes()));
      });
      this.element.find('.row').on('panelClickAddBtnClick', function(event) {
        return _this.commandManager.pushCommand(new CreateBoxCommand(_this));
      }).on('panelClickGridBtnClick', function(event) {
        return _this.area.grid.toggleGrid();
      }).on('panelClickClearAllBtnClick', function(event) {
        return _this.commandManager.pushCommand(new RemoveBoxesCommand(_this, _this.area.boxesContainer.getAllBoxes()));
      }).on('onRowDeleteBtnClick', function(event, boxId) {
        return _this.commandManager.pushCommand(new RemoveBoxesCommand(_this, _this.root.find('#' + boxId)));
      }).on('onRowSliderValChanged', function(event, boxId, opacityVal) {
        return _this.area.boxesContainer.chageBoxOpacity(boxId, opacityVal);
      }).on('addBoxRequested', function(event, boxCssOptions) {
        return _this.commandManager.pushCommand(new CreateBoxCommand(_this, boxCssOptions));
      });
      this.area.boxesContainer.element.on('boxMoved', function(event, box, currentPosition, originalPosition) {
        return _this.commandManager.pushCommand(new MoveBoxCommand(box, currentPosition, originalPosition), false);
      });
      this.area.bindEvents();
      this.panel.bindEvents();
      return this.controller.bindEvents();
    };

    return PPEditor;

  })(Graphic);

  /*
  FooBar jQuery Plugin v1.0 - It makes Foo as easy as coding Bar (?).
  Release: 19/04/2013
  Author: Joe Average <joe@average.me>
  
  http://github.com/joeaverage/foobar
  
  Licensed under the WTFPL license: http://www.wtfpl.net/txt/copying/
  */


  (function($, window, document) {
    var $this, methods, _anotherState, _flag, _internals, _settings;
    $this = void 0;
    _settings = {
      "default": 'cool!'
    };
    _flag = false;
    _anotherState = null;
    methods = {
      init: function(options) {
        var editor;
        $this = $(this);
        $.extend(_settings, options || {});
        editor = new PPEditor($this);
        editor.buildElement();
        $this.append(editor.element);
        editor.bindEvents();
        return $this;
      },
      doSomething: function(what) {
        return $this;
      },
      destroy: function() {
        return $this;
      }
    };
    _internals = {
      toggleFlag: function() {
        return _flag = !_flag;
      }
    };
    return $.fn.ppedit = function(method) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === "object" || !method) {
        return methods.init.apply(this, arguments);
      } else {
        return $.error("Method " + method + " does not exist on jquery.ppedit");
      }
    };
  })(jQuery, window, document);

}).call(this);

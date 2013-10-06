// Generated by CoffeeScript 1.6.3
(function() {
  var Box, BoxesContainer, Canvas, Controller, CreateBoxCommand, EditorManager, Grid, MoveBoxCommand, PCController, Panel, RemoveBoxesCommand,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Box = (function() {
    function Box(root, options) {
      var settings;
      this.root = root;
      this.prevPosition = void 0;
      settings = $.extend({
        left: '50px',
        top: '50px',
        width: '75px',
        height: '50px'
      }, options);
      this.element = $('<div></div>').addClass('ppedit-box').attr('tabindex', 0).attr('id', $.now()).css(settings);
    }

    Box.prototype.bindEvents = function() {
      var _this = this;
      return this.element.mousedown(function(event) {
        _this.element.addClass('ppedit-box-selected');
        return _this.prevPosition = _this.currentPosition();
      }).on('containerMouseMove', function(event, mouseMoveEvent, delta) {
        if (_this.element.hasClass('ppedit-box-selected') && (delta != null)) {
          return _this.move(delta.x, delta.y);
        }
      }).on('containerMouseLeave', function() {
        return _this.stopMoving();
      }).on('containerMouseUp', function() {
        return _this.stopMoving();
      }).on('containerKeyDown', function(event, keyDownEvent) {
        if (_this.element.hasClass('ppedit-box-selected')) {
          return _this.processKeyDownEvent(keyDownEvent);
        }
      }).keydown(function(event) {
        return _this.processKeyDownEvent(event);
      });
    };

    Box.prototype.processKeyDownEvent = function(event) {
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
      if (this.prevPosition != null) {
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

    return Box;

  })();

  BoxesContainer = (function() {
    function BoxesContainer(root) {
      var _this = this;
      this.root = root;
      this.boxes = {};
      this.undoStack = [];
      this.redoStack = [];
      this.element = $('<div></div>').addClass('ppedit-box-container');
      this.root.append(this.element);
      this.element.on('boxMoved', function(event, box, currentPosition, originalPosition) {
        return _this._pushCommand(new MoveBoxCommand(box, currentPosition, originalPosition), false);
      });
    }

    /*
    Selects the boxes contained in the passed rect.
    The rect position is relative to the root.
    */


    BoxesContainer.prototype.selectBoxesInRect = function(rect) {
      var selectRect,
        _this = this;
      selectRect = {
        topLeft: {
          x: rect.topLeft.x + this.element.scrollLeft(),
          y: rect.topLeft.y + this.element.scrollTop()
        },
        size: rect.size
      };
      if (selectRect.size.width < 0) {
        selectRect.topLeft.x -= Math.abs(selectRect.size.width);
        selectRect.size.width = Math.abs(selectRect.size.width);
      }
      if (selectRect.size.height < 0) {
        selectRect.topLeft.y -= Math.abs(selectRect.size.height);
        selectRect.size.height = Math.abs(selectRect.size.height);
      }
      return this.element.find('.ppedit-box').each(function(index, box) {
        if (BoxesContainer._rectContainsRect(selectRect, _this.boxBounds($(box)))) {
          return $(box).addClass('ppedit-box-selected');
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
          x: boxSelector.position().left + this.element.scrollLeft(),
          y: boxSelector.position().top + this.element.scrollTop()
        },
        size: {
          width: boxSelector.width(),
          height: boxSelector.height()
        }
      };
    };

    /*
    Creates a new box with the passed options ands adds it to the list,
    then return the boxes newly created.
    */


    BoxesContainer.prototype.createBox = function(options) {
      var createBoxCommand;
      createBoxCommand = new CreateBoxCommand(this, options);
      this._pushCommand(createBoxCommand);
      return createBoxCommand.box;
    };

    BoxesContainer.prototype.removeBox = function(options) {
      return this._pushCommand(new RemoveBoxesCommand(this));
    };

    /*
    Adds the passed Box Object to the Box List
    */


    BoxesContainer.prototype.addBox = function(box) {
      this.element.append(box.element);
      box.bindEvents();
      return this.boxes[box.element.attr('id')] = box;
    };

    /*
    Deletes the Box objects corresponding to the
    passed boxIds. Passing no arguments will delete
    all Box objects.
    */


    BoxesContainer.prototype.removeBoxes = function(boxIds) {
      var box, boxId, id, _i, _len, _ref, _results;
      if (boxIds == null) {
        _ref = this.boxes;
        for (boxId in _ref) {
          box = _ref[boxId];
          box.element.remove();
        }
        return this.boxes = {};
      } else {
        _results = [];
        for (_i = 0, _len = boxIds.length; _i < _len; _i++) {
          id = boxIds[_i];
          this.boxes[id].element.remove();
          _results.push(delete this.boxes[id]);
        }
        return _results;
      }
    };

    /*
    Returns an array of Box objects corresponding to the
    passed boxIds. Passing no arguments will return
    all Box objects.
    */


    BoxesContainer.prototype.getBoxesFromIds = function(boxIds) {
      var id;
      if (boxIds != null) {
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
      } else {
        return $.extend(true, [], this.boxes);
      }
    };

    BoxesContainer.prototype.deleteSelectedBoxes = function() {
      var selectedBoxes;
      selectedBoxes = this.element.find('.ppedit-box:focus, .ppedit-box-selected');
      if (selectedBoxes.length > 0) {
        return this._pushCommand(new RemoveBoxesCommand(this, selectedBoxes));
      }
    };

    BoxesContainer.prototype.chageBoxOpacity = function(boxid, opacityVal) {
      return this.boxes[boxid].element.css("opacity", opacityVal);
    };

    /*
    Undo the last executed command
    */


    BoxesContainer.prototype.undo = function() {
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


    BoxesContainer.prototype.redo = function() {
      var redoCommand;
      if (this.redoStack.length > 0) {
        redoCommand = this.redoStack.pop();
        redoCommand.execute();
        return this.undoStack.push(redoCommand);
      }
    };

    /*
    Inserts the passed command into the undo stack
    flow. This method execute the command by default, set
    the execute argument to false in order to prevent that behavior.
    */


    BoxesContainer.prototype._pushCommand = function(command, execute) {
      if ((execute == null) || execute) {
        command.execute();
      }
      this.undoStack.push(command);
      return this.redoStack.splice(0, this.redoStack.length);
    };

    /*
    Returns true if the innerRect Rectangle is fully
    contained within the outerRect Rectangle, false otherwise.
    */


    BoxesContainer._rectContainsRect = function(outerRect, innerRect) {
      return innerRect.topLeft.x >= outerRect.topLeft.x && innerRect.topLeft.y >= outerRect.topLeft.y && innerRect.topLeft.x + innerRect.size.width <= outerRect.topLeft.x + outerRect.size.width && innerRect.topLeft.y + innerRect.size.height <= outerRect.topLeft.y + outerRect.size.height;
    };

    return BoxesContainer;

  })();

  RemoveBoxesCommand = (function() {
    /*
    Class constructor, omit the boxesSelector argument to
    issue a command for removing all boxes.
    */

    function RemoveBoxesCommand(boxesContainer, boxesSelector) {
      var box, boxArray;
      this.boxesContainer = boxesContainer;
      if (boxesSelector != null) {
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
      }
      this.boxes = this.boxesContainer.getBoxesFromIds(this.boxIds);
    }

    RemoveBoxesCommand.prototype.execute = function() {
      return this.boxesContainer.removeBoxes(this.boxIds);
    };

    RemoveBoxesCommand.prototype.undo = function() {
      var box, _i, _len, _ref, _results;
      _ref = this.boxes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        box = _ref[_i];
        _results.push(this.boxesContainer.addBox(box));
      }
      return _results;
    };

    return RemoveBoxesCommand;

  })();

  CreateBoxCommand = (function() {
    function CreateBoxCommand(boxesContainer, options) {
      this.boxesContainer = boxesContainer;
      this.options = options;
      this.box = void 0;
    }

    CreateBoxCommand.prototype.execute = function() {
      if (this.box == null) {
        this.box = new Box(this.boxesContainer.element, this.options);
      }
      return this.boxesContainer.addBox(this.box);
    };

    CreateBoxCommand.prototype.undo = function() {
      return this.boxesContainer.removeBoxes([this.box.element.attr('id')]);
    };

    return CreateBoxCommand;

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

  Canvas = (function() {
    function Canvas(root) {
      this.root = root;
      this.element = void 0;
      this.downPosition = void 0;
      this.rectSize = void 0;
      this.build();
    }

    Canvas.prototype.build = function() {
      var _this = this;
      this.element = $('<canvas></canvas>').addClass('ppedit-canvas').attr('width', '600px').attr('height', '960px').on('containerMouseDown', function(event, mouseEvent) {
        _this.downPosition = {
          x: mouseEvent.offsetX,
          y: mouseEvent.offsetY
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
      this.root.append(this.element);
      return this._context = this.element.get(0).getContext('2d');
    };

    Canvas.prototype.drawRect = function(topLeft, size) {
      this._context.clearRect(0, 0, this.element.width(), this.element.height());
      this._context.globalAlpha = 0.2;
      this._context.beginPath();
      this._context.rect(topLeft.x, topLeft.y, size.width, size.height);
      this._context.fillStyle = 'blue';
      return this._context.fill();
    };

    Canvas.prototype.clear = function() {
      this._context.clearRect(0, 0, this.element.width(), this.element.height());
      this.downPosition = void 0;
      return this.rectSize = void 0;
    };

    return Canvas;

  })();

  Grid = (function() {
    function Grid(root) {
      this.root = root;
      this.elementGrid = $('\
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
      this.root.append(this.elementGrid);
    }

    Grid.prototype.toggleGrid = function() {
      return this.elementGrid.toggle();
    };

    return Grid;

  })();

  EditorManager = (function() {
    function EditorManager(root) {
      this.root = root;
      this.prevMouseMoveEvent = void 0;
      this.canvas = void 0;
      this.grid = void 0;
      this.boxesContainer = void 0;
      this.element = void 0;
      this.build();
    }

    EditorManager.prototype.build = function() {
      var _this = this;
      this.element = $('<div></div>');
      this.root.append(this.element);
      this.element.addClass("ppedit-container").addClass("col-xs-8").attr('tabindex', 0).mousedown(function() {
        if ($('.ppedit-box-selected').length === 0) {
          return $('.ppedit-canvas').trigger('containerMouseDown', [event]);
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
      }).mouseup(function() {
        _this.element.find('*').trigger('containerMouseUp');
        return _this.prevMouseMoveEvent = void 0;
      }).keydown(function(event) {
        return _this.element.find('*').trigger('containerKeyDown', [event]);
      }).on('canvasRectSelect', function(event, rect) {
        return _this.boxesContainer.selectBoxesInRect(rect);
      });
      this.boxesContainer = new BoxesContainer(this.element);
      this.canvas = new Canvas(this.element);
      return this.grid = new Grid(this.element);
    };

    return EditorManager;

  })();

  Panel = (function() {
    function Panel(root) {
      var _this = this;
      this.root = root;
      this.element = $('\
        <div class="col-xs-5">\
          \
           <!-- <button class="btn btn-sm btn-info moveElementUpBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-up"></span></button>\
\
           <button class="btn btn-sm btn-info moveElementDownBtn" type="button"><span class="glyphicon glyphicon-circle-arrow-down"></span></button> -->\
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
          <table class="table table-hover" id="dataPanel">\
              <thead>   \
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
        </div>');
      this.root.append(this.element);
      $(".addElementBtn").click(function() {
        return _this.root.trigger('panelClickAddBtnClick', []);
      });
      $(".clearAllElementBtn").click(function() {
        _this.clearAll("dataPanel");
        return _this.root.trigger('panelClickClearAllBtnClick', []);
      });
      $(".gridElementBtn").click(function() {
        return _this.root.trigger('panelClickGridBtnClick', []);
      });
    }

    Panel.prototype.moveElementUp = function(panelID) {};

    Panel.prototype.moveElementUpDown = function(panelID) {};

    Panel.prototype.addElement = function(panelID, boxid) {
      var newRow,
        _this = this;
      newRow = $("        <tr>            <td><span class=\"glyphicon glyphicon-remove-sign icon-4x red deleteElementBtn\"></span></td>            <td><input type=\"text\" class=\"input-block-level\" placeholder=\"Enter name\"></input></td>            <td><div class=\"ppedit-slider\"></div></td>                            </tr>").attr('ppedit-box-id', boxid);
      $("#" + panelID + " tbody").append(newRow);
      newRow.find(".ppedit-slider").slider({
        min: 0,
        max: 100,
        step: 1,
        value: 100
      }).on('slide', function(event) {
        var boxId, opacityVal;
        opacityVal = $(event.target).val();
        boxId = newRow.attr('ppedit-box-id');
        return _this.root.trigger('onRowSliderValChanged', [boxId, parseInt(opacityVal) / 100]);
      });
      return newRow.find(".deleteElementBtn").on('click', function(event) {
        var boxIds;
        boxIds = newRow.attr('ppedit-box-id');
        _this.root.trigger('onRowDeleteBtnClick', [boxIds]);
        return newRow.remove();
      });
    };

    Panel.prototype.clearAll = function(panelID) {
      return $("#" + panelID + " td").remove();
    };

    return Panel;

  })();

  Controller = (function() {
    function Controller(root) {
      var row,
        _this = this;
      this.root = root;
      this.element = $('\
      <div class="container">\
        <div class="row"></div>\
      </div>\
    ');
      this.root.append(this.element);
      row = this.element.find('.row');
      this.editorManager = new EditorManager(row);
      this.panel = new Panel(row);
      row.on('panelClickAddBtnClick', function(event) {
        var box;
        box = _this.editorManager.boxesContainer.createBox();
        return _this.panel.addElement("dataPanel", box.element.attr('id'));
      });
      row.on('panelClickGridBtnClick', function(event) {
        return _this.editorManager.grid.toggleGrid();
      });
      row.on('panelClickClearAllBtnClick', function(event) {
        return _this.editorManager.boxesContainer.removeBoxes();
      });
      row.on('onRowDeleteBtnClick', function(event, boxId) {
        return _this.editorManager.boxesContainer.removeBoxes([boxId]);
      });
      row.on('onRowSliderValChanged', function(event, boxId, opacityVal) {
        return _this.editorManager.boxesContainer.chageBoxOpacity(boxId, opacityVal);
      });
    }

    return Controller;

  })();

  PCController = (function(_super) {
    __extends(PCController, _super);

    function PCController(root) {
      var _this = this;
      this.root = root;
      PCController.__super__.constructor.call(this, this.root);
      this.editorManager.root.keydown(function(event) {
        if (event.keyCode === 90 && event.ctrlKey) {
          event.preventDefault();
          _this.editorManager.boxesContainer.undo();
        }
        if (event.keyCode === 89 && event.ctrlKey) {
          event.preventDefault();
          _this.editorManager.boxesContainer.redo();
        }
        if (event.keyCode === 46 || (event.keyCode === 46 && event.ctrlKey)) {
          event.preventDefault();
          return _this.editorManager.boxesContainer.deleteSelectedBoxes();
        }
      });
    }

    return PCController;

  })(Controller);

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
        var controller;
        $this = $(this);
        $.extend(_settings, options || {});
        controller = new PCController($this);
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

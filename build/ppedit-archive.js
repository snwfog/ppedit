/* =========================================================
 * bootstrap-slider.js v2.0.0
 * http://www.eyecon.ro/bootstrap-slider
 * =========================================================
 * Copyright 2012 Stefan Petre
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */
 
!function( $ ) {

	var Slider = function(element, options) {
		this.element = $(element);
		this.picker = $('<div class="slider">'+
							'<div class="slider-track">'+
								'<div class="slider-selection"></div>'+
								'<div class="slider-handle"></div>'+
								'<div class="slider-handle"></div>'+
							'</div>'+
							'<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'+
						'</div>')
							.insertBefore(this.element)
							.append(this.element);
		this.id = this.element.data('slider-id')||options.id;
		if (this.id) {
			this.picker[0].id = this.id;
		}

		if (typeof Modernizr !== 'undefined' && Modernizr.touch) {
			this.touchCapable = true;
		}

		var tooltip = this.element.data('slider-tooltip')||options.tooltip;

		this.tooltip = this.picker.find('.tooltip');
		this.tooltipInner = this.tooltip.find('div.tooltip-inner');

		this.orientation = this.element.data('slider-orientation')||options.orientation;
		switch(this.orientation) {
			case 'vertical':
				this.picker.addClass('slider-vertical');
				this.stylePos = 'top';
				this.mousePos = 'pageY';
				this.sizePos = 'offsetHeight';
				this.tooltip.addClass('right')[0].style.left = '100%';
				break;
			default:
				this.picker
					.addClass('slider-horizontal')
					.css('width', this.element.outerWidth());
				this.orientation = 'horizontal';
				this.stylePos = 'left';
				this.mousePos = 'pageX';
				this.sizePos = 'offsetWidth';
				this.tooltip.addClass('top')[0].style.top = -this.tooltip.outerHeight() - 14 + 'px';
				break;
		}

		this.min = this.element.data('slider-min')||options.min;
		this.max = this.element.data('slider-max')||options.max;
		this.step = this.element.data('slider-step')||options.step;
		this.value = this.element.data('slider-value')||options.value;
		if (this.value[1]) {
			this.range = true;
		}

		this.selection = this.element.data('slider-selection')||options.selection;
		this.selectionEl = this.picker.find('.slider-selection');
		if (this.selection === 'none') {
			this.selectionEl.addClass('hide');
		}
		this.selectionElStyle = this.selectionEl[0].style;


		this.handle1 = this.picker.find('.slider-handle:first');
		this.handle1Stype = this.handle1[0].style;
		this.handle2 = this.picker.find('.slider-handle:last');
		this.handle2Stype = this.handle2[0].style;

		var handle = this.element.data('slider-handle')||options.handle;
		switch(handle) {
			case 'round':
				this.handle1.addClass('round');
				this.handle2.addClass('round');
				break
			case 'triangle':
				this.handle1.addClass('triangle');
				this.handle2.addClass('triangle');
				break
		}

		if (this.range) {
			this.value[0] = Math.max(this.min, Math.min(this.max, this.value[0]));
			this.value[1] = Math.max(this.min, Math.min(this.max, this.value[1]));
		} else {
			this.value = [ Math.max(this.min, Math.min(this.max, this.value))];
			this.handle2.addClass('hide');
			if (this.selection == 'after') {
				this.value[1] = this.max;
			} else {
				this.value[1] = this.min;
			}
		}
		this.diff = this.max - this.min;
		this.percentage = [
			(this.value[0]-this.min)*100/this.diff,
			(this.value[1]-this.min)*100/this.diff,
			this.step*100/this.diff
		];

		this.offset = this.picker.offset();
		this.size = this.picker[0][this.sizePos];

		this.formater = options.formater;

		this.layout();

		if (this.touchCapable) {
			// Touch: Bind touch events:
			this.picker.on({
				touchstart: $.proxy(this.mousedown, this)
			});
		} else {
			this.picker.on({
				mousedown: $.proxy(this.mousedown, this)
			});
		}

		if (tooltip === 'show') {
			this.picker.on({
				mouseenter: $.proxy(this.showTooltip, this),
				mouseleave: $.proxy(this.hideTooltip, this)
			});
		} else {
			this.tooltip.addClass('hide');
		}
	};

	Slider.prototype = {
		constructor: Slider,

		over: false,
		inDrag: false,
		
		showTooltip: function(){
			this.tooltip.addClass('in');
			//var left = Math.round(this.percent*this.width);
			//this.tooltip.css('left', left - this.tooltip.outerWidth()/2);
			this.over = true;
		},
		
		hideTooltip: function(){
			if (this.inDrag === false) {
				this.tooltip.removeClass('in');
			}
			this.over = false;
		},

		layout: function(){
			this.handle1Stype[this.stylePos] = this.percentage[0]+'%';
			this.handle2Stype[this.stylePos] = this.percentage[1]+'%';
			if (this.orientation == 'vertical') {
				this.selectionElStyle.top = Math.min(this.percentage[0], this.percentage[1]) +'%';
				this.selectionElStyle.height = Math.abs(this.percentage[0] - this.percentage[1]) +'%';
			} else {
				this.selectionElStyle.left = Math.min(this.percentage[0], this.percentage[1]) +'%';
				this.selectionElStyle.width = Math.abs(this.percentage[0] - this.percentage[1]) +'%';
			}
			if (this.range) {
				this.tooltipInner.text(
					this.formater(this.value[0]) + 
					' : ' + 
					this.formater(this.value[1])
				);
				this.tooltip[0].style[this.stylePos] = this.size * (this.percentage[0] + (this.percentage[1] - this.percentage[0])/2)/100 - (this.orientation === 'vertical' ? this.tooltip.outerHeight()/2 : this.tooltip.outerWidth()/2) +'px';
			} else {
				this.tooltipInner.text(
					this.formater(this.value[0])
				);
				this.tooltip[0].style[this.stylePos] = this.size * this.percentage[0]/100 - (this.orientation === 'vertical' ? this.tooltip.outerHeight()/2 : this.tooltip.outerWidth()/2) +'px';
			}
		},

		mousedown: function(ev) {

			// Touch: Get the original event:
			if (this.touchCapable && ev.type === 'touchstart') {
				ev = ev.originalEvent;
			}

			this.offset = this.picker.offset();
			this.size = this.picker[0][this.sizePos];

			var percentage = this.getPercentage(ev);

			if (this.range) {
				var diff1 = Math.abs(this.percentage[0] - percentage);
				var diff2 = Math.abs(this.percentage[1] - percentage);
				this.dragged = (diff1 < diff2) ? 0 : 1;
			} else {
				this.dragged = 0;
			}

			this.percentage[this.dragged] = percentage;
			this.layout();

			if (this.touchCapable) {
				// Touch: Bind touch events:
				$(document).on({
					touchmove: $.proxy(this.mousemove, this),
					touchend: $.proxy(this.mouseup, this)
				});
			} else {
				$(document).on({
					mousemove: $.proxy(this.mousemove, this),
					mouseup: $.proxy(this.mouseup, this)
				});
			}

			this.inDrag = true;
			var val = this.calculateValue();
			this.element.trigger({
					type: 'slideStart',
					value: val
				}).trigger({
					type: 'slide',
					value: val
				});
			return false;
		},

		mousemove: function(ev) {
			
			// Touch: Get the original event:
			if (this.touchCapable && ev.type === 'touchmove') {
				ev = ev.originalEvent;
			}

			var percentage = this.getPercentage(ev);
			if (this.range) {
				if (this.dragged === 0 && this.percentage[1] < percentage) {
					this.percentage[0] = this.percentage[1];
					this.dragged = 1;
				} else if (this.dragged === 1 && this.percentage[0] > percentage) {
					this.percentage[1] = this.percentage[0];
					this.dragged = 0;
				}
			}
			this.percentage[this.dragged] = percentage;
			this.layout();
			var val = this.calculateValue();
			this.element
				.trigger({
					type: 'slide',
					value: val
				})
				.data('value', val)
				.prop('value', val);
			return false;
		},

		mouseup: function(ev) {
			if (this.touchCapable) {
				// Touch: Bind touch events:
				$(document).off({
					touchmove: this.mousemove,
					touchend: this.mouseup
				});
			} else {
				$(document).off({
					mousemove: this.mousemove,
					mouseup: this.mouseup
				});
			}

			this.inDrag = false;
			if (this.over == false) {
				this.hideTooltip();
			}
			this.element;
			var val = this.calculateValue();
			this.element
				.trigger({
					type: 'slideStop',
					value: val
				})
				.data('value', val)
				.prop('value', val);
			return false;
		},

		calculateValue: function() {
			var val;
			if (this.range) {
				val = [
					(this.min + Math.round((this.diff * this.percentage[0]/100)/this.step)*this.step),
					(this.min + Math.round((this.diff * this.percentage[1]/100)/this.step)*this.step)
				];
				this.value = val;
			} else {
				val = (this.min + Math.round((this.diff * this.percentage[0]/100)/this.step)*this.step);
				this.value = [val, this.value[1]];
			}
			return val;
		},

		getPercentage: function(ev) {
			if (this.touchCapable) {
				ev = ev.touches[0];
			}
			var percentage = (ev[this.mousePos] - this.offset[this.stylePos])*100/this.size;
			percentage = Math.round(percentage/this.percentage[2])*this.percentage[2];
			return Math.max(0, Math.min(100, percentage));
		},

		getValue: function() {
			if (this.range) {
				return this.value;
			}
			return this.value[0];
		},

		setValue: function(val) {
			this.value = val;

			if (this.range) {
				this.value[0] = Math.max(this.min, Math.min(this.max, this.value[0]));
				this.value[1] = Math.max(this.min, Math.min(this.max, this.value[1]));
			} else {
				this.value = [ Math.max(this.min, Math.min(this.max, this.value))];
				this.handle2.addClass('hide');
				if (this.selection == 'after') {
					this.value[1] = this.max;
				} else {
					this.value[1] = this.min;
				}
			}
			this.diff = this.max - this.min;
			this.percentage = [
				(this.value[0]-this.min)*100/this.diff,
				(this.value[1]-this.min)*100/this.diff,
				this.step*100/this.diff
			];
			this.layout();
		}
	};

	$.fn.slider = function ( option, val ) {
		return this.each(function () {
			var $this = $(this),
				data = $this.data('slider'),
				options = typeof option === 'object' && option;
			if (!data)  {
				$this.data('slider', (data = new Slider(this, $.extend({}, $.fn.slider.defaults,options))));
			}
			if (typeof option == 'string') {
				data[option](val);
			}
		})
	};

	$.fn.slider.defaults = {
		min: 0,
		max: 10,
		step: 1,
		orientation: 'horizontal',
		value: 5,
		selection: 'before',
		tooltip: 'show',
		handle: 'round',
		formater: function(value) {
			return value;
		}
	};

	$.fn.slider.Constructor = Slider;

}( window.jQuery );;


/*
colpick Color Picker
Copyright 2013 Jose Vargas. Licensed under GPL license. Based on Stefan Petre's Color Picker www.eyecon.ro, dual licensed under the MIT and GPL licenses

For usage and examples: colpick.com/plugin
 */

(function ($) {
	var colpick = function () {
		var
			tpl = '<div class="colpick"><div class="colpick_color"><div class="colpick_color_overlay1"><div class="colpick_color_overlay2"><div class="colpick_selector_outer"><div class="colpick_selector_inner"></div></div></div></div></div><div class="colpick_hue"><div class="colpick_hue_arrs"><div class="colpick_hue_larr"></div><div class="colpick_hue_rarr"></div></div></div><div class="colpick_new_color"></div><div class="colpick_current_color"></div><div class="colpick_hex_field"><div class="colpick_field_letter">#</div><input type="text" maxlength="6" size="6" /></div><div class="colpick_rgb_r colpick_field"><div class="colpick_field_letter">R</div><input type="text" maxlength="3" size="3" /><div class="colpick_field_arrs"><div class="colpick_field_uarr"></div><div class="colpick_field_darr"></div></div></div><div class="colpick_rgb_g colpick_field"><div class="colpick_field_letter">G</div><input type="text" maxlength="3" size="3" /><div class="colpick_field_arrs"><div class="colpick_field_uarr"></div><div class="colpick_field_darr"></div></div></div><div class="colpick_rgb_b colpick_field"><div class="colpick_field_letter">B</div><input type="text" maxlength="3" size="3" /><div class="colpick_field_arrs"><div class="colpick_field_uarr"></div><div class="colpick_field_darr"></div></div></div><div class="colpick_hsb_h colpick_field"><div class="colpick_field_letter">H</div><input type="text" maxlength="3" size="3" /><div class="colpick_field_arrs"><div class="colpick_field_uarr"></div><div class="colpick_field_darr"></div></div></div><div class="colpick_hsb_s colpick_field"><div class="colpick_field_letter">S</div><input type="text" maxlength="3" size="3" /><div class="colpick_field_arrs"><div class="colpick_field_uarr"></div><div class="colpick_field_darr"></div></div></div><div class="colpick_hsb_b colpick_field"><div class="colpick_field_letter">B</div><input type="text" maxlength="3" size="3" /><div class="colpick_field_arrs"><div class="colpick_field_uarr"></div><div class="colpick_field_darr"></div></div></div><div class="colpick_submit"></div></div>',
			defaults = {
				showEvent: 'click',
				onShow: function () {},
				onBeforeShow: function(){},
				onHide: function () {},
				onChange: function () {},
				onSubmit: function () {},
				colorScheme: 'light',
				color: '3289c7',
				livePreview: true,
				flat: false,
				layout: 'full',
				submit: 1,
				submitText: 'OK',
				height: 156
			},
			//Fill the inputs of the plugin
			fillRGBFields = function  (hsb, cal) {
				var rgb = hsbToRgb(hsb);
				$(cal).data('colpick').fields
					.eq(1).val(rgb.r).end()
					.eq(2).val(rgb.g).end()
					.eq(3).val(rgb.b).end();
			},
			fillHSBFields = function  (hsb, cal) {
				$(cal).data('colpick').fields
					.eq(4).val(Math.round(hsb.h)).end()
					.eq(5).val(Math.round(hsb.s)).end()
					.eq(6).val(Math.round(hsb.b)).end();
			},
			fillHexFields = function (hsb, cal) {
				$(cal).data('colpick').fields.eq(0).val(hsbToHex(hsb));
			},
			//Set the round selector position
			setSelector = function (hsb, cal) {
				$(cal).data('colpick').selector.css('backgroundColor', '#' + hsbToHex({h: hsb.h, s: 100, b: 100}));
				$(cal).data('colpick').selectorIndic.css({
					left: parseInt($(cal).data('colpick').height * hsb.s/100, 10),
					top: parseInt($(cal).data('colpick').height * (100-hsb.b)/100, 10)
				});
			},
			//Set the hue selector position
			setHue = function (hsb, cal) {
				$(cal).data('colpick').hue.css('top', parseInt($(cal).data('colpick').height - $(cal).data('colpick').height * hsb.h/360, 10));
			},
			//Set current and new colors
			setCurrentColor = function (hsb, cal) {
				$(cal).data('colpick').currentColor.css('backgroundColor', '#' + hsbToHex(hsb));
			},
			setNewColor = function (hsb, cal) {
				$(cal).data('colpick').newColor.css('backgroundColor', '#' + hsbToHex(hsb));
			},
			//Called when the new color is changed
			change = function (ev) {
				var cal = $(this).parent().parent(), col;
				if (this.parentNode.className.indexOf('_hex') > 0) {
					cal.data('colpick').color = col = hexToHsb(fixHex(this.value));
					fillRGBFields(col, cal.get(0));
					fillHSBFields(col, cal.get(0));
				} else if (this.parentNode.className.indexOf('_hsb') > 0) {
					cal.data('colpick').color = col = fixHSB({
						h: parseInt(cal.data('colpick').fields.eq(4).val(), 10),
						s: parseInt(cal.data('colpick').fields.eq(5).val(), 10),
						b: parseInt(cal.data('colpick').fields.eq(6).val(), 10)
					});
					fillRGBFields(col, cal.get(0));
					fillHexFields(col, cal.get(0));
				} else {
					cal.data('colpick').color = col = rgbToHsb(fixRGB({
						r: parseInt(cal.data('colpick').fields.eq(1).val(), 10),
						g: parseInt(cal.data('colpick').fields.eq(2).val(), 10),
						b: parseInt(cal.data('colpick').fields.eq(3).val(), 10)
					}));
					fillHexFields(col, cal.get(0));
					fillHSBFields(col, cal.get(0));
				}
				setSelector(col, cal.get(0));
				setHue(col, cal.get(0));
				setNewColor(col, cal.get(0));
				cal.data('colpick').onChange.apply(cal.parent(), [col, hsbToHex(col), hsbToRgb(col)]);
			},
			//Change style on blur and on focus of inputs
			blur = function (ev) {
				$(this).parent().removeClass('colpick_focus');
			},
			focus = function () {
				$(this).parent().parent().data('colpick').fields.parent().removeClass('colpick_focus');
				$(this).parent().addClass('colpick_focus');
			},
			//Increment/decrement arrows functions
			downIncrement = function (ev) {
				ev.preventDefault ? ev.preventDefault() : ev.returnValue = false;
				var field = $(this).parent().find('input').focus();
				var current = {
					el: $(this).parent().addClass('colpick_slider'),
					max: this.parentNode.className.indexOf('_hsb_h') > 0 ? 360 : (this.parentNode.className.indexOf('_hsb') > 0 ? 100 : 255),
					y: ev.pageY,
					field: field,
					val: parseInt(field.val(), 10),
					preview: $(this).parent().parent().data('colpick').livePreview
				};
				$(document).mouseup(current, upIncrement);
				$(document).mousemove(current, moveIncrement);
			},
			moveIncrement = function (ev) {
				ev.data.field.val(Math.max(0, Math.min(ev.data.max, parseInt(ev.data.val - ev.pageY + ev.data.y, 10))));
				if (ev.data.preview) {
					change.apply(ev.data.field.get(0), [true]);
				}
				return false;
			},
			upIncrement = function (ev) {
				change.apply(ev.data.field.get(0), [true]);
				ev.data.el.removeClass('colpick_slider').find('input').focus();
				$(document).off('mouseup', upIncrement);
				$(document).off('mousemove', moveIncrement);
				return false;
			},
			//Hue slider functions
			downHue = function (ev) {
				ev.preventDefault ? ev.preventDefault() : ev.returnValue = false;
				var current = {
					cal: $(this).parent(),
					y: $(this).offset().top
				};
				current.preview = current.cal.data('colpick').livePreview;
				$(document).mouseup(current, upHue);
				$(document).mousemove(current, moveHue);
				
				change.apply(
					current.cal.data('colpick')
					.fields.eq(4).val(parseInt(360*(current.cal.data('colpick').height - (ev.pageY - current.y))/current.cal.data('colpick').height, 10))
						.get(0),
					[current.preview]
				);
			},
			moveHue = function (ev) {
				change.apply(
					ev.data.cal.data('colpick')
					.fields.eq(4).val(parseInt(360*(ev.data.cal.data('colpick').height - Math.max(0,Math.min(ev.data.cal.data('colpick').height,(ev.pageY - ev.data.y))))/ev.data.cal.data('colpick').height, 10))
						.get(0),
					[ev.data.preview]
				);
				return false;
			},
			upHue = function (ev) {
				fillRGBFields(ev.data.cal.data('colpick').color, ev.data.cal.get(0));
				fillHexFields(ev.data.cal.data('colpick').color, ev.data.cal.get(0));
				$(document).off('mouseup', upHue);
				$(document).off('mousemove', moveHue);
				return false;
			},
			//Color selector functions
			downSelector = function (ev) {
				ev.preventDefault ? ev.preventDefault() : ev.returnValue = false;
				var current = {
					cal: $(this).parent(),
					pos: $(this).offset()
				};
				current.preview = current.cal.data('colpick').livePreview;
				
				$(document).mouseup(current, upSelector);
				$(document).mousemove(current, moveSelector);
				
				change.apply(
					current.cal.data('colpick').fields
					.eq(6).val(parseInt(100*(current.cal.data('colpick').height - (ev.pageY - current.pos.top))/current.cal.data('colpick').height, 10)).end()
					.eq(5).val(parseInt(100*(ev.pageX - current.pos.left)/current.cal.data('colpick').height, 10))
					.get(0),
					[current.preview]
				);
			},
			moveSelector = function (ev) {
				change.apply(
					ev.data.cal.data('colpick').fields
					.eq(6).val(parseInt(100*(ev.data.cal.data('colpick').height - Math.max(0,Math.min(ev.data.cal.data('colpick').height,(ev.pageY - ev.data.pos.top))))/ev.data.cal.data('colpick').height, 10)).end()
					.eq(5).val(parseInt(100*(Math.max(0,Math.min(ev.data.cal.data('colpick').height,(ev.pageX - ev.data.pos.left))))/ev.data.cal.data('colpick').height, 10))
					.get(0),
					[ev.data.preview]
				);
				return false;
			},
			upSelector = function (ev) {
				fillRGBFields(ev.data.cal.data('colpick').color, ev.data.cal.get(0));
				fillHexFields(ev.data.cal.data('colpick').color, ev.data.cal.get(0));
				$(document).off('mouseup', upSelector);
				$(document).off('mousemove', moveSelector);
				return false;
			},
			//Submit button
			clickSubmit = function (ev) {
				var cal = $(this).parent();
				var col = cal.data('colpick').color;
				cal.data('colpick').origColor = col;
				setCurrentColor(col, cal.get(0));
				cal.data('colpick').onSubmit(col, hsbToHex(col), hsbToRgb(col), cal.data('colpick').el);
			},
			//Show/hide the color picker
			show = function (ev) {
				var cal = $('#' + $(this).data('colpickId'));
				cal.data('colpick').onBeforeShow.apply(this, [cal.get(0)]);
				var pos = $(this).offset();
				var top = pos.top + this.offsetHeight;
				var left = pos.left;
				var viewPort = getViewport();
				if (left + 346 > viewPort.l + viewPort.w) {
					left -= 346;
				}
				cal.css({left: left + 'px', top: top + 'px'});
				if (cal.data('colpick').onShow.apply(this, [cal.get(0)]) != false) {
					cal.show();
				}
				//Hide when user clicks outside
				$('html').mousedown({cal:cal}, hide);
				cal.mousedown(function(ev){ev.stopPropagation();})
			},
			hide = function (ev) {
				if (ev.data.cal.data('colpick').onHide.apply(this, [ev.data.cal.get(0)]) != false) {
					ev.data.cal.hide();
				}
				$('html').off('mousedown', hide);
			},
			getViewport = function () {
				var m = document.compatMode == 'CSS1Compat';
				return {
					l : window.pageXOffset || (m ? document.documentElement.scrollLeft : document.body.scrollLeft),
					w : window.innerWidth || (m ? document.documentElement.clientWidth : document.body.clientWidth)
				};
			},
			//Fix the values if the user enters a negative or high value
			fixHSB = function (hsb) {
				return {
					h: Math.min(360, Math.max(0, hsb.h)),
					s: Math.min(100, Math.max(0, hsb.s)),
					b: Math.min(100, Math.max(0, hsb.b))
				};
			}, 
			fixRGB = function (rgb) {
				return {
					r: Math.min(255, Math.max(0, rgb.r)),
					g: Math.min(255, Math.max(0, rgb.g)),
					b: Math.min(255, Math.max(0, rgb.b))
				};
			},
			fixHex = function (hex) {
				var len = 6 - hex.length;
				if (len > 0) {
					var o = [];
					for (var i=0; i<len; i++) {
						o.push('0');
					}
					o.push(hex);
					hex = o.join('');
				}
				return hex;
			},
			restoreOriginal = function () {
				var cal = $(this).parent();
				var col = cal.data('colpick').origColor;
				cal.data('colpick').color = col;
				fillRGBFields(col, cal.get(0));
				fillHexFields(col, cal.get(0));
				fillHSBFields(col, cal.get(0));
				setSelector(col, cal.get(0));
				setHue(col, cal.get(0));
				setNewColor(col, cal.get(0));
			};
		return {
			init: function (opt) {
				opt = $.extend({}, defaults, opt||{});
				//Set color
				if (typeof opt.color == 'string') {
					opt.color = hexToHsb(opt.color);
				} else if (opt.color.r != undefined && opt.color.g != undefined && opt.color.b != undefined) {
					opt.color = rgbToHsb(opt.color);
				} else if (opt.color.h != undefined && opt.color.s != undefined && opt.color.b != undefined) {
					opt.color = fixHSB(opt.color);
				} else {
					return this;
				}
				
				//For each selected DOM element
				return this.each(function () {
					//If the element does not have an ID
					if (!$(this).data('colpickId')) {
						var options = $.extend({}, opt);
						options.origColor = opt.color;
						//Generate and assign a random ID
						var id = 'collorpicker_' + parseInt(Math.random() * 1000);
						$(this).data('colpickId', id);
						//Set the tpl's ID and get the HTML
						var cal = $(tpl).attr('id', id);
						//Add class according to layout
						cal.addClass('colpick_'+options.layout+(options.submit?'':' colpick_'+options.layout+'_ns'));
						//Add class if the color scheme is not default
						if(options.colorScheme != 'light') {
							cal.addClass('colpick_'+options.colorScheme);
						}
						//Setup submit button
						cal.find('div.colpick_submit').html(options.submitText).click(clickSubmit);
						//Setup input fields
						options.fields = cal.find('input').change(change).blur(blur).focus(focus);
						cal.find('div.colpick_field_arrs').mousedown(downIncrement).end().find('div.colpick_current_color').click(restoreOriginal);
						//Setup hue selector
						options.selector = cal.find('div.colpick_color').mousedown(downSelector);
						options.selectorIndic = options.selector.find('div.colpick_selector_outer');
						//Store parts of the plugin
						options.el = this;
						options.hue = cal.find('div.colpick_hue_arrs');
						huebar = options.hue.parent();
						//Paint the hue bar
						var UA = navigator.userAgent.toLowerCase();
						var isIE = navigator.appName === 'Microsoft Internet Explorer';
						var IEver = isIE ? parseFloat( UA.match( /msie ([0-9]{1,}[\.0-9]{0,})/ )[1] ) : 0;
						var ngIE = ( isIE && IEver < 10 );
						var stops = ['#ff0000','#ff0080','#ff00ff','#8000ff','#0000ff','#0080ff','#00ffff','#00ff80','#00ff00','#80ff00','#ffff00','#ff8000','#ff0000'];
						if(ngIE) {
							var i, div;
							for(i=0; i<=11; i++) {
								div = $('<div></div>').attr('style','height:8.333333%; filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='+stops[i]+', endColorstr='+stops[i+1]+'); -ms-filter: "progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='+stops[i]+', endColorstr='+stops[i+1]+')";');
								huebar.append(div);
							}
						} else {
							stopList = stops.join(',');
							huebar.attr('style','background:-webkit-linear-gradient(top center,'+stopList+'); background:-moz-linear-gradient(top center,'+stopList+'); background:linear-gradient(to bottom,'+stopList+'); ');
							huebar.css({'background':'linear-gradient(to bottom,'+stopList+')'});
							huebar.css({'background':'-moz-linear-gradient(top,'+stopList+')'});
						}
						cal.find('div.colpick_hue').mousedown(downHue);
						options.newColor = cal.find('div.colpick_new_color');
						options.currentColor = cal.find('div.colpick_current_color');
						//Store options and fill with default color
						cal.data('colpick', options);
						fillRGBFields(options.color, cal.get(0));
						fillHSBFields(options.color, cal.get(0));
						fillHexFields(options.color, cal.get(0));
						setHue(options.color, cal.get(0));
						setSelector(options.color, cal.get(0));
						setCurrentColor(options.color, cal.get(0));
						setNewColor(options.color, cal.get(0));
						//Append to body if flat=false, else show in place
						if (options.flat) {
							cal.appendTo(this).show();
							cal.css({
								position: 'relative',
								display: 'block'
							});
						} else {
							cal.appendTo(document.body);
							$(this).on(options.showEvent, show);
							cal.css({
								position:'absolute'
							});
						}
					}
				});
			},
			//Shows the picker
			showPicker: function() {
				return this.each( function () {
					if ($(this).data('colpickId')) {
						show.apply(this);
					}
				});
			},
			//Hides the picker
			hidePicker: function() {
				return this.each( function () {
					if ($(this).data('colpickId')) {
						$('#' + $(this).data('colpickId')).hide();
					}
				});
			},
			//Sets a color as new and current (default)
			setColor: function(col, setCurrent) {
				setCurrent = (typeof setCurrent === "undefined") ? 1 : setCurrent;
				if (typeof col == 'string') {
					col = hexToHsb(col);
				} else if (col.r != undefined && col.g != undefined && col.b != undefined) {
					col = rgbToHsb(col);
				} else if (col.h != undefined && col.s != undefined && col.b != undefined) {
					col = fixHSB(col);
				} else {
					return this;
				}
				return this.each(function(){
					if ($(this).data('colpickId')) {
						var cal = $('#' + $(this).data('colpickId'));
						cal.data('colpick').color = col;
						cal.data('colpick').origColor = col;
						fillRGBFields(col, cal.get(0));
						fillHSBFields(col, cal.get(0));
						fillHexFields(col, cal.get(0));
						setHue(col, cal.get(0));
						setSelector(col, cal.get(0));
						
						setNewColor(col, cal.get(0));
						cal.data('colpick').onChange.apply(cal.parent(), [col, hsbToHex(col), hsbToRgb(col), 1]);
						if(setCurrent) {
							setCurrentColor(col, cal.get(0));
						}
					}
				});
			}
		};
	}();
	//Color space convertions
	var hexToRgb = function (hex) {
		var hex = parseInt(((hex.indexOf('#') > -1) ? hex.substring(1) : hex), 16);
		return {r: hex >> 16, g: (hex & 0x00FF00) >> 8, b: (hex & 0x0000FF)};
	};
	var hexToHsb = function (hex) {
		return rgbToHsb(hexToRgb(hex));
	};
	var rgbToHsb = function (rgb) {
		var hsb = {h: 0, s: 0, b: 0};
		var min = Math.min(rgb.r, rgb.g, rgb.b);
		var max = Math.max(rgb.r, rgb.g, rgb.b);
		var delta = max - min;
		hsb.b = max;
		hsb.s = max != 0 ? 255 * delta / max : 0;
		if (hsb.s != 0) {
			if (rgb.r == max) hsb.h = (rgb.g - rgb.b) / delta;
			else if (rgb.g == max) hsb.h = 2 + (rgb.b - rgb.r) / delta;
			else hsb.h = 4 + (rgb.r - rgb.g) / delta;
		} else hsb.h = -1;
		hsb.h *= 60;
		if (hsb.h < 0) hsb.h += 360;
		hsb.s *= 100/255;
		hsb.b *= 100/255;
		return hsb;
	};
	var hsbToRgb = function (hsb) {
		var rgb = {};
		var h = Math.round(hsb.h);
		var s = Math.round(hsb.s*255/100);
		var v = Math.round(hsb.b*255/100);
		if(s == 0) {
			rgb.r = rgb.g = rgb.b = v;
		} else {
			var t1 = v;
			var t2 = (255-s)*v/255;
			var t3 = (t1-t2)*(h%60)/60;
			if(h==360) h = 0;
			if(h<60) {rgb.r=t1;	rgb.b=t2; rgb.g=t2+t3}
			else if(h<120) {rgb.g=t1; rgb.b=t2;	rgb.r=t1-t3}
			else if(h<180) {rgb.g=t1; rgb.r=t2;	rgb.b=t2+t3}
			else if(h<240) {rgb.b=t1; rgb.r=t2;	rgb.g=t1-t3}
			else if(h<300) {rgb.b=t1; rgb.g=t2;	rgb.r=t2+t3}
			else if(h<360) {rgb.r=t1; rgb.g=t2;	rgb.b=t1-t3}
			else {rgb.r=0; rgb.g=0;	rgb.b=0}
		}
		return {r:Math.round(rgb.r), g:Math.round(rgb.g), b:Math.round(rgb.b)};
	};
	var rgbToHex = function (rgb) {
		var hex = [
			rgb.r.toString(16),
			rgb.g.toString(16),
			rgb.b.toString(16)
		];
		$.each(hex, function (nr, val) {
			if (val.length == 1) {
				hex[nr] = '0' + val;
			}
		});
		return hex.join('');
	};
	var hsbToHex = function (hsb) {
		return rgbToHex(hsbToRgb(hsb));
	};
	
	$.fn.extend({
		colpick: colpick.init,
		colpickHide: colpick.hidePicker,
		colpickShow: colpick.showPicker,
		colpickSetColor: colpick.setColor
	});
	$.extend({
		colpickRgbToHex: rgbToHex,
		colpickRgbToHsb: rgbToHsb,
		colpickHsbToHex: hsbToHex,
		colpickHsbToRgb: hsbToRgb,
		colpickHexToHsb: hexToHsb,
		colpickHexToRgb: hexToRgb
	});
})(jQuery);


(function() {/*
 A JavaScript implementation of the SHA family of hashes, as defined in FIPS
 PUB 180-2 as well as the corresponding HMAC implementation as defined in
 FIPS PUB 198a

 Copyright Brian Turek 2008-2012
 Distributed under the BSD License
 See http://caligatio.github.com/jsSHA/ for more information

 Several functions taken from Paul Johnson
*/
function n(a){throw a;}var r=null;function t(a,b){var c=[],f=(1<<b)-1,d=a.length*b,e;for(e=0;e<d;e+=b)c[e>>>5]|=(a.charCodeAt(e/b)&f)<<32-b-e%32;return{value:c,binLen:d}}function w(a){var b=[],c=a.length,f,d;0!==c%2&&n("String of HEX type must be in byte increments");for(f=0;f<c;f+=2)d=parseInt(a.substr(f,2),16),isNaN(d)&&n("String of HEX type contains invalid characters"),b[f>>>3]|=d<<24-4*(f%8);return{value:b,binLen:4*c}}
function A(a){var b=[],c=0,f,d,e,k,l;-1===a.search(/^[a-zA-Z0-9=+\/]+$/)&&n("Invalid character in base-64 string");f=a.indexOf("=");a=a.replace(/\=/g,"");-1!==f&&f<a.length&&n("Invalid '=' found in base-64 string");for(d=0;d<a.length;d+=4){l=a.substr(d,4);for(e=k=0;e<l.length;e+=1)f="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".indexOf(l[e]),k|=f<<18-6*e;for(e=0;e<l.length-1;e+=1)b[c>>2]|=(k>>>16-8*e&255)<<24-8*(c%4),c+=1}return{value:b,binLen:8*c}}
function D(a,b){var c="",f=4*a.length,d,e;for(d=0;d<f;d+=1)e=a[d>>>2]>>>8*(3-d%4),c+="0123456789abcdef".charAt(e>>>4&15)+"0123456789abcdef".charAt(e&15);return b.outputUpper?c.toUpperCase():c}
function E(a,b){var c="",f=4*a.length,d,e,k;for(d=0;d<f;d+=3){k=(a[d>>>2]>>>8*(3-d%4)&255)<<16|(a[d+1>>>2]>>>8*(3-(d+1)%4)&255)<<8|a[d+2>>>2]>>>8*(3-(d+2)%4)&255;for(e=0;4>e;e+=1)c=8*d+6*e<=32*a.length?c+"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".charAt(k>>>6*(3-e)&63):c+b.b64Pad}return c}
function F(a){var b={outputUpper:!1,b64Pad:"="};try{a.hasOwnProperty("outputUpper")&&(b.outputUpper=a.outputUpper),a.hasOwnProperty("b64Pad")&&(b.b64Pad=a.b64Pad)}catch(c){}"boolean"!==typeof b.outputUpper&&n("Invalid outputUpper formatting option");"string"!==typeof b.b64Pad&&n("Invalid b64Pad formatting option");return b}function G(a,b){return a>>>b|a<<32-b}function H(a,b,c){return a&b^~a&c}function S(a,b,c){return a&b^a&c^b&c}function T(a){return G(a,2)^G(a,13)^G(a,22)}
function U(a){return G(a,6)^G(a,11)^G(a,25)}function V(a){return G(a,7)^G(a,18)^a>>>3}function W(a){return G(a,17)^G(a,19)^a>>>10}function X(a,b){var c=(a&65535)+(b&65535);return((a>>>16)+(b>>>16)+(c>>>16)&65535)<<16|c&65535}function Y(a,b,c,f){var d=(a&65535)+(b&65535)+(c&65535)+(f&65535);return((a>>>16)+(b>>>16)+(c>>>16)+(f>>>16)+(d>>>16)&65535)<<16|d&65535}
function Z(a,b,c,f,d){var e=(a&65535)+(b&65535)+(c&65535)+(f&65535)+(d&65535);return((a>>>16)+(b>>>16)+(c>>>16)+(f>>>16)+(d>>>16)+(e>>>16)&65535)<<16|e&65535}
function $(a,b,c){var f,d,e,k,l,j,z,B,I,g,J,u,h,m,s,p,x,y,q,K,L,M,N,O,P,Q,v=[],R,C;"SHA-224"===c||"SHA-256"===c?(J=64,m=16,s=1,P=Number,p=X,x=Y,y=Z,q=V,K=W,L=T,M=U,O=S,N=H,Q=[1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,
338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298],g="SHA-224"===c?[3238371032,914150663,812702999,4144912697,4290775857,1750603025,1694076839,3204075428]:[1779033703,3144134277,1013904242,2773480762,
1359893119,2600822924,528734635,1541459225]):n("Unexpected error in SHA-2 implementation");a[b>>>5]|=128<<24-b%32;a[(b+65>>>9<<4)+15]=b;R=a.length;for(u=0;u<R;u+=m){b=g[0];f=g[1];d=g[2];e=g[3];k=g[4];l=g[5];j=g[6];z=g[7];for(h=0;h<J;h+=1)v[h]=16>h?new P(a[h*s+u],a[h*s+u+1]):x(K(v[h-2]),v[h-7],q(v[h-15]),v[h-16]),B=y(z,M(k),N(k,l,j),Q[h],v[h]),I=p(L(b),O(b,f,d)),z=j,j=l,l=k,k=p(e,B),e=d,d=f,f=b,b=p(B,I);g[0]=p(b,g[0]);g[1]=p(f,g[1]);g[2]=p(d,g[2]);g[3]=p(e,g[3]);g[4]=p(k,g[4]);g[5]=p(l,g[5]);g[6]=
p(j,g[6]);g[7]=p(z,g[7])}"SHA-224"===c?C=[g[0],g[1],g[2],g[3],g[4],g[5],g[6]]:"SHA-256"===c?C=g:n("Unexpected error in SHA-2 implementation");return C}
window.jsSHA=function(a,b,c){var f=r,d=r,e=0,k=[0],l=0,j=r,l="undefined"!==typeof c?c:8;8===l||16===l||n("charSize must be 8 or 16");"HEX"===b?(0!==a.length%2&&n("srcString of HEX type must be in byte increments"),j=w(a),e=j.binLen,k=j.value):"ASCII"===b||"TEXT"===b?(j=t(a,l),e=j.binLen,k=j.value):"B64"===b?(j=A(a),e=j.binLen,k=j.value):n("inputFormat must be HEX, TEXT, ASCII, or B64");this.getHash=function(a,b,c){var g=r,l=k.slice(),j="";switch(b){case "HEX":g=D;break;case "B64":g=E;break;default:n("format must be HEX or B64")}"SHA-224"===
a?(r===f&&(f=$(l,e,a)),j=g(f,F(c))):"SHA-256"===a?(r===d&&(d=$(l,e,a)),j=g(d,F(c))):n("Chosen SHA variant is not supported");return j};this.getHMAC=function(a,b,c,d,f){var j,h,m,s,p,x=[],y=[],q=r;switch(d){case "HEX":j=D;break;case "B64":j=E;break;default:n("outputFormat must be HEX or B64")}"SHA-224"===c?(m=64,p=224):"SHA-256"===c?(m=64,p=256):n("Chosen SHA variant is not supported");"HEX"===b?(q=w(a),s=q.binLen,h=q.value):"ASCII"===b||"TEXT"===b?(q=t(a,l),s=q.binLen,h=q.value):"B64"===b?(q=A(a),
s=q.binLen,h=q.value):n("inputFormat must be HEX, TEXT, ASCII, or B64");a=8*m;b=m/4-1;m<s/8?(h=$(h,s,c),h[b]&=4294967040):m>s/8&&(h[b]&=4294967040);for(m=0;m<=b;m+=1)x[m]=h[m]^909522486,y[m]=h[m]^1549556828;c=$(y.concat($(x.concat(k),a+e,c)),a+p,c);return j(c,F(f))}};})();
;


/**
 * CSS-JSON Converter for JavaScript
 * Converts CSS to JSON and back.
 * Version 2.1
 *
 * Released under the MIT license.
 * 
 * Copyright (c) 2013 Aram Kocharyan, http://aramk.com/

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions
 of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

var CSSJSON = new function () {

    var base = this;

    base.init = function () {
        // String functions
        String.prototype.trim = function () {
            return this.replace(/^\s+|\s+$/g, '');
        };

        String.prototype.repeat = function (n) {
            return new Array(1 + n).join(this);
        };
    };
    base.init();

    var selX = /([^\s\;\{\}][^\;\{\}]*)\{/g;
    var endX = /\}/g;
    var lineX = /([^\;\{\}]*)\;/g;
    var commentX = /\/\*[\s\S]*?\*\//g;
    var lineAttrX = /([^\:]+):([^\;]*);/;

    // This is used, a concatenation of all above. We use alternation to
    // capture.
    var altX = /(\/\*[\s\S]*?\*\/)|([^\s\;\{\}][^\;\{\}]*(?=\{))|(\})|([^\;\{\}]+\;(?!\s*\*\/))/gmi;

    // Capture groups
    var capComment = 1;
    var capSelector = 2;
    var capEnd = 3;
    var capAttr = 4;

    var isEmpty = function (x) {
        return typeof x == 'undefined' || x.length == 0 || x == null;
    };

    /**
     * Input is css string and current pos, returns JSON object
     *
     * @param cssString
     *            The CSS string.
     * @param args
     *            An optional argument object. ordered: Whether order of
     *            comments and other nodes should be kept in the output. This
     *            will return an object where all the keys are numbers and the
     *            values are objects containing "name" and "value" keys for each
     *            node. comments: Whether to capture comments. split: Whether to
     *            split each comma separated list of selectors.
     */
    base.toJSON = function (cssString, args) {
        var node = {
            children: {},
            attributes: {}
        };
        var match = null;
        var count = 0;

        if (typeof args == 'undefined') {
            var args = {
                ordered: false,
                comments: false,
                stripComments: false,
                split: false
            };
        }
        if (args.stripComments) {
            args.comments = false;
            cssString = cssString.replace(commentX, '');
        }

        while ((match = altX.exec(cssString)) != null) {
            if (!isEmpty(match[capComment]) && args.comments) {
                // Comment
                var add = match[capComment].trim();
                node[count++] = add;
            } else if (!isEmpty(match[capSelector])) {
                // New node, we recurse
                var name = match[capSelector].trim();
                // This will return when we encounter a closing brace
                var newNode = base.toJSON(cssString, args);
                if (args.ordered) {
                    var obj = {};
                    obj['name'] = name;
                    obj['value'] = newNode;
                    // Since we must use key as index to keep order and not
                    // name, this will differentiate between a Rule Node and an
                    // Attribute, since both contain a name and value pair.
                    obj['type'] = 'rule';
                    node[count++] = obj;
                } else {
                    if (args.split) {
                        var bits = name.split(',');
                    } else {
                        var bits = [name];
                    }
                    for (i in bits) {
                        var sel = bits[i].trim();
                        if (sel in node.children) {
                            for (var att in newNode.attributes) {
                                node.children[sel].attributes[att] = newNode.attributes[att];
                            }
                        } else {
                            node.children[sel] = newNode;
                        }
                    }
                }
            } else if (!isEmpty(match[capEnd])) {
                // Node has finished
                return node;
            } else if (!isEmpty(match[capAttr])) {
                var line = match[capAttr].trim();
                var attr = lineAttrX.exec(line);
                if (attr) {
                    // Attribute
                    var name = attr[1].trim();
                    var value = attr[2].trim();
                    if (args.ordered) {
                        var obj = {};
                        obj['name'] = name;
                        obj['value'] = value;
                        obj['type'] = 'attr';
                        node[count++] = obj;
                    } else {
                        if (name in node.attributes) {
                            var currVal = node.attributes[name];
                            if (!(currVal instanceof Array)) {
                                node.attributes[name] = [currVal];
                            }
                            node.attributes[name].push(value);
                        } else {
                            node.attributes[name] = value;
                        }
                    }
                } else {
                    // Semicolon terminated line
                    node[count++] = line;
                }
            }
        }

        return node;
    };

    /**
     * @param node
     *            A JSON node.
     * @param depth
     *            The depth of the current node; used for indentation and
     *            optional.
     * @param breaks
     *            Whether to add line breaks in the output.
     */
    base.toCSS = function (node, depth, breaks) {
        var cssString = '';
        if (typeof depth == 'undefined') {
            depth = 0;
        }
        if (typeof breaks == 'undefined') {
            breaks = false;
        }
        if (node.attributes) {
            for (i in node.attributes) {
                var att = node.attributes[i];
                if (att instanceof Array) {
                    for (var j = 0; j < att.length; j++) {
                        cssString += strAttr(i, att[j], depth);
                    }
                } else {
                    cssString += strAttr(i, att, depth);
                }
            }
        }
        if (node.children) {
            var first = true;
            for (i in node.children) {
                if (breaks && !first) {
                    cssString += '\n';
                } else {
                    first = false;
                }
                cssString += strNode(i, node.children[i], depth);
            }
        }
        return cssString;
    };

    // Helpers

    var strAttr = function (name, value, depth) {
        return '\t'.repeat(depth) + name + ': ' + value + ';\n';
    };

    var strNode = function (name, value, depth) {
        var cssString = '\t'.repeat(depth) + name + ' {\n';
        cssString += base.toCSS(value, depth + 1);
        cssString += '\t'.repeat(depth) + '}\n';
        return cssString;
    };

};
;


// Generated by CoffeeScript 1.6.3
(function() {
  var AddOrRemoveCommand, Box, BoxHelper, BoxesContainer, Canvas, ChangeBoxContentCommand, ChangeBoxNameCommand, ChangeBoxOpacityCommand, ChangeDepthCommand, ChangeStyleCommand, Clipboard, Command, CommandFactory, CommandManager, Constants, ControllerFactory, CopyBoxesCommand, CreateBoxesCommand, EditArea, FontPanel, Geometry, Graphic, Grid, KeyCodes, LoadBoxesCommand, MacController, MainPanel, MoveBoxCommand, PCController, PPEditor, Panel, RemoveBoxesCommand,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Command = (function() {
    function Command() {
      this.boxIds = [];
    }

    Command.prototype.undo = function() {};

    Command.prototype.execute = function() {};

    Command.prototype.getType = function() {};

    Command.prototype.getPageNum = function() {};

    return Command;

  })();

  /*
  Abstract Class, represents an Dom node
  */


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

  /*
  Helper class implementing geometry-related logic.
  */


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

  /*
  Helper Class that provides static constants to keyboard keycodes.
  */


  KeyCodes = (function() {
    function KeyCodes() {}

    KeyCodes.C = 67;

    KeyCodes.V = 86;

    KeyCodes.Z = 90;

    KeyCodes.Y = 89;

    KeyCodes.DELETE = 46;

    KeyCodes.SHIFT = 16;

    KeyCodes.MAC_CMD_LEFT = 91;

    KeyCodes.MAC_CMD_RIGHT = 93;

    KeyCodes.MAC_DELETE = 8;

    return KeyCodes;

  })();

  /*
  Keyboard Mapping Controller for clients running on Windows.
  */


  PCController = (function() {
    function PCController(root) {
      this.root = root;
    }

    PCController.prototype.bindEvents = function() {
      var _this = this;
      return this.root.keydown(function(event) {
        if (event.keyCode === KeyCodes.Z && event.ctrlKey) {
          event.preventDefault();
          _this.root.trigger('requestUndo');
        }
        if (event.keyCode === KeyCodes.Y && event.ctrlKey) {
          event.preventDefault();
          _this.root.trigger('requestRedo');
        }
        if (event.keyCode === KeyCodes.DELETE || (event.keyCode === KeyCodes.DELETE && event.ctrlKey)) {
          event.preventDefault();
          _this.root.trigger('requestDelete');
        }
        if (event.keyCode === KeyCodes.C && event.ctrlKey && event.shiftKey) {
          event.preventDefault();
          _this.root.trigger('requestCopy');
        }
        if (event.keyCode === KeyCodes.V && event.ctrlKey && event.shiftKey) {
          event.preventDefault();
          return _this.root.trigger('requestPaste');
        }
      });
    };

    return PCController;

  })();

  /*
  Keyboard Mapping Controller for clients running on Mac
  */


  MacController = (function() {
    function MacController(root) {
      this.root = root;
      this.leftCmdKeyPressed = false;
      this.rightCmdKeyPressed = false;
    }

    MacController.prototype.bindEvents = function() {
      var _this = this;
      return this.root.keydown(function(event) {
        if (event.keyCode === KeyCodes.MAC_CMD_LEFT) {
          return _this.leftCmdKeyPressed = true;
        } else if (event.keyCode === KeyCodes.Z && _this._cmdKeyIsPressed()) {
          event.preventDefault();
          return _this.root.trigger('requestUndo');
        } else if (event.keyCode === KeyCodes.Y && _this._cmdKeyIsPressed()) {
          event.preventDefault();
          return _this.root.trigger('requestRedo');
        } else if (event.keyCode === KeyCodes.MAC_DELETE && _this._cmdKeyIsPressed()) {
          event.preventDefault();
          return _this.root.trigger('requestDelete');
        } else if (event.keyCode === KeyCodes.C && _this._cmdKeyIsPressed() && event.shiftKey) {
          event.preventDefault();
          return _this.root.trigger('requestCopy');
        } else if (event.keyCode === KeyCodes.V && _this._cmdKeyIsPressed() && event.shiftKey) {
          event.preventDefault();
          return _this.root.trigger('requestPaste');
        }
      }).keyup(function(event) {
        if (event.keyCode === KeyCodes.MAC_CMD_LEFT) {
          _this.leftCmdKeyPressed = false;
        }
        if (event.keyCode === KeyCodes.MAC_CMD_RIGHT) {
          _this.rightCmdKeyPressed = false;
        }
        if (event.keyCode === KeyCodes.SHIFT) {
          return _this.shiftKeyPressed = false;
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

  /*
  This class is used to trigger graphicContentChanged Events
  for a particular box. This event is fired whenever
  the html of the corresponding graphic has changed
  */


  BoxHelper = (function() {
    function BoxHelper(graphic) {
      this.graphic = graphic;
      this.controller = void 0;
      this.content = void 0;
    }

    BoxHelper.prototype.bindEvents = function() {
      var _this = this;
      this.controller = ControllerFactory.getController(this.graphic.element);
      this.graphic.element.on('requestUndo', function(event) {
        _this._checkNewContent(false);
        return event.stopPropagation();
      }).focus(function(event) {
        return _this._checkNewContent(true);
      }).blur(function(event) {
        return _this._checkNewContent(true);
      });
      return this.controller.bindEvents();
    };

    /*
    Checks that the content of the graphic has changed and if it did,
    fire the graphicContentChanged event.
    if saveNewContent is true, the content new content will be saved
    for the next time this function will be called.
    */


    BoxHelper.prototype._checkNewContent = function(saveNewContent) {
      var graphicHtml;
      graphicHtml = this.graphic.element.html();
      if ((this.content != null) && this.content !== graphicHtml) {
        this.graphic.element.trigger('graphicContentChanged', [
          {
            graphic: this.graphic,
            prevContent: this.content,
            newContent: graphicHtml
          }
        ]);
      }
      return this.content = saveNewContent ? graphicHtml : void 0;
    };

    return BoxHelper;

  })();

  Box = (function(_super) {
    __extends(Box, _super);

    Box.CLICK_TIME_MILLIS = 200;

    Box.DBLCLICK_TIME_MILLIS = 200;

    Box.TOOLTIP_DISPEAR_MILLS = 1000;

    function Box(root, options) {
      this.root = root;
      this.options = options;
      Box.__super__.constructor.call(this, this.root);
      this.helper = new BoxHelper(this);
      this.prevPosition = void 0;
      this.prevMouseDownTime = 0;
      this.clickCount = 0;
      this.prevMouseUpTime = 0;
      this.clickTimeoutId = 0;
      this.preventDefaultMouseDown = true;
    }

    Box.prototype.buildElement = function() {
      var boxs, highestZIndex, settings;
      highestZIndex = void 0;
      boxs = this.root.find('.ppedit-box');
      if (boxs.length > 0) {
        highestZIndex = 0;
        boxs.each(function(index, nodeElement) {
          return highestZIndex = Math.max(highestZIndex, parseInt($(nodeElement).css('z-index')));
        });
      }
      settings = $.extend({
        left: '50px',
        top: '50px',
        width: '75px',
        height: '50px',
        color: 'black',
        'font-family': 'Times New Roman',
        'font-size': '12pt',
        'font-weight': 'normal',
        'text-decoration': 'none',
        'font-style': 'normal',
        'line-height': '117%',
        'letter-spacing': '0px',
        'padding': '0px',
        'z-index': highestZIndex != null ? highestZIndex + 1 : 0,
        'text-align': 'left',
        'vertical-align': 'bottom'
      }, this.options);
      return this.element = $('<div></div>').addClass('ppedit-box').attr('contenteditable', true).attr('id', $.now()).css(settings);
    };

    Box.prototype.bindEvents = function() {
      var _this = this;
      this.element.mousedown(function(event) {
        event.stopPropagation();
        if (!_this.element.hasClass('ppedit-box-focus')) {
          event.preventDefault();
        }
        _this.select();
        return _this.prevMouseDownTime = event.timeStamp;
      }).mouseup(function(event) {
        event.preventDefault();
        if (event.timeStamp - _this.prevMouseDownTime < Box.CLICK_TIME_MILLIS) {
          _this.clickCount++;
          if (_this.clickTimeoutId === 0) {
            _this.clickTimeoutId = setTimeout((function() {
              if (_this.clickCount === 1) {
                _this._onClick();
              } else if (_this.clickCount >= 2) {
                _this._onDoubleClick();
              }
              _this.clickTimeoutId = 0;
              return _this.clickCount = 0;
            }), Box.DBLCLICK_TIME_MILLIS);
          }
        }
        return _this.stopMoving();
      }).click(function(event) {
        event.stopPropagation();
        if (!_this.element.hasClass('ppedit-box-focus')) {
          return event.preventDefault();
        }
      }).dblclick(function(event) {
        event.stopPropagation();
        if (!_this.element.hasClass('ppedit-box-focus')) {
          return event.preventDefault();
        }
      }).focus(function(event) {
        return _this.element.trigger('boxSelected', [_this]);
      }).on('containerMouseMove', function(event, mouseMoveEvent, delta) {
        if (event.target === _this.element.get(0)) {
          if (!_this.element.hasClass('ppedit-box-focus')) {
            if (_this.element.hasClass('ppedit-box-selected') && (delta != null)) {
              return _this.move(delta.x, delta.y);
            }
          }
        }
      }).on('containerMouseLeave', function() {
        return _this.stopMoving();
      }).on('containerMouseUp', function(event, mouseMoveEvent) {
        return _this.stopMoving();
      }).on('containerKeyDown', function(event, keyDownEvent) {
        if (_this.element.hasClass('ppedit-box-selected')) {
          return _this._processKeyDownEvent(keyDownEvent);
        }
      }).keydown(function(event) {
        if (!_this.isFocused()) {
          return _this._processKeyDownEvent(event);
        }
      }).mouseenter(function(event) {
        return _this.element.trigger('boxMouseOver', [_this]);
      }).mouseleave(function(event) {});
      return this.helper.bindEvents();
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
        return this.element.trigger('boxMoved', [this, this.currentPosition(), previousPosition]);
      }
    };

    /*
    Deselects the box
    */


    Box.prototype.stopMoving = function() {
      this.element.removeClass('ppedit-box-selected');
      if ((this.prevPosition != null) && !Geometry.pointEqualToPoint(this.currentPosition(), this.prevPosition)) {
        if ($(document).find('.snapImg').hasClass('snapBtn-selected')) {
          this.snap();
        }
        this.root.trigger('boxMoved', [this, $.extend(true, {}, this.currentPosition()), $.extend(true, {}, this.prevPosition)]);
      }
      this.prevPosition = void 0;
      if ($(document).find('.snapImg').hasClass('snapBtn-selected')) {
        this.root.find('.hDotLine').removeClass('ppedit-hDotLine');
        return this.root.find('.vDotLine').removeClass('ppedit-vDotLine');
      }
    };

    /*
    Moves the box by the passed delta amounts.
    */


    Box.prototype.move = function(deltaX, deltaY) {
      var currentPos, dotLinePos;
      currentPos = this.currentPosition();
      this.setPosition(deltaX + currentPos.left, deltaY + currentPos.top);
      dotLinePos = this.getSnapPosition(this.currentPosition());
      if ($(document).find('.snapImg').hasClass('snapBtn-selected')) {
        this.root.find('.hDotLine').addClass('ppedit-hDotLine').css('top', dotLinePos.top);
        return this.root.find('.vDotLine').addClass('ppedit-vDotLine').css('left', dotLinePos.left);
      }
    };

    /*
    Sets the position of the box to the passed coordinates
    */


    Box.prototype.setPosition = function(x, y) {
      this.element.css('left', x + 'px');
      return this.element.css('top', y + 'px');
    };

    /*
    Returns the current position of the box.
    */


    Box.prototype.currentPosition = function() {
      return this.element.position();
    };

    /*
    Sets the position of the box to the nearest snapping
    position.
    */


    Box.prototype.snap = function() {
      var snappedPosition;
      snappedPosition = this.getSnapPosition(this.currentPosition());
      return this.setPosition(snappedPosition.left, snappedPosition.top);
    };

    /*
    Returns the coordinates of the snapping position nearest
    to the box.
    */


    Box.prototype.getSnapPosition = function(p) {
      var snapedLeft, snapedTop;
      snapedLeft = parseInt(p.left / 8) * 8;
      snapedTop = parseInt(p.top / 8) * 8;
      return {
        left: snapedLeft,
        top: snapedTop
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

    /*
    Puts the box on focus.
    */


    Box.prototype._enableFocus = function() {
      this.root.find('.ppedit-box').removeClass('ppedit-box-focus').removeClass('ppedit-box-selected');
      return this.element.addClass('ppedit-box-focus').focus();
    };

    /*
    Adds an unordered point list at the current position
    of the cursor in the box
    */


    Box.prototype.addBulletPoint = function() {
      return this._addHtml($('<ul><li></li></ul>'));
    };

    /*
    Adds an ordered list at the current position
    of the cursor in the box
    */


    Box.prototype.addOrderedPointList = function() {
      return this._addHtml($('<ol><li></li></ol>'));
    };

    Box.prototype._addHtml = function(htmlSelector) {
      var editedElement;
      editedElement = $(window.getSelection().getRangeAt(0).startContainer.parentNode);
      if (editedElement.closest('.ppedit-box').length === 0) {
        editedElement = this.element;
      }
      htmlSelector.find('li').html(editedElement.html());
      return editedElement.empty().append(htmlSelector);
    };

    Box.prototype._getCursorPosition = function() {
      return window.getSelection().getRangeAt(0).startOffset;
    };

    Box.prototype._onClick = function() {};

    Box.prototype._onDoubleClick = function() {
      return this._enableFocus();
    };

    return Box;

  })(Graphic);

  RemoveBoxesCommand = (function(_super) {
    __extends(RemoveBoxesCommand, _super);

    function RemoveBoxesCommand(editor, pageNum, boxesSelector) {
      var box, boxArray;
      this.editor = editor;
      this.pageNum = pageNum;
      RemoveBoxesCommand.__super__.constructor.call(this);
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
      this.boxes = this.editor.areas[this.pageNum].boxesContainer.getBoxesFromIds(this.boxIds);
    }

    RemoveBoxesCommand.prototype.execute = function() {
      var boxId, _i, _len, _ref, _results;
      this.editor.areas[this.pageNum].boxesContainer.removeBoxes(this.boxIds);
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
        this.editor.areas[this.pageNum].boxesContainer.addBox(box);
        _results.push(this.editor.panel.addBoxRow(box.element.attr('id')));
      }
      return _results;
    };

    RemoveBoxesCommand.prototype.getType = function() {
      return 'Remove';
    };

    RemoveBoxesCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return RemoveBoxesCommand;

  })(Command);

  MoveBoxCommand = (function(_super) {
    __extends(MoveBoxCommand, _super);

    function MoveBoxCommand(box, pageNum, toPosition, fromPosition) {
      this.box = box;
      this.pageNum = pageNum;
      this.toPosition = toPosition;
      this.fromPosition = fromPosition;
      MoveBoxCommand.__super__.constructor.call(this);
      this.boxIds.push(this.box.element.attr('id'));
      if (fromPosition == null) {
        this.fromPosition = this.box.currentPosition();
      }
    }

    MoveBoxCommand.prototype.execute = function() {
      return this.box.setPosition(this.toPosition.left, this.toPosition.top);
    };

    MoveBoxCommand.prototype.undo = function() {
      return this.box.setPosition(this.fromPosition.left, this.fromPosition.top);
    };

    MoveBoxCommand.prototype.getType = function() {
      return 'Modify';
    };

    MoveBoxCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return MoveBoxCommand;

  })(Command);

  /*
  This graphic contains a canvas element used for drawing
  figures dynamically on the browser.
  */


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
      return this.element = $('<canvas></canvas>').addClass('ppedit-canvas').attr('width', '920px').attr('height', '1325px');
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
          _this.element.trigger('canvasRectSelect', [
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

    /*
    Draws a rectangle at the passed coordinate
    */


    Canvas.prototype.drawRect = function(topLeft, size) {
      this._context.clearRect(0, 0, this.element.width(), this.element.height());
      this._context.globalAlpha = 0.2;
      this._context.beginPath();
      this._context.rect(topLeft.left, topLeft.top, size.width, size.height);
      this._context.fillStyle = 'blue';
      return this._context.fill();
    };

    /*
    Clears the canvas of any drawn figures.
    */


    Canvas.prototype.clear = function() {
      this._context.clearRect(0, 0, this.element.width(), this.element.height());
      this.downPosition = void 0;
      return this.rectSize = void 0;
    };

    return Canvas;

  })(Graphic);

  /*
  Graphic acting as a container of boxes.
  */


  BoxesContainer = (function(_super) {
    __extends(BoxesContainer, _super);

    BoxesContainer.CLICK_TIME_INTERVAL = 200;

    function BoxesContainer(root) {
      this.root = root;
      BoxesContainer.__super__.constructor.call(this, this.root);
      this.boxes = {};
    }

    BoxesContainer.prototype.buildElement = function() {
      this.element = $('<div></div>').addClass('ppedit-box-container');
      this.element.append('<p class="hDotLine"></p>');
      return this.element.append('<p class="vDotLine"></p>');
    };

    BoxesContainer.prototype.bindEvents = function() {
      var box, id, _ref, _results,
        _this = this;
      this.element.mousedown(function(event) {
        event.preventDefault();
        return _this.unSelectAllBoxes();
      }).dblclick(function(event) {
        var boxCssOptions;
        boxCssOptions = _this.getPointClicked(event);
        if (_this.getSelectedBoxes().length === 0) {
          return _this.element.trigger('addBoxRequested', [boxCssOptions]);
        }
      }).click(function(event) {
        _this.element.trigger('unSelectBoxes');
        return _this.element.parent().trigger('removeToolTip');
      });
      _ref = this.boxes;
      _results = [];
      for (id in _ref) {
        box = _ref[id];
        _results.push(box.bindEvents());
      }
      return _results;
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
        this.boxes[id].element.removeClass('ppedit-box-selected').removeClass('ppedit-box-focus').remove();
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
    Returns an list of box objects corresponding to the
    passed selector matching box elements.
    */


    BoxesContainer.prototype.getBoxesFromSelector = function(selector) {
      var box, results, _i, _len, _ref;
      results = {};
      _ref = selector.toArray();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        box = _ref[_i];
        results[box.id] = this.boxes[box.id];
      }
      return results;
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
      return this.element.find('.ppedit-box:focus, .ppedit-box-selected, .ppedit-box-focus');
    };

    /*
    Returns a selector to the currently selected boxes,
    excluding the focused one, if any.
    */


    BoxesContainer.prototype.getNotFocusedSelectedBoxes = function() {
      return this.element.find('.ppedit-box-selected');
    };

    /*
    Changes the opacity of one box
    
    @param boxid [Int] the id of the box to change
    @param opacityVal [Int] the value of the opacity to change the box to.
    */


    BoxesContainer.prototype.changeBoxOpacity = function(boxid, opacityVal) {
      return this.boxes[boxid].element.css("opacity", opacityVal);
    };

    /*
    Unselects all boxes.
    */


    BoxesContainer.prototype.unSelectAllBoxes = function() {
      var box, id, _ref, _results;
      _ref = this.boxes;
      _results = [];
      for (id in _ref) {
        box = _ref[id];
        box.stopMoving();
        _results.push(box.element.removeClass('ppedit-box-focus').blur());
      }
      return _results;
    };

    /*
    Returns the position relative to the top left corner
    of the element from the passed mouseEvent.
    */


    BoxesContainer._rectContainsRect = function(outerRect, innerRect) {
      return innerRect.topLeft.x >= outerRect.topLeft.x && innerRect.topLeft.y >= outerRect.topLeft.y && innerRect.topLeft.x + innerRect.size.width <= outerRect.topLeft.x + outerRect.size.width && innerRect.topLeft.y + innerRect.size.height <= outerRect.topLeft.y + outerRect.size.height;
    };

    /*
    Returns the mouse coordinates of the passed mouseEvent
    relative to the boxes Container position.
    */


    BoxesContainer.prototype.getPointClicked = function(mouseEvent) {
      return {
        left: event.offsetX + this.element.scrollLeft(),
        top: event.offsetY + this.element.scrollTop()
      };
    };

    /*
    Returns a JSON object containing a description of
    all the boxes currently existing in this container.
    */


    BoxesContainer.prototype.getAllHunks = function() {
      var box, boxId;
      return (function() {
        var _ref, _results;
        _ref = this.boxes;
        _results = [];
        for (boxId in _ref) {
          box = _ref[boxId];
          _results.push({
            id: boxId,
            html: box.element.wrap("<div></div>").parent().html()
          });
        }
        return _results;
      }).call(this);
    };

    return BoxesContainer;

  })(Graphic);

  /*
  Graphic containing the image of a grid to hide/display.
  */


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

    /*
    Hides/show the grid.
    */


    Grid.prototype.toggleGrid = function() {
      return this.element.toggle();
    };

    return Grid;

  })(Graphic);

  /*
  A graphic acting as a container of a boxesContainer, a canvas and a grid.
  */


  EditArea = (function(_super) {
    __extends(EditArea, _super);

    function EditArea(root, pageNum) {
      this.root = root;
      this.pageNum = pageNum;
      EditArea.__super__.constructor.call(this, this.root);
      this.prevMouseMoveEvent = void 0;
      this.canvas = void 0;
      this.grid = void 0;
      this.boxesContainer = void 0;
      this.fontPanel = void 0;
      this.toolTipTimeout = 0;
    }

    EditArea.prototype.buildElement = function() {
      this.element = $('<div class="editContainer shadow-effect"></div>').attr('id', 'ppedit-page-' + this.pageNum).append('<div></div>').addClass("ppedit-container").addClass("col-xs-8").attr('tabindex', 0);
      this.boxesContainer = new BoxesContainer(this.element);
      this.canvas = new Canvas(this.element);
      this.grid = new Grid(this.element);
      this.fontPanel = new FontPanel(this.root);
      this.fontPanel.buildElement();
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
      }).on('boxSelected', function(event, box) {
        _this.fontPanel.setSettingsFromStyle(box.element.get(0).style);
        return _this.showToolTip(box);
      }).on('boxMouseOver', function(event, box) {
        _this.fontPanel.setSettingsFromStyle(box.element.get(0).style);
        return _this.showToolTip(box);
      }).on('removeToolTip', function(event) {
        return _this.removeToolTip();
      }).on('boxMouseLeave', function(event) {
        return _this.toolTipTimeout = setTimeout((function() {
          return _this.removeToolTip();
        }), Box.TOOLTIP_DISPEAR_MILLS);
      });
      this.fontPanel.element.mouseover(function(event) {
        return clearTimeout(_this.toolTipTimeout);
      });
      this.boxesContainer.bindEvents();
      this.canvas.bindEvents();
      this.grid.bindEvents();
      return this.fontPanel.bindEvents();
    };

    EditArea.prototype.setToolTipPosition = function(leftPos, topPos, heightPos, widthPos) {
      var toolTip;
      toolTip = this.fontPanel.element;
      if (this.element.height() - topPos - heightPos < toolTip.height() + 10) {
        if ((this.element.width() - leftPos - widthPos / 2) < toolTip.width() + 10) {
          toolTip.css('left', (leftPos + widthPos / 2 - toolTip.width()) + 'px');
        } else {
          toolTip.css('left', (leftPos + widthPos / 2) + 'px');
        }
        return toolTip.css('top', (topPos - toolTip.height() - 25) + 'px');
      } else {
        if ((this.element.width() - leftPos - widthPos / 2) < toolTip.width() + 10) {
          toolTip.css('left', (leftPos + widthPos / 2 - toolTip.width()) + 'px');
        } else {
          toolTip.css('left', (leftPos + widthPos / 2) + 'px');
        }
        return toolTip.css('top', (topPos + heightPos + 10) + 'px');
      }
    };

    EditArea.prototype.showToolTip = function(box) {
      this.element.append(this.fontPanel.element);
      if ((!FontPanel.LEFT_POSITION) && (!FontPanel.TOP_POSITION)) {
        return this.setToolTipPosition(box.currentPosition().left, box.currentPosition().top, box.element.height(), box.element.width());
      } else {
        this.fontPanel.element.css('left', this.fontPanel.leftPosition + 'px');
        return this.fontPanel.element.css('top', this.fontPanel.topPosition + 'px');
      }
    };

    EditArea.prototype.removeToolTip = function() {
      return this.fontPanel.element.detach();
    };

    return EditArea;

  })(Graphic);

  AddOrRemoveCommand = (function(_super) {
    __extends(AddOrRemoveCommand, _super);

    function AddOrRemoveCommand(editor, addPage, pageNum) {
      this.editor = editor;
      this.addPage = addPage;
      this.pageNum = pageNum;
      AddOrRemoveCommand.__super__.constructor.call(this);
      this.area = void 0;
      this.boxIds = this.editor.areas[this.pageNum] != null ? Object.getOwnPropertyNames(this.editor.areas[pageNum].boxesContainer.boxes) : [];
    }

    AddOrRemoveCommand.prototype.execute = function() {
      if (this.addPage) {
        if (this.pageNum == null) {
          this.pageNum = this.editor.areas.length;
        }
        return this._insertNewPage(this.pageNum);
      } else {
        return this._removePage(this.pageNum);
      }
    };

    AddOrRemoveCommand.prototype.undo = function() {
      if (this.addPage) {
        return this._removePage(this.pageNum);
      } else {
        return this._insertPage(this.pageNum, this.area);
      }
    };

    AddOrRemoveCommand.prototype._insertNewPage = function(pageNum) {
      var newArea;
      newArea = new EditArea(this.editor.element, this.editor.areas.length);
      newArea.buildElement();
      this._insertPage(pageNum, newArea);
      return this.area = newArea;
    };

    AddOrRemoveCommand.prototype._insertPage = function(pageNum, area) {
      var box, i, id, panel, rows, _i, _ref, _ref1, _results,
        _this = this;
      if (pageNum > 0) {
        area.element.insertAfter(this.editor.superContainer.children().eq(pageNum - 1));
      } else {
        this.editor.superContainer.append(area.element);
      }
      area.bindEvents();
      panel = this.editor.panel;
      panel.insertTab(pageNum);
      _ref = area.boxesContainer.boxes;
      for (id in _ref) {
        box = _ref[id];
        rows = panel.getRows(pageNum);
        if (rows.length === 0) {
          panel.addBoxRow(id);
        } else {
          rows.each(function(index, rowNode) {
            var otherBoxId, otherBoxZIndex;
            otherBoxId = $(rowNode).attr('ppedit-box-id');
            otherBoxZIndex = area.boxesContainer.boxes[otherBoxId].element.css('z-index');
            if (parseInt(otherBoxZIndex) < parseInt(box.element.css('z-index')) || index === rows.length - 1) {
              panel.addBoxRow(id, index);
              return false;
            }
          });
        }
      }
      this.editor.areas = this.editor.areas.slice(0, pageNum).concat([area]).concat(this.editor.areas.slice(pageNum));
      _results = [];
      for (i = _i = 0, _ref1 = this.editor.areas.length - 1; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
        _results.push(this.editor.areas[i].element.attr('id', 'ppedit-page-' + i));
      }
      return _results;
    };

    AddOrRemoveCommand.prototype._removePage = function(pageNum) {
      var i, _i, _ref, _results;
      this.area = this.editor.areas.splice(pageNum, 1)[0];
      this.area.element.detach();
      this.editor.panel.removeTab(pageNum);
      _results = [];
      for (i = _i = 0, _ref = this.editor.areas.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.editor.areas[i].element.attr('id', 'ppedit-page-' + i);
        this.editor.areas[i].grid.toggleGrid();
        _results.push(this.editor.areas[i].grid.toggleGrid());
      }
      return _results;
    };

    AddOrRemoveCommand.prototype.getType = function() {
      if (this.addPage) {
        return 'addPage';
      } else {
        return 'removePage';
      }
    };

    AddOrRemoveCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return AddOrRemoveCommand;

  })(Command);

  /*
  A command that populates the editor with the boxes
  information defined in a json string.
  */


  LoadBoxesCommand = (function(_super) {
    __extends(LoadBoxesCommand, _super);

    /*
    Defines a command that, when executed, populates the editor with the boxes
    information defined in the passed json string.
    
    The jsonBoxes parameter must be a json string like the following :
    [
      {
        "box-id-1":'<div class="ppedit-box">box-id-1 contents in page 1</div>',
        "box-id-2":'<div class="ppedit-box">box-id-2 contents in page 1</div>'
      },
      {
        "box-id-3":'<div class="ppedit-box">box-id-3 contents in page 2</div>',
        "box-id-4":'<div class="ppedit-box">box-id-4 contents in page 2</div>'
      }
    ]
    */


    function LoadBoxesCommand(editor, jsonBoxes) {
      this.editor = editor;
      this.jsonBoxes = jsonBoxes;
      LoadBoxesCommand.__super__.constructor.call(this);
    }

    LoadBoxesCommand.prototype.execute = function() {
      var addCmd, area, box, boxElement, i, id, pages, panel, rows, _i, _j, _ref, _ref1, _results;
      pages = this.jsonBoxes;
      if (pages.length > this.editor.areas.length) {
        for (i = _i = 0, _ref = pages.length - this.editor.areas.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          addCmd = new AddOrRemoveCommand(this.editor, true);
          addCmd.execute();
        }
      }
      _results = [];
      for (i = _j = 0, _ref1 = pages.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
        _results.push((function() {
          var _ref2, _results1,
            _this = this;
          _ref2 = pages[i];
          _results1 = [];
          for (id in _ref2) {
            boxElement = _ref2[id];
            area = this.editor.areas[i];
            panel = this.editor.panel;
            box = new Box(area.boxesContainer.element);
            box.element = $(boxElement.html);
            area.boxesContainer.addBox(box);
            rows = panel.getRows(i);
            if (rows.length === 0) {
              panel.addBoxRow(i, id);
            } else {
              rows.each(function(index, rowNode) {
                var otherBoxId, otherBoxZIndex;
                otherBoxId = $(rowNode).attr('ppedit-box-id');
                otherBoxZIndex = area.boxesContainer.boxes[otherBoxId].element.css('z-index');
                if (parseInt(otherBoxZIndex) < parseInt(box.element.css('z-index')) || index === rows.length - 1) {
                  panel.addBoxRow(i, id, index);
                  return false;
                }
              });
            }
            _results1.push(panel.setBoxName(id, boxElement.name));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    LoadBoxesCommand.prototype.undo = function() {};

    LoadBoxesCommand.prototype.getType = function() {
      return 'Create';
    };

    LoadBoxesCommand.prototype.getPageNum = function() {};

    return LoadBoxesCommand;

  })(Command);

  /*
  A command that creates one or more boxes with the passed options
  ands adds it to the list.
  */


  CreateBoxesCommand = (function(_super) {
    __extends(CreateBoxesCommand, _super);

    /*
    Creates a command that, when executed, will create
    one or more boxes with a passed array of options, one
    for each box to create and add it to the list of current boxes.
    If no optionsList is passed, only one box is created with the default options.
    */


    function CreateBoxesCommand(editor, pageNum, optionsList) {
      this.editor = editor;
      this.pageNum = pageNum;
      this.optionsList = optionsList;
      CreateBoxesCommand.__super__.constructor.call(this);
      this.boxes = [];
    }

    CreateBoxesCommand.prototype.execute = function() {
      var box, options, _i, _j, _len, _len1, _ref, _ref1, _results;
      if (this.optionsList != null) {
        if (this.boxes.length === 0) {
          _ref = this.optionsList;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            options = _ref[_i];
            this.boxes.push(new Box(this.editor.areas[this.pageNum].boxesContainer.element, options));
          }
        }
        _ref1 = this.boxes;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          box = _ref1[_j];
          _results.push(this._addBox(box));
        }
        return _results;
      } else {
        if (this.boxes.length === 0) {
          this.boxes.push(new Box(this.editor.areas[this.pageNum].boxesContainer.element));
        }
        return this._addBox(this.boxes[0]);
      }
    };

    CreateBoxesCommand.prototype.undo = function() {
      var box, _i, _len, _ref, _results;
      _ref = this.boxes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        box = _ref[_i];
        this.editor.areas[this.pageNum].boxesContainer.removeBoxes([box.element.attr('id')]);
        _results.push(this.editor.panel.removeBoxRow([box.element.attr('id')]));
      }
      return _results;
    };

    /*
    Adds the passed box to the boxcontainer and
    create a corresponding row in the panel
    */


    CreateBoxesCommand.prototype._addBox = function(box) {
      var boxId;
      this.editor.areas[this.pageNum].boxesContainer.addBox(box);
      boxId = box.element.attr('id');
      this.editor.panel.addBoxRow(this.pageNum, boxId);
      if (this.boxIds.indexOf(boxId) === -1) {
        return this.boxIds.push(boxId);
      }
    };

    CreateBoxesCommand.prototype.getType = function() {
      return 'Create';
    };

    CreateBoxesCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return CreateBoxesCommand;

  })(Command);

  CopyBoxesCommand = (function(_super) {
    __extends(CopyBoxesCommand, _super);

    function CopyBoxesCommand(editor, pageNum, boxesClones) {
      this.editor = editor;
      this.pageNum = pageNum;
      this.boxesClones = boxesClones;
      CopyBoxesCommand.__super__.constructor.call(this);
      this.newBoxes = [];
    }

    CopyBoxesCommand.prototype.execute = function() {
      var box, i, _i, _ref, _results,
        _this = this;
      if (this.newBoxes.length === 0) {
        this.boxesClones.each(function(index, boxItem) {
          var box, boxOptions;
          boxOptions = CSSJSON.toJSON(boxItem.style.cssText).attributes;
          box = new Box(_this.editor.areas[_this.pageNum].boxesContainer.element, boxOptions);
          return _this.newBoxes[index] = box;
        });
      }
      _results = [];
      for (i = _i = 0, _ref = this.newBoxes.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        box = this.newBoxes[i];
        this.editor.areas[this.pageNum].boxesContainer.addBox(box);
        box.element.html(this.boxesClones.eq(i).html());
        this.editor.panel.addBoxRow(this.pageNum, box.element.attr('id'));
        _results.push(this.boxIds[i] = box.element.attr('id'));
      }
      return _results;
    };

    CopyBoxesCommand.prototype.undo = function() {
      var box, _i, _len, _ref, _results;
      _ref = this.newBoxes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        box = _ref[_i];
        this.editor.areas[this.pageNum].boxesContainer.removeBoxes([box.element.attr('id')]);
        _results.push(this.editor.panel.removeBoxRow([box.element.attr('id')]));
      }
      return _results;
    };

    CopyBoxesCommand.prototype.getType = function() {
      return 'Create';
    };

    CopyBoxesCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return CopyBoxesCommand;

  })(Command);

  Constants = (function() {
    function Constants() {}

    Constants.INIT_NUM_OF_PAGES = 2;

    Constants.MAX_NUM_OF_PAGES = 3;

    Constants.HUNK_NAME_MAX_NUM_OF_CHAR = 10;

    return Constants;

  })();

  /*
  Class that manages a set of commands to undo/redo.
  */


  CommandManager = (function() {
    function CommandManager() {
      this.initNumOfPages = Constants.INIT_NUM_OF_PAGES;
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

    /*
    Returns a json string specifying the boxes that have been created, modified and/or removed.
    */


    CommandManager.prototype.getUndoJSON = function() {
      var command, history, hunkId, i, id, key, page, result, shaObj, value, _i, _j, _len, _len1, _ref, _ref1;
      history = {
        modified: (function() {
          var _i, _ref, _results;
          _results = [];
          for (i = _i = 0, _ref = this.initNumOfPages - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
            _results.push({});
          }
          return _results;
        }).call(this),
        removed: (function() {
          var _i, _ref, _results;
          _results = [];
          for (i = _i = 0, _ref = this.initNumOfPages - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
            _results.push({});
          }
          return _results;
        }).call(this),
        created: (function() {
          var _i, _ref, _results;
          _results = [];
          for (i = _i = 0, _ref = this.initNumOfPages - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
            _results.push({});
          }
          return _results;
        }).call(this)
      };
      _ref = this.undoStack;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        command = _ref[_i];
        _ref1 = command.boxIds;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          id = _ref1[_j];
          switch (command.getType()) {
            case 'Create':
              history.created[command.getPageNum()]['' + id] = {
                id: id,
                html: $('#' + id).clone().wrap('<div></div>').parent().html() || '',
                name: $('tr[ppedit-box-id=' + id + ']').find('input').val()
              };
              break;
            case 'Modify':
              if (history.created[command.getPageNum()]['' + id] == null) {
                history.modified[command.getPageNum()]['' + id] = {
                  id: id,
                  html: $('#' + id).clone().wrap('<div></div>').parent().html() || '',
                  name: $('tr[ppedit-box-id=' + id + ']').find('input').val()
                };
              }
              break;
            case 'Remove':
              delete history.modified[command.getPageNum()]['' + id];
              if (history.created[command.getPageNum()]['' + id] != null) {
                delete history.created[command.getPageNum()]['' + id];
              } else {
                history.removed[command.getPageNum()]['' + id] = {
                  id: id,
                  html: '',
                  name: ''
                };
              }
              break;
            case 'removePage':
              delete history.modified[command.getPageNum()]['' + id];
              if (history.created[command.getPageNum()]['' + id] != null) {
                delete history.created[command.getPageNum()]['' + id];
              } else {
                history.removed[command.getPageNum()]['' + id] = {
                  id: id,
                  html: '',
                  name: ''
                };
              }
          }
        }
        if (command.getType() === 'removePage') {
          if (command.getPageNum() < history.modified.length - 2) {
            history.modified[command.getPageNum()] = $.extend(history.modified[command.getPageNum()], history.modified[command.getPageNum() + 1]);
            history.created[command.getPageNum()] = $.extend(history.created[command.getPageNum()], history.created[command.getPageNum() + 1]);
            history.removed[command.getPageNum()] = $.extend(history.removed[command.getPageNum()], history.removed[command.getPageNum() + 1]);
            history.modified.splice(command.getPageNum() + 1, 1);
            history.created.splice(command.getPageNum() + 1, 1);
            history.removed.splice(command.getPageNum() + 1, 1);
          }
        } else if (command.getType() === 'addPage') {
          history.modified.push({});
          history.created.push({});
          history.removed.push({});
        }
      }
      result = {
        modified: (function() {
          var _k, _len2, _ref2, _results;
          _ref2 = history.modified;
          _results = [];
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            page = _ref2[_k];
            _results.push((function() {
              var _results1;
              _results1 = [];
              for (key in page) {
                value = page[key];
                _results1.push(value);
              }
              return _results1;
            })());
          }
          return _results;
        })(),
        removed: (function() {
          var _k, _len2, _ref2, _results;
          _ref2 = history.removed;
          _results = [];
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            page = _ref2[_k];
            _results.push((function() {
              var _results1;
              _results1 = [];
              for (key in page) {
                value = page[key];
                _results1.push(value);
              }
              return _results1;
            })());
          }
          return _results;
        })(),
        created: (function() {
          var _k, _len2, _ref2, _results;
          _ref2 = history.created;
          _results = [];
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            page = _ref2[_k];
            _results.push((function() {
              var _results1;
              _results1 = [];
              for (key in page) {
                value = page[key];
                _results1.push(value);
              }
              return _results1;
            })());
          }
          return _results;
        })()
      };
      shaObj = new jsSHA(JSON.stringify(history), "TEXT");
      hunkId = shaObj.getHMAC("", "TEXT", "SHA-256", "HEX");
      result.etag = hunkId;
      return JSON.stringify(result);
    };

    /*
    Deletes the history of commands issued since the editor has been loaded.
    */


    CommandManager.prototype.clearHistory = function() {
      return this.undoStack.splice(0, this.undoStack.length);
    };

    return CommandManager;

  })();

  ChangeStyleCommand = (function(_super) {
    __extends(ChangeStyleCommand, _super);

    function ChangeStyleCommand(editor, boxesSelector, newCssOptions) {
      this.editor = editor;
      this.boxesSelector = boxesSelector;
      this.newCssOptions = newCssOptions;
      ChangeStyleCommand.__super__.constructor.call(this);
      this.pageNum = this.editor.getPageNum(this.boxesSelector.first());
      this.boxesToCopy = this.boxesSelector.clone();
    }

    ChangeStyleCommand.prototype.execute = function() {
      var _this = this;
      return this.boxesSelector.each(function(index, item) {
        return $(item).css(_this.newCssOptions);
      });
    };

    ChangeStyleCommand.prototype.undo = function() {
      var _this = this;
      return this.boxesToCopy.each(function(index, item) {
        var prevCssOptions;
        prevCssOptions = CSSJSON.toJSON(_this.boxesToCopy.filter('#' + item.id).attr('style')).attributes;
        return _this.boxesSelector.filter('#' + item.id).css(prevCssOptions);
      });
    };

    ChangeStyleCommand.prototype.getType = function() {
      return 'Modify';
    };

    ChangeStyleCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return ChangeStyleCommand;

  })(Command);

  ChangeDepthCommand = (function(_super) {
    __extends(ChangeDepthCommand, _super);

    /*
    Specify one Command for changing the depth of a box,
    where @boxSelector refers to the box to move, and 
    @moveUp is the parameter that specify the box to move up
    if true, or down if false.
    */


    function ChangeDepthCommand(editor, pageNum, boxSelector, moveUp) {
      this.editor = editor;
      this.pageNum = pageNum;
      this.moveUp = moveUp;
      ChangeDepthCommand.__super__.constructor.call(this);
      this.boxId = boxSelector.attr('id');
    }

    ChangeDepthCommand.prototype.execute = function() {
      if (this.moveUp) {
        return this.swapRowWithUpperRow();
      } else {
        return this.swapRowWithLowerRow();
      }
    };

    ChangeDepthCommand.prototype.undo = function() {
      if (this.moveUp) {
        return this.swapRowWithLowerRow();
      } else {
        return this.swapRowWithUpperRow();
      }
    };

    ChangeDepthCommand.prototype.swapRowWithUpperRow = function() {
      var index, row, upperRow;
      row = this.editor.panel.getRowWithBoxId(this.boxId);
      index = row.index();
      if (index - 1 >= 0) {
        upperRow = this.editor.panel.getRowAtIndex(this.pageNum, index - 1);
        return this.swapRows(row, upperRow);
      }
    };

    ChangeDepthCommand.prototype.swapRowWithLowerRow = function() {
      var index, lowerRow, row;
      row = this.editor.panel.getRowWithBoxId(this.boxId);
      index = row.index();
      if (index + 1 < this.editor.panel.getRows(this.pageNum).length) {
        lowerRow = this.editor.panel.getRowAtIndex(this.pageNum, index + 1);
        return this.swapRows(row, lowerRow);
      }
    };

    /*
    Swaps RowOne with RowTwo. Also swaps the z-index of the boxes
    associated with each row.
    */


    ChangeDepthCommand.prototype.swapRows = function(rowOne, rowTwo) {
      var rowOneBox, rowOneBoxTempZindex, rowTwoBox;
      if (rowOne.index() < rowTwo.index()) {
        rowOne.insertAfter(rowTwo);
      } else {
        rowOne.insertBefore(rowTwo);
      }
      rowOneBox = this.editor.areas[this.pageNum].boxesContainer.boxes[rowOne.attr('ppedit-box-id')];
      rowOneBoxTempZindex = rowOneBox.element.css('z-index');
      rowTwoBox = this.editor.areas[this.pageNum].boxesContainer.boxes[rowTwo.attr('ppedit-box-id')];
      rowOneBox.element.css('z-index', rowTwoBox.element.css('z-index'));
      return rowTwoBox.element.css('z-index', rowOneBoxTempZindex);
    };

    ChangeDepthCommand.prototype.getType = function() {
      return 'Modify';
    };

    ChangeDepthCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return ChangeDepthCommand;

  })(Command);

  ChangeBoxContentCommand = (function(_super) {
    __extends(ChangeBoxContentCommand, _super);

    function ChangeBoxContentCommand(box, pageNum, prevContent, newContent) {
      this.box = box;
      this.pageNum = pageNum;
      this.prevContent = prevContent;
      this.newContent = newContent;
      ChangeBoxContentCommand.__super__.constructor.call(this);
      this.boxIds.push(this.box.element.attr('id'));
    }

    ChangeBoxContentCommand.prototype.execute = function() {
      return this.box.element.html(this.newContent);
    };

    ChangeBoxContentCommand.prototype.undo = function() {
      return this.box.element.html(this.prevContent);
    };

    ChangeBoxContentCommand.prototype.getType = function() {
      return 'Modify';
    };

    ChangeBoxContentCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return ChangeBoxContentCommand;

  })(Command);

  ChangeBoxOpacityCommand = (function(_super) {
    __extends(ChangeBoxOpacityCommand, _super);

    function ChangeBoxOpacityCommand(editor, pageNum, boxId, prevVal, newVal) {
      this.editor = editor;
      this.pageNum = pageNum;
      this.boxId = boxId;
      this.prevVal = prevVal;
      this.newVal = newVal;
      ChangeBoxOpacityCommand.__super__.constructor.call(this);
    }

    ChangeBoxOpacityCommand.prototype.execute = function() {
      return this.changeOpacityToVal(this.newVal);
    };

    ChangeBoxOpacityCommand.prototype.undo = function() {
      return this.changeOpacityToVal(this.prevVal);
    };

    ChangeBoxOpacityCommand.prototype.changeOpacityToVal = function(value) {
      this.editor.areas[this.pageNum].boxesContainer.changeBoxOpacity(this.boxId, value);
      return this.editor.panel.element.find("tr[ppedit-box-id=" + this.boxId + "]").find('.ppedit-slider').slider('setValue', parseInt(value * 100));
    };

    ChangeBoxOpacityCommand.prototype.getType = function() {
      return 'Modify';
    };

    ChangeBoxOpacityCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return ChangeBoxOpacityCommand;

  })(Command);

  ChangeBoxNameCommand = (function(_super) {
    __extends(ChangeBoxNameCommand, _super);

    function ChangeBoxNameCommand(editor, boxId, pageNum, prevName, newName) {
      this.editor = editor;
      this.pageNum = pageNum;
      this.prevName = prevName;
      this.newName = newName;
      ChangeBoxNameCommand.__super__.constructor.call(this);
      this.boxIds.push(boxId);
    }

    ChangeBoxNameCommand.prototype.execute = function() {
      return this.editor.panel.setBoxName(this.boxIds[0], this.newName.substr(0, Constants.HUNK_NAME_MAX_NUM_OF_CHAR));
    };

    ChangeBoxNameCommand.prototype.undo = function() {
      return this.editor.panel.setBoxName(this.boxIds[0], this.prevName.substr(0, Constants.HUNK_NAME_MAX_NUM_OF_CHAR));
    };

    ChangeBoxNameCommand.prototype.getType = function() {
      return 'Modify';
    };

    ChangeBoxNameCommand.prototype.getPageNum = function() {
      return this.pageNum;
    };

    return ChangeBoxNameCommand;

  })(Command);

  /*
  This class is responsible for creating and providing commands on the fly.
  */


  CommandFactory = (function() {
    function CommandFactory() {}

    CommandFactory.prototype.createChangeFontSizeCommand = function(editor, boxesSelector, newFontSize) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'font-size': newFontSize
      });
    };

    CommandFactory.prototype.createChangeFontTypeCommand = function(editor, boxesSelector, newFontType) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'font-family': newFontType
      });
    };

    CommandFactory.prototype.createChangeLetterSpaceCommand = function(editor, boxesSelector, newletterSpace) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'letter-spacing': newletterSpace
      });
    };

    CommandFactory.prototype.createChangeLineHeightCommand = function(editor, boxesSelector, newLineHeight) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'line-height': newLineHeight
      });
    };

    CommandFactory.prototype.createChangePaddingCommand = function(editor, boxesSelector, newPadding) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'padding': newPadding
      });
    };

    CommandFactory.prototype.createChangeFontWeightCommand = function(editor, boxesSelector, enable) {
      var fontWeightValue;
      fontWeightValue = enable ? 'bold' : 'normal';
      return new ChangeStyleCommand(editor, boxesSelector, {
        'font-weight': fontWeightValue
      });
    };

    CommandFactory.prototype.createChangeItalicFontCommand = function(editor, boxesSelector, enable) {
      var styleValue;
      styleValue = enable ? 'italic' : 'normal';
      return new ChangeStyleCommand(editor, boxesSelector, {
        'font-style': styleValue
      });
    };

    CommandFactory.prototype.createChangeUnderlineFontCommand = function(editor, boxesSelector, enable) {
      var styleValue;
      styleValue = enable ? 'underline' : 'none';
      return new ChangeStyleCommand(editor, boxesSelector, {
        'text-decoration': styleValue
      });
    };

    CommandFactory.prototype.createRightAlignmentCommand = function(editor, boxesSelector) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'text-align': 'right'
      });
    };

    CommandFactory.prototype.createLeftAlignmentCommand = function(editor, boxesSelector) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'text-align': 'left'
      });
    };

    CommandFactory.prototype.createCenterAlignmentCommand = function(editor, boxesSelector) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'text-align': 'center'
      });
    };

    CommandFactory.prototype.createChangeTextColorCommand = function(editor, boxesSelector, newColor) {
      return new ChangeStyleCommand(editor, boxesSelector, {
        'color': '#' + newColor
      });
    };

    CommandFactory.prototype.createChangeOpacityCommand = function(editor, editPage, boxId, prevVal, newVal) {
      return new ChangeBoxOpacityCommand(editor, editPage, boxId, prevVal, newVal);
    };

    CommandFactory.prototype.createMoveBoxCommand = function(box, pageNum, toPosition, fromPosition) {
      return new MoveBoxCommand(box, pageNum, toPosition, fromPosition);
    };

    CommandFactory.prototype.createRemoveBoxesCommand = function(editor, pageNum, boxesSelector) {
      return new RemoveBoxesCommand(editor, pageNum, boxesSelector);
    };

    CommandFactory.prototype.createCopyBoxesCommand = function(editor, editPage, boxesClones) {
      return new CopyBoxesCommand(editor, editPage, boxesClones);
    };

    CommandFactory.prototype.createCreateBoxesCommand = function(editor, editContainer, optionsList) {
      return new CreateBoxesCommand(editor, editContainer, optionsList);
    };

    CommandFactory.prototype.createCreateChangeBoxContentCommand = function(box, pageNum, prevContent, newContent) {
      return new ChangeBoxContentCommand(box, pageNum, prevContent, newContent);
    };

    CommandFactory.prototype.createMoveUpCommand = function(editor, pageNum, boxSelector) {
      return new ChangeDepthCommand(editor, pageNum, boxSelector, true);
    };

    CommandFactory.prototype.createMoveDownCommand = function(editor, pageNum, boxSelector) {
      return new ChangeDepthCommand(editor, pageNum, boxSelector, false);
    };

    CommandFactory.prototype.createLoadBoxesCommand = function(editor, jsonBoxes) {
      return new LoadBoxesCommand(editor, jsonBoxes);
    };

    CommandFactory.prototype.createAddPageCommand = function(editor) {
      return new AddOrRemoveCommand(editor, true);
    };

    CommandFactory.prototype.createRemovePageCommand = function(editor, pageNum) {
      return new AddOrRemoveCommand(editor, false, pageNum);
    };

    CommandFactory.prototype.createChangeBoxNameCommand = function(editor, boxId, pageNum, prevName, newName) {
      return new ChangeBoxNameCommand(editor, boxId, pageNum, prevName, newName);
    };

    return CommandFactory;

  })();

  /*
  Graphic containing the settings to apply to boxes.
  */


  Panel = (function(_super) {
    __extends(Panel, _super);

    function Panel(root) {
      this.root = root;
      this.prevOpacityVal = void 0;
      this.prevBoxNameVal = {};
      Panel.__super__.constructor.call(this, this.root);
    }

    Panel.prototype.buildElement = function() {
      return this.element = $('\
      <div class="menu-sidebar">\
          <!-- Sidebar Right -->\
        <div class="menu-tab-sidebar">\
            <div class="minimize-sidebar-btn shadow-effect">\
                <span class="minimize-text">&lt;&lt;</span>\
            </div>\
            <div class="menu-tab-pages">\
            </div>\
\
            <div class="add-tab-sidebar-btn shadow-effect">\
                <span class="add-text">+</span>\
            </div>\
        </div>\
\
         <div class="right-sidebar-container shadow-effect">\
\
            <!-- Row 1 Menu  -->\
            <div class="right-sidebar-menu1">\
              <div class="moveElementUpBtn menu-panel-icon"></div>\
              <div class="moveElementDownBtn menu-panel-icon"></div>\
              <div class="addElementBtn menu-panel-icon"></div>\
              <div class="ppedit-pageNumLabel"></div>\
              <div class="ppedit-deletePage menu-panel-icon"></div>\
             </div>\
\
          </div>\
      </div>');
    };

    Panel.prototype.bindEvents = function() {
      var _this = this;
      this.element.find(".addElementBtn").click(function() {
        return _this.element.trigger('panelClickAddBtnClick', [_this._getDisplayedTabIndex()]);
      });
      this.element.find('.moveElementUpBtn').click(function() {
        return _this.element.trigger('moveElementUpBtnClick', [_this._getDisplayedTabIndex()]);
      });
      this.element.find('.moveElementDownBtn').click(function() {
        return _this.element.trigger('moveElementDownBtnClick', [_this._getDisplayedTabIndex()]);
      });
      this.element.find('.add-tab-sidebar-btn').click(function() {
        return _this.element.trigger('addTabBtnClick');
      });
      return this.element.find('.minimize-sidebar-btn').click(function(event) {
        return _this.element.toggleClass('menu-sidebar-open');
      });
    };

    Panel.prototype.addNewTab = function() {
      return this.insertTab(this.element.find('.page-sidebar-tab').length);
    };

    Panel.prototype.insertTab = function(tabIndex) {
      var newPageIndex, rowContainer, tab,
        _this = this;
      newPageIndex = Math.max(tabIndex, this.element.find('.page-sidebar-tab').length);
      tab = $('\
           <a href="#ppedit-page-' + newPageIndex + '">\
                  <div class="page-sidebar-tab menu-right-btn shadow-effect">\
                    <span class="vertical-text">Page ' + (newPageIndex + 1) + '</span>\
                  </div>\
           </a>\
    ');
      if (newPageIndex === 0) {
        this.element.find('.menu-tab-pages').append(tab);
      } else {
        tab.insertAfter(this.element.find('.menu-tab-pages a').eq(newPageIndex - 1));
      }
      tab.click(function(event) {
        return _this._displayTab(newPageIndex);
      }).nextAll('a').each(function(index, el) {
        return $(el).attr('href', '#ppedit-page-' + (newPageIndex + index + 1)).html('\
            <div class="page-sidebar-tab menu-right-btn shadow-effect">\
              <span class="vertical-text">Page ' + (newPageIndex + index + 2) + '</span>\
            </div>\
          ').click(function() {
          return _this._displayTab(newPageIndex + index + 1);
        });
      });
      rowContainer = $('\
      <!-- Row 2 Menu -->\
      <div class="ppedit-row-container">\
        <table class="right-sidebar-menu2" cellspacing="0px" cellpadding="2px">\
        </table>\
      </div>\
    ');
      if (newPageIndex === 0) {
        this.element.find('.right-sidebar-container').append(rowContainer);
      } else {
        rowContainer.insertAfter(this.element.find('.ppedit-row-container').eq(newPageIndex - 1));
      }
      return this._displayTab(newPageIndex);
    };

    /*
    Adds a row to be associated with the passed box id.
    */


    Panel.prototype.addBoxRow = function(tabIndex, boxid, index) {
      var newRow,
        _this = this;
      newRow = $('\
        <tr class="ppedit-panel-row">\
          <td style="width:10%">\
            <div class="deleteElementBtn menu-panel-icon"></div>\
          </td>\
          <td style="width:50%">\
          <input type="text" class="form-control" placeholder="Untitled box">\
          </td>\
          <td style="width:40%">\
            <div class="ppedit-slider"></div>\
          </td>\
        </tr>\
    	      ').attr('ppedit-box-id', boxid);
      if ((index == null) || index === 0) {
        this._getRowContainer(tabIndex).find('.right-sidebar-menu2').prepend(newRow);
      } else {
        newRow.insertBefore(this._getRowContainer(tabIndex).find('.ppedit-panel-row:nth-child("' + index + '")'));
      }
      newRow.find(".ppedit-slider").slider({
        min: 0,
        max: 100,
        step: 1,
        value: 100
      }).on('slideStart', function(event) {
        return _this.prevOpacityVal = $(event.target).val() || 100;
      }).on('slide', function(event) {
        var opacityVal;
        opacityVal = $(event.target).val();
        index = newRow.parents('.ppedit-row-container').index() - 1;
        return $(event.target).trigger('onRowSliderValChanged', [index, boxid, parseInt(opacityVal) / 100]);
      }).on('slideStop', function(event) {
        var opacityStopVal;
        opacityStopVal = $(event.target).val();
        index = newRow.parents('.ppedit-row-container').index() - 1;
        if (_this.prevOpacityVal !== opacityStopVal) {
          $(event.target).trigger('onRowSliderStopValChanged', [index, boxid, parseInt(_this.prevOpacityVal) / 100, parseInt(opacityStopVal) / 100]);
        }
        return _this.prevOpacityVal = void 0;
      });
      newRow.find(".deleteElementBtn").on('click', function(event) {
        index = newRow.parents('.ppedit-row-container').index() - 1;
        return $(event.target).trigger('onRowDeleteBtnClick', [index, boxid]);
      });
      return newRow.find("input").blur(function(event) {
        var newVal;
        newVal = $(event.target).val();
        if (newVal !== _this.prevBoxNameVal[boxid]) {
          index = newRow.parents('.ppedit-row-container').index() - 1;
          $(event.target).trigger('boxNameChanged', [boxid, index, _this.prevBoxNameVal[boxid] || '', newVal]);
          return _this.prevBoxNameVal[boxid] = newVal;
        }
      });
    };

    /*
    Removes the row associated with the passed box id.
    */


    Panel.prototype.removeBoxRow = function(boxId) {
      return this.getRowWithBoxId(boxId).remove();
    };

    /*
    Returns a selector matching the row associated with
    the passed box Id.
    */


    Panel.prototype.getRowWithBoxId = function(boxId) {
      return this.element.find("tr[ppedit-box-id=" + boxId + "]").eq(0);
    };

    /*
    Returns a selector matching the row at the specified index.
    */


    Panel.prototype.getRowAtIndex = function(tabIndex, index) {
      return this._getRowContainer(tabIndex).find(".ppedit-panel-row").eq(index);
    };

    /*
    Returns a selector matching with all rows.
    */


    Panel.prototype.getRows = function(tabIndex) {
      return this._getRowContainer(tabIndex).find(".ppedit-panel-row");
    };

    Panel.prototype.setBoxName = function(boxId, newBoxName) {
      return this.getRowWithBoxId(boxId).find('input').val(newBoxName);
    };

    Panel.prototype._displayTab = function(tabIndex) {
      var _this = this;
      this.element.find('.ppedit-row-container').removeClass('ppedit-row-container-active').eq(tabIndex).addClass('ppedit-row-container-active');
      this.element.find('.ppedit-pageNumLabel').html('Page ' + (tabIndex + 1));
      return this.element.find('.ppedit-deletePage').off().click(function() {
        return _this.element.trigger('deleteTabBtnClick', [tabIndex]);
      });
    };

    Panel.prototype.removeTab = function(tabIndex) {
      var _this = this;
      this._getRowContainer(tabIndex).remove();
      this.element.find('.menu-tab-pages a').eq(tabIndex).remove();
      this.element.find('.menu-tab-pages a').each(function(index, el) {
        return $(el).attr('href', '#ppedit-page-' + index).html('\
          <div class="page-sidebar-tab menu-right-btn shadow-effect">\
            <span class="vertical-text">Page ' + (index + 1) + '</span>\
          </div>\
        ').click(function() {
          return _this._displayTab(index);
        });
      });
      return this._displayTab(tabIndex);
    };

    Panel.prototype.getBoxName = function(boxId) {
      return this.getRowWithBoxId(boxId).find('input').val();
    };

    Panel.prototype._getRowContainer = function(tabIndex) {
      return this.element.find('.ppedit-row-container').eq(tabIndex);
    };

    Panel.prototype._getDisplayedRowContainer = function() {
      return this.element.find('.ppedit-row-container-active').eq(0);
    };

    Panel.prototype._getDisplayedTabIndex = function() {
      return this._getDisplayedRowContainer().index() - 1;
    };

    return Panel;

  })(Graphic);

  /*
  Helper class used to temporarily save DOM nodes.
  */


  Clipboard = (function() {
    function Clipboard() {
      this.items = void 0;
    }

    /*
    Saves the passed newItems jQuery selector
    */


    Clipboard.prototype.pushItems = function(newItems) {
      return this.items = $.extend(true, {}, newItems);
    };

    /*
    Returns the saved jQuery selector and removes it from the save.
    */


    Clipboard.prototype.popItems = function() {
      var results;
      results = this.items;
      this.items = void 0;
      if (results != null) {
        return results;
      } else {
        return [];
      }
    };

    return Clipboard;

  })();

  /*
  Graphic acting a the main container of the PPEditor.
  */


  PPEditor = (function(_super) {
    __extends(PPEditor, _super);

    function PPEditor(root) {
      this.root = root;
      PPEditor.__super__.constructor.call(this, this.root);
      this.clipboard = new Clipboard;
      this.commandManager = new CommandManager;
      this.cmdFactory = new CommandFactory;
      this.controller = void 0;
      this.panel = void 0;
    }

    PPEditor.prototype.buildElement = function() {
      this.element = $('\
      <div class="container" tabindex="0">\
      </div>\
    ');
      this.controller = ControllerFactory.getController(this.element);
      this.superContainer = $('\
      <div class="superContainer">\
      </div>\
    ');
      this.areas = [];
      this.panel = new Panel(this.element);
      this.mainPanel = new MainPanel(this.element);
      this.panel.buildElement();
      this.mainPanel.buildElement();
      this.element.append(this.mainPanel.element);
      this.element.append(this.panel.element);
      return this.element.append(this.superContainer);
    };

    PPEditor.prototype.bindEvents = function() {
      var cmd, i, _i, _ref, _results,
        _this = this;
      this.element.on('focus', function(event) {
        return _this.element.blur();
      }).on('requestUndo', function(event) {
        return _this.commandManager.undo();
      }).on('requestRedo', function(event) {
        return _this.commandManager.redo();
      }).on('requestDelete', function(event) {
        var i, _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = Constants.INIT_NUM_OF_PAGES - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          if (_this.areas[i].boxesContainer.getSelectedBoxes().length !== 0) {
            _results.push(_this.commandManager.pushCommand(_this.cmdFactory.createRemoveBoxesCommand(_this, i, _this.areas[0].boxesContainer.getSelectedBoxes())));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }).on('requestCopy', function(event) {
        var i, _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = Constants.INIT_NUM_OF_PAGES - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          if (_this.areas[i].boxesContainer.getSelectedBoxes().length !== 0) {
            _this.clipboard.pushItems({
              pageNum: i,
              boxes: _this.areas[i].boxesContainer.getSelectedBoxes()
            });
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }).on('requestPaste', function(event) {
        var items;
        items = _this.clipboard.popItems();
        if ((items.boxes != null) && items.boxes.length > 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createCopyBoxesCommand(_this, items.pageNum, items.boxes));
        }
      }).on('textColorChanged', function(event, hex) {
        var boxSelected;
        boxSelected = _this.getSelectedBoxes();
        if (boxSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeTextColorCommand(_this, boxSelected, hex));
        }
      }).on('graphicContentChanged', function(event, params) {
        var boxName, clone, newName, pageNum;
        pageNum = _this.getPageNum(params.graphic.element);
        _this.commandManager.pushCommand(_this.cmdFactory.createCreateChangeBoxContentCommand(params.graphic, pageNum, params.prevContent, params.newContent), false);
        boxName = _this.panel.getBoxName(params.graphic.element.attr('id'));
        clone = params.graphic.element.clone();
        clone.children().remove();
        newName = clone.html();
        if (boxName.length === 0 && newName.length > 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeBoxNameCommand(_this, params.graphic.element.attr('id'), pageNum, '', newName));
        }
      }).on('boxMoved', function(event, box, currentPosition, originalPosition) {
        var pageNum;
        pageNum = _this.getPageNum(box.element);
        return _this.commandManager.pushCommand(_this.cmdFactory.createMoveBoxCommand(box, pageNum, currentPosition, originalPosition), false);
      }).on('moveElementUpBtnClick', function(event, tabIndex) {
        var boxes;
        boxes = _this.getSelectedBoxes();
        if (boxes.length > 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createMoveUpCommand(_this, tabIndex, boxes));
        }
      }).on('moveElementDownBtnClick', function(event, tabIndex) {
        var boxes;
        boxes = _this.getSelectedBoxes();
        if (boxes.length > 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createMoveDownCommand(_this, tabIndex, boxes));
        }
      }).on('addTabBtnClick', function(event) {
        if (_this.areas.length < Constants.MAX_NUM_OF_PAGES) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createAddPageCommand(_this));
        }
      }).on('deleteTabBtnClick', function(event, tabIndex) {
        if (_this.areas.length > Constants.INIT_NUM_OF_PAGES) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createRemovePageCommand(_this, tabIndex));
        }
      }).on('panelClickAddBtnClick', function(event, tabIndex) {
        return _this.commandManager.pushCommand(_this.cmdFactory.createCreateBoxesCommand(_this, tabIndex));
      }).on('panelClickGridBtnClick', function(event) {
        var area, _i, _len, _ref, _results;
        _ref = _this.areas;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          area = _ref[_i];
          _results.push(area.grid.toggleGrid());
        }
        return _results;
      }).on('onRowDeleteBtnClick', function(event, tabIndex, boxId) {
        return _this.commandManager.pushCommand(_this.cmdFactory.createRemoveBoxesCommand(_this, tabIndex, _this.root.find('#' + boxId)));
      }).on('onRowSliderValChanged', function(event, tabIndex, boxId, opacityVal) {
        return _this.areas[tabIndex].boxesContainer.changeBoxOpacity(boxId, opacityVal);
      }).on('onRowSliderStopValChanged', function(event, tabIndex, boxId, prevVal, newVal) {
        return _this.commandManager.pushCommand(_this.cmdFactory.createChangeOpacityCommand(_this, tabIndex, boxId, prevVal, newVal));
      }).on('addBoxRequested', function(event, boxCssOptions) {
        var pageNum;
        pageNum = _this.getPageNum($(event.target));
        return _this.commandManager.pushCommand(_this.cmdFactory.createCreateBoxesCommand(_this, pageNum, [boxCssOptions]));
      }).on('fontTypeChanged', function(event, newFontType) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeFontTypeCommand(_this, boxesSelected, newFontType));
        }
      }).on('fontSizeChanged', function(event, newFontSize) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeFontSizeCommand(_this, boxesSelected, newFontSize));
        }
      }).on('letterSpaceChanged', function(event, newletterSpace) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeLetterSpaceCommand(_this, boxesSelected, newletterSpace));
        }
      }).on('lineHeightChanged', function(event, newLineHeight) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeLineHeightCommand(_this, boxesSelected, newLineHeight));
        }
      }).on('paddingChanged', function(event, newPadding) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangePaddingCommand(_this, boxesSelected, newPadding));
        }
      }).on('fontWeightBtnEnableClick', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeFontWeightCommand(_this, boxesSelected, true));
        }
      }).on('fontWeightBtnDisableClick', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeFontWeightCommand(_this, boxesSelected, false));
        }
      }).on('fontUnderlinedBtnEnableClick', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeUnderlineFontCommand(_this, boxesSelected, true));
        }
      }).on('fontUnderlinedBtnDisableClick', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeUnderlineFontCommand(_this, boxesSelected, false));
        }
      }).on('fontItalicBtnEnableClick', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeItalicFontCommand(_this, boxesSelected, true));
        }
      }).on('fontItalicBtnDisableClick', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createChangeItalicFontCommand(_this, boxesSelected, false));
        }
      }).on('rightAlignment', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createRightAlignmentCommand(_this, boxesSelected));
        }
      }).on('leftAlignment', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createLeftAlignmentCommand(_this, boxesSelected));
        }
      }).on('centerAlignment', function(event) {
        var boxesSelected;
        boxesSelected = _this.getSelectedBoxes();
        if (boxesSelected.length !== 0) {
          return _this.commandManager.pushCommand(_this.cmdFactory.createCenterAlignmentCommand(_this, boxesSelected));
        }
      }).on('bulletPointBtnEnableClick', function(event) {
        var box, boxes, boxesSelected, id, pageNum, _results;
        boxesSelected = _this.getSelectedBoxes();
        pageNum = _this.getPageNum(boxesSelected);
        boxes = _this.areas[pageNum].boxesContainer.getBoxesFromSelector(boxesSelected.eq(0));
        _results = [];
        for (id in boxes) {
          box = boxes[id];
          _results.push(box.addBulletPoint());
        }
        return _results;
      }).on('orderedPointBtnEnableClick', function(event) {
        var box, boxes, boxesSelected, id, pageNum, _results;
        boxesSelected = _this.getSelectedBoxes();
        pageNum = _this.getPageNum(boxesSelected);
        boxes = _this.areas[pageNum].boxesContainer.getBoxesFromSelector(boxesSelected.eq(0));
        _results = [];
        for (id in boxes) {
          box = boxes[id];
          _results.push(box.addOrderedPointList());
        }
        return _results;
      }).on('boxNameChanged', function(event, boxid, pageNum, prevVal, newVal) {
        return _this.commandManager.pushCommand(_this.cmdFactory.createChangeBoxNameCommand(_this, boxid, pageNum, prevVal, newVal), false);
      });
      this.panel.bindEvents();
      this.controller.bindEvents();
      this.mainPanel.bindEvents();
      _results = [];
      for (i = _i = 0, _ref = Constants.INIT_NUM_OF_PAGES - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        cmd = this.cmdFactory.createAddPageCommand(this);
        _results.push(cmd.execute());
      }
      return _results;
    };

    /*
    Returns a selector to the currently selected boxes
    */


    PPEditor.prototype.getSelectedBoxes = function() {
      return this.element.find('.ppedit-box:focus, .ppedit-box-selected, .ppedit-box-focus');
    };

    PPEditor.prototype.getPageNum = function(boxSelector) {
      return boxSelector.parents('.editContainer').index();
    };

    /*
    Populates the editor with the boxes
    information defined in the passed json string.
    
    @param [String] jsonBoxes the JSON-formatted string containing
    the boxes information, this parameter look like the following :
    [
      {
        "box-id-1":'<div class="ppedit-box">box-id-1 contents in page 1</div>',
        "box-id-2":'<div class="ppedit-box">box-id-2 contents in page 1</div>'
      },
      {
        "box-id-3":'<div class="ppedit-box">box-id-1 contents in page 2</div>',
        "box-id-4":'<div class="ppedit-box">box-id-2 contents in page 2</div>'
      }
    ]
    */


    PPEditor.prototype.load = function(jsonBoxes) {
      var command;
      command = this.cmdFactory.createLoadBoxesCommand(this, jsonBoxes);
      command.execute();
      return this.commandManager.initNumOfPages = this.areas.length;
    };

    /*
    Returns a JSON string containing a description of
    all the boxes currently existing in the editor.
    */


    PPEditor.prototype.getAllHunks = function() {
      var area;
      return JSON.stringify((function() {
        var _i, _len, _ref, _results;
        _ref = this.areas;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          area = _ref[_i];
          _results.push(this.area.boxesContainer.getAllHunks());
        }
        return _results;
      }).call(this));
    };

    return PPEditor;

  })(Graphic);

  /*
  Graphic containing the font settings to apply to boxes.
  */


  FontPanel = (function(_super) {
    __extends(FontPanel, _super);

    FontPanel.LEFT_POSITION = void 0;

    FontPanel.TOP_POSITION = void 0;

    function FontPanel(root) {
      this.root = root;
      FontPanel.__super__.constructor.call(this, this.root);
    }

    FontPanel.prototype.buildElement = function() {
      return this.element = $('\
          <div class="edit-menu FontPanel shadow-effect">\
            <div class="edit-menu-row1">\
               <select class="fontTypeBtn from-control edit-menu-row1-dd-ff">\
                 <option value="Times New Roman" selected>Times New Roman</option>\
                 <option value="Arial">Arial</option>\
                 <option value="Inconsolata">Inconsolata</option>\
                 <option value="Glyphicons Halflings">Glyphicons Halflings</option>\
               </select>\
               \
               <select class="fontSizeBtn from-control edit-menu-row1-dd-fs">\
                 <option value="6">6</option>\
                 <option value="8">8</option>\
                 <option value="10" selected>10</option>\
                 <option value="11">11</option>\
                 <option value="12">12</option>\
                 <option value="14">14</option>\
                 <option value="16">16</option>\
                 <option value="20">20</option>\
               </select>\
\
               \
\
               <div class="boldButton boldButtonDisable font-panel-icon-row"></div>\
               <div class="italicButton italicButtonDisable font-panel-icon-row"></div>\
               <div class="underlineButton underlineButtonDisable font-panel-icon-row"></div>\
             </div>\
             <div class="edit-menu-row2">\
                <div class="leftAlignBtn leftAlignButtonEnable font-panel-icon-row"></div>\
                <div class="centerAlignBtn centerAlignButtonDisable font-panel-icon-row"></div>\
                <div class="rightAlignBtn rightAlignButtonDisable font-panel-icon-row"></div>\
                <div class="colorPicker colorPickerButton font-panel-icon-row"></div>\
                <div class="orderedPointBtn orderedBulletPointButtonDisable font-panel-icon-row"></div>\
                <div class="bulletPointBtn bulletPointButtonDisable font-panel-icon-row"></div>  \
               \
               <div>\
               <div class="font-panel-icon letter-space-img" ></div>\
               <select class="letter-space from-control edit-menu-row1-dd-fs">\
                 <option value="0" selected>0</option>\
                 <option value="1">1</option>\
                 <option value="2">2</option>\
                 <option value="3">3</option>\
                 <option value="4">4</option>\
                 <option value="5">5</option>\
                 </select>\
               </div>\
\
               <div>\
\
              <div class="font-panel-icon line-space-img" ></div>\
               <select class="line-height from-control edit-menu-row1-dd-fs">\
                 <option value="117" selected>1.0</option>\
                 <option value="175">1.5</option>\
                 <option value="233">2.0</option>\
                 <option value="291">2.5</option>\
                 <option value="349">3.0</option>\
                 <option value="407">3.5</option>\
                 <option value="465">4.0</option>\
               </select>\
               </div>\
\
               <div>\
                <div class="font-panel-icon text-padding-img" ></div>\
                   <!-- <img class="icon-set line-height-img" src="images/icons/text-padding25.png" style="float:left;display:inline;"> -->\
               <select class="padding from-control edit-menu-row1-dd-fs">\
                 <option value="0" selected>0</option>\
                 <option value="5">0.5</option>\
                 <option value="10">1.0</option>\
                 <option value="15">1.5</option>\
                 <option value="20">2.0</option>\
                 <option value="25">2.5</option>\
                 <option value="30">3.0</option>\
                 <option value="35">3.5</option>\
                 <option value="40">4.0</option>\
               </select>\
               </div>\
\
             </div>\
            </div>');
    };

    FontPanel.prototype.bindEvents = function() {
      var _this = this;
      this.element.mousedown(function(event) {
        event.stopPropagation();
        return _this.selectFontPanel();
      }).mouseup(function(event) {
        FontPanel.LEFT_POSITION = _this.currentFontPanelPosition().left;
        FontPanel.TOP_POSITION = _this.currentFontPanelPosition().right;
        return _this.stopMoveFontPanel();
      }).on('containerMouseMove', function(event, containerMouseEvent, delta) {
        if (event.target === _this.element.get(0)) {
          if (_this.element.position().left <= 0) {
            _this.stopMoveFontPanel();
            _this.element.css('left', '1px');
          }
          if (_this.element.position().left >= _this.element.parent().width() - _this.element.width()) {
            _this.stopMoveFontPanel();
            _this.element.css('left', _this.element.parent().width() - _this.element.width() - 1 + 'px');
          }
          if (_this.element.position().top <= 0) {
            _this.stopMoveFontPanel();
            _this.element.css('top', '1px');
          }
          if (_this.element.position().top >= _this.element.parent().height() - _this.element.height()) {
            _this.stopMoveFontPanel();
            _this.element.css('top', _this.element.parent().height() - _this.element.height() - 1 + 'px');
          }
          if (_this.element.hasClass('ppedit-panel-selected') && (delta != null)) {
            return _this.moveFontPanel(delta.x, delta.y);
          }
        }
      }).on('containerMouseLeave', function() {
        return _this.stopMoveFontPanel();
      }).focusin(function(event) {
        if (event.target !== _this.element.get(0)) {
          return _this.stopMoveFontPanel();
        }
      });
      this.element.find("select.fontTypeBtn").change(function(event) {
        var newFontType;
        newFontType = $(event.target).find("option:selected").val();
        return _this.root.trigger('fontTypeChanged', [newFontType]);
      });
      this.element.find("select.letter-space").change(function(event) {
        var newletterSpace;
        newletterSpace = $(event.target).find("option:selected").val() + "px";
        return _this.root.trigger('letterSpaceChanged', [newletterSpace]);
      });
      this.element.find("select.fontSizeBtn").change(function(event) {
        var newFontSize;
        newFontSize = $(event.target).find("option:selected").val() + "pt";
        return _this.root.trigger('fontSizeChanged', [newFontSize]);
      });
      this.element.find("select.line-height").change(function(event) {
        var newLineHeight;
        newLineHeight = $(event.target).find("option:selected").val();
        if (newLineHeight !== 'normal') {
          newLineHeight += "%";
        }
        return _this.root.trigger('lineHeightChanged', [newLineHeight]);
      });
      this.element.find("select.padding").change(function(event) {
        var newPadding;
        newPadding = $(event.target).find("option:selected").val() + 'px';
        return _this.root.trigger('paddingChanged', [newPadding]);
      });
      this.element.find(".colorPicker").click(function(event) {
        return $(event.target).colpick({
          colorScheme: 'dark',
          layout: 'rgbhex',
          color: 'ff8800',
          onSubmit: function(hsb, hex, rgb, el) {
            _this.element.trigger('textColorChanged', [hex]);
            return $(el).colpickHide();
          }
        });
      });
      this.element.find('.boldButton').click(function(event) {
        var btn;
        if ($(event.target).hasClass('boldButtonDisable')) {
          btn = $(event.target).attr('class', 'boldButton boldButtonEnable font-panel-icon-row');
          return btn.trigger(btn.hasClass('boldButtonEnable font-panel-icon-row') ? 'fontWeightBtnEnableClick' : 'fontWeightBtnDisableClick');
        } else {
          btn = $(event.target).attr('class', 'boldButtonDisable font-panel-icon-row');
          return btn.trigger(btn.hasClass('.boldButtonDisable font-panel-icon') ? 'fontWeightBtnEnableClick' : 'fontWeightBtnDisableClick');
        }
      });
      this.element.find('.italicButton').click(function(event) {
        var btn;
        if ($(event.target).hasClass('italicButtonDisable')) {
          btn = $(event.target).attr('class', 'italicButtonEnable font-panel-icon-row');
          return btn.trigger(btn.hasClass('italicButtonEnable font-panel-icon-row') ? 'fontItalicBtnEnableClick' : 'fontItalicBtnDisableClick');
        } else {
          btn = $(event.target).attr('class', 'italicButtonDisable font-panel-icon-row');
          return btn.trigger(btn.hasClass('.italicButtonDisable font-panel-icon') ? 'fontItalicBtnEnableClick' : 'fontItalicBtnDisableClick');
        }
      });
      this.element.find('.underlineButton').click(function(event) {
        var btn;
        if ($(event.target).hasClass('underlineButtonDisable')) {
          btn = $(event.target).attr('class', 'underlineButtonEnable font-panel-icon-row');
          return btn.trigger(btn.hasClass('underlineButtonEnable font-panel-icon-row') ? 'fontUnderlinedBtnEnableClick' : 'fontUnderlinedBtnDisableClick');
        } else {
          btn = $(event.target).attr('class', 'underlineButtonDisable font-panel-icon-row');
          return btn.trigger(btn.hasClass('.underlineButtonDisable font-panel-icon-row') ? 'fontUnderlinedBtnEnableClick' : 'fontUnderlinedBtnDisableClick');
        }
      });
      this.element.find('.centerAlignBtn').click(function(event) {
        var btn;
        if ($(event.target).hasClass('centerAlignButtonDisable')) {
          btn = $(event.target).attr('class', 'centerAlignBtn centerAlignButtonEnable font-panel-icon-row');
          _this.element.find('.leftAlignBtn').attr('class', 'leftAlignBtn leftAlignButtonDisable font-panel-icon-row');
          _this.element.find('.rightAlignBtn').attr('class', 'rightAlignBtn rightAlignButtonDisable font-panel-icon-row');
          return btn.trigger('centerAlignment');
        } else {
          btn = $(event.target).attr('class', 'centerAlignBtn centerAlignButtonDisable font-panel-icon-row');
          _this.element.find('.leftAlignBtn').attr('class', 'leftAlignBtn leftAlignButtonEnable font-panel-icon-row');
          _this.element.find('.rightAlignBtn').attr('class', 'rightAlignBtn rightAlignButtonDisable font-panel-icon-row');
          return $(event.target).trigger('leftAlignment');
        }
      });
      this.element.find('.rightAlignBtn').click(function(event) {
        var btn;
        if ($(event.target).hasClass('rightAlignButtonDisable')) {
          btn = $(event.target).attr('class', 'rightAlignBtn rightAlignButtonEnable font-panel-icon-row');
          _this.element.find('.leftAlignBtn').attr('class', 'leftAlignBtn leftAlignButtonDisable font-panel-icon-row');
          _this.element.find('.centerAlignBtn').attr('class', 'centerAlignBtn centerAlignButtonDisable font-panel-icon-row');
          return btn.trigger('rightAlignment');
        } else {
          btn = $(event.target).attr('class', 'rightAlignBtn rightAlignButtonDisable font-panel-icon-row');
          _this.element.find('.leftAlignBtn').attr('class', 'leftAlignBtn leftAlignButtonEnable font-panel-icon-row');
          _this.element.find('.centerAlignBtn').attr('class', 'centerAlignBtn centerAlignButtonDisable font-panel-icon-row');
          return $(event.target).trigger('leftAlignment');
        }
      });
      this.element.find('.leftAlignBtn').click(function(event) {
        var btn;
        if ($(event.target).hasClass('leftAlignButtonDisable')) {
          btn = $(event.target).attr('class', 'leftAlignBtn leftAlignButtonEnable font-panel-icon-row');
          _this.element.find('.rightAlignBtn').attr('class', 'rightAlignBtn rightAlignButtonDisable font-panel-icon-row');
          _this.element.find('.centerAlignBtn').attr('class', 'centerAlignBtn centerAlignButtonDisable font-panel-icon-row');
          return btn.trigger('leftAlignment');
        }
      });
      this.element.find(".rightAlignBtn").click(function(event) {
        return $(event.target).trigger('rightAlignment');
      });
      this.element.find(".leftAlignBtn").click(function(event) {
        return $(event.target).trigger('leftAlignment');
      });
      this.element.find(".bulletPointBtn").click(function(event) {
        return $(event.target).trigger('bulletPointBtnEnableClick');
      });
      this.element.find(".orderedPointBtn").click(function(event) {
        return $(event.target).trigger('orderedPointBtnEnableClick');
      });
      this.element.find(".gridElementBtn").click(function() {
        return $(event.target).trigger('panelClickGridBtnClick');
      });
      return this.element.find('.snapBtn').click(function() {
        if (!$(event.target).hasClass("snapBtn-selected")) {
          return $(event.target).addClass("snapBtn-selected");
        } else {
          return $(event.target).removeClass("snapBtn-selected");
        }
      });
    };

    FontPanel.prototype.changeColor = function(hsb, hex, rgb, el) {
      $(el).css('background-color', '#' + hex);
      return $(el).colpickHide();
    };

    FontPanel.prototype.setSettingsFromStyle = function(style) {
      this.element.find('.fontTypeBtn').children().removeAttr('selected').filter('option[value=' + style['font-family'] + ']').attr('selected', 'selected');
      this.element.find('.fontSizeBtn').children().removeAttr('selected').filter('option[value="' + parseInt(style['font-size']) + '"]').attr('selected', 'selected');
      this.element.find('.letter-space').children().removeAttr('selected').filter('option[value="' + parseInt(style['letter-spacing']) + '"]').attr('selected', 'selected');
      this.element.find('.line-height').children().removeAttr('selected').filter('option[value="' + parseInt(style['line-height']) + '"]').attr('selected', 'selected');
      this.element.find('.padding').children().removeAttr('selected').filter('option[value="' + parseInt(style['padding']) + '"]').attr('selected', 'selected');
      this._switchBtn('.wbtn', style['font-weight'] === 'bold');
      this._switchBtn('.ubtn', style['text-decoration'].indexOf('underline') !== -1);
      this._switchBtn('.ibtn', style['font-style'] === 'italic');
      this.element.find(".centerAlignBtn").removeClass("active");
      this.element.find(".leftAlignBtn").removeClass("active");
      this.element.find(".rightAlignBtn").removeClass("active");
      if (style['text-align'] === "left") {
        return this.element.find(".leftAlignBtn").addClass("active");
      } else if (style['text-align'] === "center") {
        return this.element.find(".centerAlignBtn").addClass("active");
      } else if (style['text-align'] === "right") {
        return this.element.find(".rightAlignBtn").addClass("active");
      }
    };

    FontPanel.prototype._switchBtn = function(selector, switchOn) {
      if (switchOn) {
        return this.element.find(selector).addClass('ppedit-btn-enabled active');
      } else {
        return this.element.find(selector).removeClass('ppedit-btn-enabled active');
      }
    };

    FontPanel.prototype.selectFontPanel = function() {
      return this.element.addClass('ppedit-panel-selected');
    };

    FontPanel.prototype.moveFontPanel = function(deltaX, deltaY) {
      var currentPos, leftPos, topPos;
      currentPos = this.currentFontPanelPosition();
      leftPos = deltaX + currentPos.left;
      topPos = deltaY + currentPos.top;
      return this.setFontPanelPosition(leftPos, topPos);
    };

    FontPanel.prototype.stopMoveFontPanel = function() {
      return this.element.removeClass('ppedit-panel-selected');
    };

    FontPanel.prototype.currentFontPanelPosition = function() {
      return this.element.position();
    };

    FontPanel.prototype.setFontPanelPosition = function(x, y) {
      this.element.css('left', x + 'px');
      return this.element.css('top', y + 'px');
    };

    return FontPanel;

  })(Graphic);

  MainPanel = (function(_super) {
    __extends(MainPanel, _super);

    function MainPanel(root) {
      this.root = root;
      MainPanel.__super__.constructor.call(this, this.root);
    }

    MainPanel.prototype.buildElement = function() {
      return this.element = $('\
            <div class="left-sidebar">\
              <div class="main-panel-icon undoImg"></div>\
              <div class="main-panel-icon redoImg"></div>\
              <div class="main-panel-icon gridImg"></div>\
              <div class="main-panel-icon snapImg"></div>\
          </div>');
    };

    MainPanel.prototype.bindEvents = function() {
      var _this = this;
      this.element.find('.snapImg').click(function() {
        if (!$(event.target).hasClass("snapBtn-selected")) {
          return $(event.target).addClass("snapBtn-selected");
        } else {
          return $(event.target).removeClass("snapBtn-selected");
        }
      });
      this.element.find(".gridImg").click(function() {
        return _this.root.trigger('panelClickGridBtnClick');
      });
      this.element.find(".undoImg").click(function() {
        return _this.root.trigger('requestUndo');
      });
      return this.element.find(".redoImg").click(function() {
        return _this.root.trigger('requestRedo');
      });
    };

    return MainPanel;

  })(Graphic);

  /*
  FooBar jQuery Plugin v1.0 - It makes Foo as easy as coding Bar (?).
  Release: 19/04/2013
  Author: Joe Average <joe@average.me>
  
  http://github.com/joeaverage/foobar
  
  Licensed under the WTFPL license: http://www.wtfpl.net/txt/copying/
  */


  (function($, window, document) {
    var $this, methods, _anotherState, _editor, _flag, _internals, _settings;
    $this = void 0;
    _settings = {
      "default": 'cool!'
    };
    _flag = false;
    _anotherState = null;
    _editor = null;
    methods = {
      init: function(options) {
        $this = $(this);
        $.extend(_settings, options || {});
        _editor = new PPEditor($this);
        _editor.buildElement();
        $this.append(_editor.element);
        _editor.bindEvents();
        return $this;
      },
      doSomething: function(what) {
        return $this;
      },
      destroy: function() {
        return $this;
      },
      save: function() {
        return _editor.commandManager.getUndoJSON();
      },
      allHunks: function() {
        return _editor.area.boxesContainer.getAllHunks();
      },
      clearHistory: function() {
        _editor.commandManager.clearHistory();
        return $this;
      },
      load: function(options) {
        _editor.load(options.hunks);
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

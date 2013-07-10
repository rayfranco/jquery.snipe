(function() {
  var $, Bounds, Snipe, defaults;

  $ = jQuery;

  /*
  Defaults plugin settings
  */


  defaults = {
    "class": 'snipe-lens',
    size: 200,
    ratio: null,
    image: {
      url: null,
      width: null,
      height: null
    },
    zoom: {
      url: null,
      width: null,
      height: null
    },
    css: {
      borderRadius: 200,
      width: 200,
      height: 200,
      border: '2px solid white',
      backgroundColor: 'white',
      boxShadow: '0 0 10px #777, 0 0 8px black inset, 0 0 80px white inset',
      position: 'absolute',
      top: 0,
      left: 0,
      backgroundRepeat: 'no-repeat'
    },
    zoomin: function(lens) {},
    zoomout: function(lens) {},
    zoommoved: function(lens) {}
  };

  Bounds = (function() {
    function Bounds(top, right, bottom, left) {
      this.top = top;
      this.right = right;
      this.bottom = bottom;
      this.left = left;
      return this;
    }

    Bounds.prototype.update = function(top, right, bottom, left) {
      this.top = top;
      this.right = right;
      this.bottom = bottom;
      this.left = left;
    };

    Bounds.prototype.contains = function(x, y) {
      return (this.left < x && x < this.right) && (this.top < y && y < this.bottom);
    };

    return Bounds;

  })();

  Snipe = (function() {
    function Snipe(el, settings) {
      var _this = this;
      this.el = el;
      if (settings == null) {
        settings = {};
      }
      /*
      Make the global settings object
      */

      this._makeSettings(settings);
      /*
      Make ratio
      */

      this._makeRatio();
      /*
      Make Bounds, will not work well if image size is not defined !
      */

      this._makeBounds();
      /*
      Attach a self reference to the DOM. Allow usage of the API
      */

      this.el.data('snipe', this);
      /*
      Create the lens, apply CSS and keep a reference to it
      */

      this.lens = $('<div>').addClass(this.settings["class"]).css('display', 'none').appendTo('body');
      this.lens.css(this.settings.css);
      /*
      Listen to mousemove on the element
      */

      this.img.bind('mousemove', function(e) {
        return _this._onMouseMove(e);
      });
      /*
      Run
      */

      this._run();
      /*
      Return the element, allow chaining
      */

      return this.el;
    }

    Snipe.prototype._makeSettings = function(settings) {
      var _base, _base1, _base2, _base3, _base4, _base5, _base6, _base7;
      this.settings = $.extend(true, {}, defaults, settings);
      this.img = this.el.is('img') ? this.el : this.el.find('img:first');
      if ((_base = this.settings.image).url == null) {
        _base.url = this.el.data('zoom') || this.img.data('zoom') || this.el.attr('href') || this.img.attr('src');
      }
      if ((_base1 = this.settings.image).url == null) {
        _base1.url = this.img.attr('src');
      }
      if ((_base2 = this.settings.image).width == null) {
        _base2.width = this.img[0].width;
      }
      if ((_base3 = this.settings.image).height == null) {
        _base3.height = this.img[0].height;
      }
      if ((_base4 = this.settings.zoom).url == null) {
        _base4.url = this.el.data('zoom') || this.settings.image.url;
      }
      if ((_base5 = this.settings.zoom).width == null) {
        _base5.width = this.el.data('width') || this.settings.image.width;
      }
      if ((_base6 = this.settings.zoom).height == null) {
        _base6.height = this.el.data('height') || this.settings.image.height;
      }
      if ((_base7 = this.settings).ratio == null) {
        _base7.ratio = this.el.data('ratio') || null;
      }
      return this.settings.css.backgroundImage = "url(" + this.settings.zoom.url + ")";
    };

    /*
    This method will be called on init
    */


    Snipe.prototype._makeBounds = function() {
      this.offset = this.img.offset();
      delete this.bounds;
      return this.bounds = new Bounds(this.offset.top, this.offset.left + this.img.width(), this.offset.top + this.img.height(), this.offset.left);
    };

    /*
    This should be called when the ratio element is ready
    */


    Snipe.prototype._makeRatio = function() {
      if (this.settings.ratio) {
        return this.ratioX = this.ratioY = this.settings.ratio;
      } else {
        this.ratioX = this.settings.zoom.width / this.settings.image.width;
        return this.ratioY = this.settings.zoom.height / this.settings.image.height;
      }
    };

    /*
    This method should be called on every reflow
    */


    Snipe.prototype._updateBounds = function() {
      this.offset = this.img.offset();
      return this.bounds.update(this.offset.top, this.offset.left + this.img.width(), this.offset.top + this.img.height(), this.offset.left);
    };

    /*
    This method will be called when the mouse move over the element
    */


    Snipe.prototype._onMouseMove = function(e) {
      var backgroundX, backgroundY;
      if (!this.bounds.contains(e.pageX, e.pageY)) {
        this.hide();
        return;
      }
      backgroundX = -((e.pageX - this.offset.left) * this.ratioX - this.settings.size * .5);
      backgroundY = -((e.pageY - this.offset.top) * this.ratioY - this.settings.size * .5);
      this.lens.css({
        left: e.pageX - this.settings.size * .5,
        top: e.pageY - this.settings.size * .5,
        backgroundPosition: "" + backgroundX + "px " + backgroundY + "px"
      });
      return backgroundX = backgroundY = null;
    };

    /*
    This will be called when everything is ready
    */


    Snipe.prototype._run = function() {
      var _this = this;
      this.hide();
      $('body').on('mousemove.snipe', function(e) {
        e.stopPropagation();
        return _this._onMouseMove.call(_this, e);
      });
      return this.img.on('mousemove.snipe', function(e) {
        e.stopPropagation();
        if (_this.off) {
          return _this.show.call(_this);
        }
      });
    };

    /* 
    API Methods
    */


    Snipe.prototype.show = function() {
      if (this.el.not(':visible')) {
        this._makeBounds();
        console.log('make bounds');
        this.lens.show();
        this.off = false;
      }
      return this;
    };

    Snipe.prototype.hide = function() {
      this.lens.hide();
      this.off = true;
      return this;
    };

    return Snipe;

  })();

  (function($) {
    return $.fn.snipe = function(settings) {
      return this.each(function() {
        return $(this).data('snipe') || new Snipe($(this), settings);
      });
    };
  })(jQuery);

}).call(this);

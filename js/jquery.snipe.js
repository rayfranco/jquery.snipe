(function() {
  var $, Bounds, Snipe, defaultsSettings, forceSettings;

  $ = jQuery;

  defaultsSettings = {
    "class": 'snipe-lens',
    size: 200,
    animation: null,
    image: null,
    cursor: 'none',
    bounds: [],
    css: {
      borderRadius: 200,
      width: 200,
      height: 200,
      border: '2px solid white',
      backgroundColor: 'white',
      boxShadow: '0 0 10px #777, 0 0 8px black inset, 0 0 80px white inset'
    },
    zoomin: function(lens) {},
    zoomout: function(lens) {},
    zoommoved: function(lend) {}
  };

  forceSettings = {
    css: {
      position: 'absolute',
      top: 0,
      left: 0,
      backgroundRepeat: 'no-repeat'
    }
  };

  Bounds = (function() {

    function Bounds(top, right, bottom, left) {
      this.top = top;
      this.right = right;
      this.bottom = bottom;
      this.left = left;
      return this;
    }

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
      this.body = $('body');
      this.defaults = defaultsSettings;
      this.makeSettings(settings);
      this.el.one('load', function() {
        return _this.makeBounds();
      }).each(function() {
        if (this.complete) {
          return $(this).load();
        }
      });
      this.el.data('snipe', this);
      this.lens = $('<div>').addClass(this.settings["class"]).css('display', 'none').appendTo('body');
      this.ratioX = 1;
      this.ratioY = 1;
      this.ratioEl = $('<img>').attr('src', this.settings.image);
      this.ratioEl.one('load', function() {
        return _this.calculateRatio.call(_this);
      }).each(function() {
        if (this.complete) {
          return $(this).load();
        }
      });
      this.el.bind('mousemove', function(e) {
        return _this.onMouseMove(e);
      });
      return this.el;
    }

    Snipe.prototype.makeSettings = function(settings) {
      var img;
      if (this.el.is('a')) {
        img = this.el.find('img:first');
        this.defaults.image = settings.image || this.el.attr('href');
      } else {
        img = this.el.is('img') ? this.el : this.el.find('img:first');
        this.defaults.image = settings.image || this.el.data('zoom') || this.el.attr('src');
      }
      this.el = img;
      this.defaults.css.backgroundImage = "url(" + this.defaults.image + ")";
      this.defaults.css.cursor = settings.cursor || this.defaults.cursor;
      this.settings = $.extend({}, this.defaults, settings, forceSettings);
      return this.settings.css = $.extend({}, this.defaults.css, settings && settings.css, forceSettings.css);
    };

    Snipe.prototype.makeBounds = function() {
      this.offset = this.el.offset();
      return this.bounds = new Bounds(this.offset.top, this.offset.left + this.el.width(), this.offset.top + this.el.height(), this.offset.left);
    };

    Snipe.prototype.run = function() {
      return this.hide();
    };

    Snipe.prototype.calculateRatio = function() {
      this.ratioX = this.ratioEl[0].width / this.el[0].width;
      this.ratioY = this.ratioEl[0].height / this.el[0].height;
      this.ratioEl.remove();
      this.lens.css(this.settings.css);
      return this.run();
    };

    Snipe.prototype.onMouseMove = function(e) {
      var backgroundX, backgroundY;
      if (!(this.bounds != null) && this.lens.not(':animated')) {
        return;
      } else {
        if (!this.bounds.contains(e.pageX, e.pageY)) {
          this.hide();
        }
      }
      backgroundX = -((e.pageX - this.offset.left) * this.ratioX - this.settings.size * .5);
      backgroundY = -((e.pageY - this.offset.top) * this.ratioY - this.settings.size * .5);
      return this.lens.css({
        left: e.pageX - this.settings.size * .5,
        top: e.pageY - this.settings.size * .5,
        backgroundPosition: "" + backgroundX + "px " + backgroundY + "px"
      });
    };

    /* 
    API Methods
    */


    Snipe.prototype.show = function(animation) {
      var _this = this;
      if (animation == null) {
        animation = true;
      }
      this.makeBounds();
      this.el.unbind('mousemove');
      this.el.unbind('mouseover');
      this.body.bind('mousemove', function(e) {
        return _this.onMouseMove(e);
      });
      this.lens.show().css({
        opacity: 1,
        cursor: this.settings.css.cursor
      });
      return this;
    };

    Snipe.prototype.hide = function(animation) {
      var _this = this;
      if (animation == null) {
        animation = true;
      }
      this.el.bind('mouseover', function(e) {
        return _this.show();
      });
      this.body.unbind('mousemove');
      this.lens.css({
        opacity: 0,
        cursor: 'default'
      }).hide();
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

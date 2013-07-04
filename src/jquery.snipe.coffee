$ = jQuery

defaultsSettings =
  class:    'snipe-lens'
  size:     200
  animation:  null
  image:    null
  cursor:   'none'
  bounds:   []
  css:
    borderRadius: 200
    width:      200
    height:     200
    border:     '2px solid white'
    backgroundColor:'white'
    boxShadow:    '0 0 10px #777, 0 0 8px black inset, 0 0 80px white inset'
  zoomin:   (lens) ->
  zoomout:  (lens) ->
  zoommoved:  (lend) ->

forceSettings =
  css:
    position:   'absolute'
    top:        0
    left:       0
    backgroundRepeat: 'no-repeat'

class Bounds
  constructor: (@top, @right, @bottom, @left) ->
    return @
  contains: (x,y) ->
    @left < x < @right and @top < y < @bottom

class Snipe
  constructor: (@el, settings = {}) ->
    @body       = $('body')
    @defaults   = defaultsSettings
    @makeSettings settings
    @el.one('load',=>
      @makeBounds()
    ).each(->
      $(@).load() if @.complete
    )

    @lens     = $('<div>').addClass(@settings.class).css('display','none').appendTo('body')
    @ratioX   = 1
    @ratioY   = 1

    @ratioEl  = $('<img>').attr('src',@settings.image)

    @ratioEl.one('load',=>
      @calculateRatio.call(@)
    ).each(->
      $(@).load() if @.complete
    )
    
    @el.bind 'mousemove', (e) => @onMouseMove e

    return @el

  makeSettings: (settings) ->
    if @el.is 'a'
      img = @el.find('img:first')
      @defaults.image = settings.image or @el.attr('href')
    else
      img = if @el.is 'img' then @el else @el.find('img:first')
      @defaults.image = settings.image or @el.data('zoom') or @el.attr('src') 
    @el = img

    @defaults.css.backgroundImage = "url(#{ @defaults.image })"
    @defaults.css.cursor = settings.cursor or @defaults.cursor

    @settings     = $.extend {}, @defaults, settings, forceSettings
    @settings.css = $.extend {}, @defaults.css, settings and settings.css, forceSettings.css

  # Check mouse events before using this
  makeBounds: () ->
    @offset   = @el.offset()
    @bounds   = new Bounds @offset.top, @offset.left + @el.width(), @offset.top + @el.height(), @offset.left


  run: () ->
    @hide()

  calculateRatio: () ->
    @ratioX = @ratioEl[0].width  / @el[0].width
    @ratioY = @ratioEl[0].height / @el[0].height
    @ratioEl.remove()
    @lens.css(@settings.css)
    @run()

  onMouseMove: (e) ->
    # Hide if out of bounds
    if not @bounds? and @lens.not(':animated')
      return
    else
      @hide() if not @bounds.contains e.pageX, e.pageY
    # todo: deal whith mouseover on load.

    # Calculate background position
    backgroundX = -((e.pageX - @offset.left) * @ratioX - @settings.size * .5) 
    backgroundY = -((e.pageY - @offset.top) * @ratioY - @settings.size * .5)

    # Apply CSS modifications
    @lens.css
      left: e.pageX - @settings.size * .5
      top: e.pageY - @settings.size * .5
      backgroundPosition: "#{backgroundX}px #{backgroundY}px"


  ### 
  API Methods 
  ###

  show: (animation = true) ->
    # Reset bounds
    @makeBounds()

    @el.unbind 'mousemove'
    @el.unbind 'mouseover'
    @body.bind 'mousemove', (e) => @onMouseMove e
    @lens.show().css({opacity:1,cursor:@settings.css.cursor})
    @

  hide: (animation = true) ->
    @el.bind 'mouseover', (e) => @show()
    @body.unbind 'mousemove'
    @lens.css({opacity:0,cursor:'default'}).hide();
    @

(($) ->
  $.fn.snipe = (settings) ->
    new Snipe(@, settings)
)(jQuery)

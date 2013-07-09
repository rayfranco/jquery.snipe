$ = jQuery

###
Defaults plugin settings
###
defaults =
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

    # Please don't change this...
    position:   'absolute'
    top:        0
    left:       0
    backgroundRepeat: 'no-repeat'

  zoomin:   (lens) ->
  zoomout:  (lens) ->
  zoommoved:  (lens) ->

class Bounds
  constructor: (@top, @right, @bottom, @left) ->
    return @
  update: (@top, @right, @bottom, @left) ->
  contains: (x,y) ->
    @left < x < @right and @top < y < @bottom

class Snipe
  constructor: (@el, settings = {}) ->
    # @body       = $('body')
    # @defaults   = defaults

    @_makeSettings settings

    ###
    Not sure this is working, would it help make the loading better ? Mwahhh...
    ###
    @el.one 'load', =>
      @_makeBounds()
    @el.load() if @.complete

    ###
    Attach a self reference to the DOM. Allow usage of the API
    ###
    @el.data 'snipe', this
    
    ###
    Create the lens and keep a reference to it
    ###
    @lens     = $('<div>').addClass(@settings.class).css('display','none').appendTo('body')

    ###
    Initialize ratio properties
    ###
    @ratioX   = 1
    @ratioY   = 1
    @ratioEl  = $('<img>').attr('src',@settings.image)

    ###
    Load ration image
    ###
    @ratioEl.one('load',=>
      @calculateRatio.call(@)
    ).each(->
      $(@).load() if @.complete
    )
    
    ###
    Listen to mousemove on the element
    ###
    @el.bind 'mousemove', (e) => @onMouseMove e

    ###
    Return the element, allow chaining
    ###
    return @el

  _makeSettings: (settings) ->
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

  ###
  This method will be called on init
  ###
  _makeBounds: ->
    @offset   = @el.offset()
    @bounds   = new Bounds @offset.top, @offset.left + @el.width(), @offset.top + @el.height(), @offset.left

  ###
  This should be called when the ratio element is ready
  ###
  _makeRatio: ->
    @ratioX = @ratioEl[0].width  / @el[0].width
    @ratioY = @ratioEl[0].height / @el[0].height
    @ratioEl.remove()
    @lens.css(@settings.css)
    @run()

  ###
  This method should be called on every reflow
  ###
  _updateBounds: () ->
    @offset   = @el.offset()
    @bounds.update @offset.top, @offset.left + @el.width(), @offset.top + @el.height(), @offset.left

  ###
  This method will be called when the mouse move over the element
  ###
  _onMouseMove: (e) ->
    # Hide if out of bounds
    if not @bounds? and @lens.not(':animated')
      return
    else
      @hide() if not @bounds.contains e.pageX, e.pageY

    # Calculate background position
    backgroundX = -((e.pageX - @offset.left) * @ratioX - @settings.size * .5) 
    backgroundY = -((e.pageY - @offset.top) * @ratioY - @settings.size * .5)

    # Apply CSS modifications
    @lens.css
      left: e.pageX - @settings.size * .5
      top: e.pageY - @settings.size * .5
      backgroundPosition: "#{backgroundX}px #{backgroundY}px"

  ###
  This will be called when everything is ready
  ###
  _run: () ->
    @hide()


  ### 
  API Methods 
  ###

  show: ->
    # Reset bounds
    @makeBounds()

    @el.unbind 'mousemove'
    @el.unbind 'mouseover'
    @body.bind 'mousemove', (e) => @onMouseMove e
    @lens.show().css({opacity:1,cursor:@settings.css.cursor})
    @

  hide: ->
    @el.bind 'mouseover', (e) => @show()
    @body.unbind 'mousemove'
    @lens.css({opacity:0,cursor:'default'}).hide();
    @

(($) ->
  $.fn.snipe = (settings) ->
    @each () ->
      return $(@).data('snipe') or new Snipe($(@), settings)
)(jQuery)

$ = jQuery

###
Defaults plugin settings
###
defaults =
  class:    'snipe-lens'
  size:     200
  ratio:    null
  applyCss: true

  # Original image configuration
  image:
    url:    null
    width:  null
    height: null

  # Zoom image configuration
  zoom:
    url:    null
    width:  null
    height: null

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
    ###
    Make the global settings object
    ###
    @_makeSettings settings

    ###
    Make ratio
    ###
    @_makeRatio()

    ###
    Make Bounds, will not work well if image size is not defined !
    ###
    @_makeBounds()

    ###
    Attach a self reference to the DOM. Allow usage of the API
    ###
    @el.data 'snipe', this

    ###
    Create the lens, apply CSS and keep a reference to it
    ###
    @lens     = $('<div>').addClass(@settings.class).css('display','none').appendTo('body')

    @lens.css @settings.css if @settings.applyCss

    # Lens settings
    @lens.css 'backgroundImage', "url(#{ @settings.zoom.url })"

    ###
    Listen to mousemove on the element
    ###
    @img.bind 'mousemove', (e) => @_onMouseMove e

    ###
    Run
    ###
    @_run()

    ###
    Return the element, allow chaining
    ###
    return @el

  _makeSettings: (settings) ->
    # Make settings
    @settings = $.extend true, {}, defaults, settings

    # Desambiguation with @el and @img
    @img = if @el.is 'img' then @el else @el.find('img:first')
    @settings.image.url ?= @el.data('zoom') or @img.data('zoom') or @el.attr('href') or @img.attr('src')
    
    # Image settings
    @settings.image.url     ?= @img.attr('src')
    @settings.image.width   ?= @img[0].width
    @settings.image.height  ?= @img[0].height

    # Zoom image settings
    @settings.zoom.url    ?= @el.data('zoom') or @settings.image.url
    @settings.zoom.width  ?= @el.data('width') or @settings.image.width
    @settings.zoom.height ?= @el.data('height') or @settings.image.height
    @settings.ratio       ?= @el.data('ratio') or null

  ###
  This method will be called on init
  ###
  _makeBounds: ->
    @offset   = @img.offset()
    delete @bounds
    @bounds   = new Bounds @offset.top, @offset.left + @img.width(), @offset.top + @img.height(), @offset.left

  ###
  This should be called when the ratio element is ready
  ###
  _makeRatio: ->
    if @settings.ratio
      @ratioX = @ratioY = @settings.ratio
    else
      @ratioX = @settings.zoom.width / @settings.image.width
      @ratioY = @settings.zoom.height / @settings.image.height

  ###
  This method should be called on every reflow
  ###
  _updateBounds: () ->
    @offset = @img.offset()
    @bounds.update @offset.top, @offset.left + @img.width(), @offset.top + @img.height(), @offset.left

  ###
  This method will be called when the mouse move over the element
  ###
  _onMouseMove: (e) ->
    # Hide if out of bounds
    if not @bounds.contains e.pageX, e.pageY
      @hide()
      return

    # Calculate background position
    backgroundX = -((e.pageX - @offset.left) * @ratioX - @settings.size * .5) 
    backgroundY = -((e.pageY - @offset.top) * @ratioY - @settings.size * .5)

    # Apply CSS modifications
    @lens.css
      left: e.pageX - @settings.size * .5
      top: e.pageY - @settings.size * .5
      backgroundPosition: "#{backgroundX}px #{backgroundY}px"

    backgroundX = backgroundY = null

  ###
  This will be called when everything is ready
  ###
  _run: () ->
    @hide()
    $('body').on 'mousemove.snipe', (e) => 
      e.stopPropagation()
      @_onMouseMove.call(@,e)
    @img.on 'mousemove.snipe', (e) =>
      e.stopPropagation()
      @show.call(@) if @off

  ### 
  API Methods 
  ###

  show: ->
    if @el.not(':visible')
      # Reset bounds
      @_makeBounds()
      console.log 'make bounds'
      @lens.show()
      @off = false
    @

  hide: ->
    @lens.hide()
    @off = true
    @

(($) ->
  $.fn.snipe = (settings) ->
    @each () ->
      return $(@).data('snipe') or new Snipe($(@), settings)
)(jQuery)

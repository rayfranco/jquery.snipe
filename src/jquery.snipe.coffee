$ = jQuery

defaults =
	class: 		'snipe-lens'
	size: 		200
	animation: 	null
	image: 		null
	css:
		borderRadius:	200
		width: 			200
		height: 		200
		border: 		'2px solid white'
		cursor: 		'none'
		backgroundColor:'white'
		boxShadow:		'0 0 10px #777, 0 0 8px black inset, 0 0 80px white inset'
	zoomin: 	(lens) ->
	zoomout: 	(lens) ->
	zoommoved: 	(lend) ->

forcedCss =
	position: 	'absolute'
	top: 		0
	left: 		0
	backgroundRepeat: 'no-repeat'

class Bounds
	constructor: (@top, @right, @bottom, @left) ->
		return @
	contains: (x,y) ->
		@left < x < @right and @top < y < @bottom

class Snipe
	constructor: (@el, settings) ->
		@body 		= $('body')
		@settings 	= @makeSettings settings
		@lens 		= $('<div>').addClass(@settings.class).css('display','none').appendTo('body')
		@ratioX 	= 1
		@ratioY 	= 1
		@ratioEl	= $('<img>').load(=> @calculateRatio @).attr('src',@settings.image).css('display','none').appendTo(@el.parent())
		@el.load =>
			@offset 	= @el.position()
			@bounds 	= new Bounds @offset.top, @offset.left + @el.width(), @offset.top + @el.height(), @offset.left
		@el.bind 'mousemove', (e) => @onMouseMove e
		return @el

	makeSettings: (settings) ->
		defaults.image = settings.image or @el.data('zoom') or @el.attr('src') or @el.find('a:first').attr('href') or @el.find('img:first').attr('src')
		defaults.css.backgroundImage = "url("+ defaults.image + ")"
		defaults.css = $.extend {}, defaults.css, settings and settings.css, forcedCss

		$.extend {}, defaults, settings

	run: () ->
		@hide()

	calculateRatio: (o) ->
		o.ratioX = o.ratioEl.width()  / o.el.width()
		o.ratioY = o.ratioEl.height() / o.el.height()
		o.ratioEl.remove()
		o.lens.css(o.settings.css)
		o.run()
		o

	onMouseMove: (e) ->
		# Hide if out of bounds
		if not @bounds?
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
			backgroundPosition: backgroundX+'px '+backgroundY+'px'

	### 
	API Methods 
	###

	show: (animation = true) ->
		@lens.show()
		@el.unbind 'mousemove'
		@el.unbind 'mouseover'
		@body.bind 'mousemove', (e) => @onMouseMove e
		@

	hide: (animation = true) ->
		@lens.hide()
		@el.bind 'mouseover', (e) => @show()
		@body.unbind 'mousemove'
		@

(($) ->
  $.fn.snipe = (settings) ->
    new Snipe(@, settings)
)(jQuery)

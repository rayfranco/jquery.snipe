$ = jQuery

defaults =
	class: 		'lens'
	size: 		200
	animation: 	null
	image: 		null
	css:
		borderRadius:	200
		width: 			200
		height: 		200
		border: 		'5px solid grey'
		cursor: 		'crosshair'
		backgroundColor:'white'
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
		@
	contains: (x,y) ->
		@left < x < @right and @top < y < @bottom

class Lens
	constructor: (@el, settings) ->
		@body 		= $('body')
		@settings 	= @makeSettings settings

		console.log @settings.image

		@offset 	= @el.position()
		@lens 		= $('<div>').addClass(@settings.class).css(@settings.css).appendTo('body')
		@ratioEl	= $('<img>').attr('src',@settings.image).css('display','block').appendTo(@el.parent())
		@ratioX 	= 1
		@ratioY 	= 1
		@bounds 	= new Bounds @offset.top, @offset.left + @el.width(), @offset.top + @el.height(), @offset.left

	makeSettings: (settings) ->
		defaults.image = settings.image or @el.data('zoom') or @el.attr('src') or @el.find('a:first').attr('href') or @el.find('img:first').attr('src')
		defaults.css.backgroundImage = "url("+ defaults.image + ")"
		defaults.css = $.extend {}, defaults.css, settings and settings.css, forcedCss

		$.extend {}, defaults, settings

	run: () ->
		@ratioEl.load => @calculateRatio @
		@show()

	calculateRatio: (o) ->
		console.log(o.ratioEl.width(), o.el.width())
		o.ratioX = o.ratioEl.width()  / o.el.width()
		o.ratioY = o.ratioEl.height() / o.el.height()
		console.log(o.ratioEl.width(), o.ratioEl.height())
		o.ratioEl.remove()
		o

	onMouseMove: (e) ->

		console.log @ratioX

		# Hide if out of bounds
		@hide() if not @bounds.contains e.pageX, e.pageY  

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
		@el.unbind 'mouseenter'
		@body.bind 'mousemove', (e) => @onMouseMove e
		@

	hide: (animation = true) ->
		@lens.hide()
		@el.bind 'mouseenter', (e) => @show()
		@body.unbind 'mousemove'
		@

(($) ->
  $.fn.lens = (settings) ->
    new Lens(@, settings).run()
)(jQuery)

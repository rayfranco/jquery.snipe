**Note:** This is in a very early stage of development. Don't use it in production !

Features
========

Lens-styled zoom on images.

Basic usage
===========

The best way to get it working fast is by wrapping the image to be zoomed in an `a` tag
	
	<a href="large.jpg" class="lens">
		<img src="normal.jpg">
	</a>

Or by setting a `data-zoom` property

	<img src="normal.jpg" class="lens" data-zoom="large.jpg">

And this is how you call the plugin

	$('.lens img').lens();

If your DOM don't care about your high-definition image, just tell the plugin directly :

	$('.lens img').lens({
		image: 'large.jpg'
	});

There is more options to configure the plugin, see **Configuration** section.

Configuration
==============

<table>
	<tr>
		<th>Option</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>class</td>
		<td>string</td>
		<td>lens</td>
		<td>CSS class that will be added to the lens object</td>
	</tr>
	<tr>
		<td>size</td>
		<td>int</td>
		<td>200</td>
		<td>Size of the lens (diameter)</td>
	</tr>
	<tr>
		<td>animation</td>
		<td>null</td>
		<td>null</td>
		<td>Unused yet</td>
	</tr>
	<tr>
		<td>image</td>
		<td>string</td>
		<td>null</td>
		<td>Image url in it's high definition version. If `null` given, it will check for `data-zoom` property or `href` element if targeted on a `a` element</td>
	</tr>
	<tr>
		<td>css</td>
		<td>object or false</td>
		<td>*N/A*</td>
		<td>Properties that will be passed to the lens. Set it to false to do your custom CSS from outside the plugin</td>
		<td></td>
	</tr>
	<tr>
		<td>zoomin</td>
		<td>function</td>
		<td>null</td>
		<td>Callback that will be called when the zoom lens is displayed</td>
	</tr>
	<tr>
		<td>zoomout</td>
		<td>function</td>
		<td>null</td>
		<td>Callback that will be called when the zoom lens is hidden</td>
	</tr>
	<tr>
		<td>zoommoved</td>
		<td>function</td>
		<td>null</td>
		<td>Callback that will be called when the zoom lens is moving</td>
	</tr>
</table>

Advanced usage
==============

Nothing here yet

Compatibility
=============

Not tested yet
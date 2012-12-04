**Note:** This is in a very early stage of development. Don't use it in production !

[jquery.snipe](http://rayfranco.github.com/jquery.snipe)
==============

Sniper-lens-style zoom on images.

Get started, check the demos and the docs on [http://rayfranco.github.com/jquery.snipe](http://rayfranco.github.com/jquery.snipe)

Quick Start
-----------

Get the [minified script](https://raw.github.com/RayFranco/jquery.snipe/master/js/jquery.snipe.js) and target your images with a `data-zoom` attribute, which its value is the high definition image (what will appear in the lens)

    <!-- In your html file -->
    <img src="normal.jpg" data-zoom="large.jpg">

    // In your javascript file or tag
    $('img#snipe').snipe();

[More details](http://rayfranco.github.com/jquery.snipe/index.html)

[See it in action](http://rayfranco.github.com/jquery.snipe/demos.html)

Contribute
----------

Clone the repository :

`git clone https://github.com/RayFranco/jquery.snipe.git`

In the plugin folder, get the dependencies :

`npm install`

Then setup the whole thing :

`cake setup --dev`

*You should use --dev only if you need the test suite*

The plugin is written in [coffeescript](http://coffeescript.org/) and tested with [buster.js](http://docs.busterjs.org/en/latest/)
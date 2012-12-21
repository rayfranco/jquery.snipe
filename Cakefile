fs     = require 'fs'
spawn  = require('child_process').spawn
exec   = require('child_process').exec
util   = require 'util'
flour  = require 'flour'

task 'setup', ->
	exec 'bower install', (err, stdout, stderr) ->
		util.log stdout

task 'build:coffee', ->
    compile 'src/jquery.snipe.coffee', 'js/jquery.snipe.js', (output) ->
    	util.log 'CoffeeScript compiled !'
	   	minify 'js/jquery.snipe.js', 'js/jquery.snipe.min.js', (output) ->
			util.log 'Javascript Minified !'

task 'build', ->
	invoke 'build:coffee'

task 'test', ->
	invoke 'build'
	exec 'buster test', (err, stdout, stderr) ->
		util.log stdout
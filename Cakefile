fs     = require 'fs'
spawn  = require('child_process').spawn
exec   = require('child_process').exec
util   = require 'util'
flour  = require 'flour'

task 'build:coffee', ->
    compile 'src/jquery.snipe.coffee', 'js/jquery.snipe.js'

task 'build', ->
	invoke 'build:coffee'

task 'test', ->
	exec 'buster test', (err, stdout, stderr) ->
		util.log stdout
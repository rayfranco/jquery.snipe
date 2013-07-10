module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('./package.json')

    coffee:
      compile:
        files:
          'build/jquery.snipe.js': 'src/jquery.snipe.coffee'

    uglify:
      options:
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */'
      javascript:
        files:
          'build/jquery.snipe.min.js': ['build/jquery.snipe.js']

    watch:
      src:
        files: 'src/jquery.snipe.coffee'
        tasks: 'coffee'
      js:
        files: [
          'build/jquery.snipe.js'
        ]
        tasks: ['jasmine','uglify']
        options:
          livereload: true
      demo:
        files: [
          'demo/**/*'
          'build/jquery.snipe.min.js'
        ]
        options:
          livereload: true
      specs:
        files: [
          'spec/SnipeSpec.js'
          'spec/SpecRunner.tmpl'
        ]
        tasks: ['jasmine']
        options:
          livereload: true

    connect:
      preview:
        options:
          port: 9000
          base: './'

    jasmine:
      plugin:
        src: 'build/jquery.snipe.js'
        options:
          specs: 'spec/SnipeSpec.js'
          template: 'spec/SpecRunner.tmpl'
          vendor: 'http://code.jquery.com/jquery-1.10.1.min.js'
          keepRunner: true


  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'

  grunt.registerTask 'default', ['preview']

  grunt.registerTask 'preview', ['coffee','jasmine','connect','watch']
  grunt.registerTask 'build', ['coffee', 'jasmine','uglify']

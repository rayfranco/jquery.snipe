module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('./package.json')

    coffee:
      compile:
        files:
          'js/jquery.snipe.js': 'src/jquery.snipe.coffee'

    uglify:
      options:
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */'
      javascript:
        files:
          'js/jquery.snipe.min.js': ['js/jquery.snipe.js']

    watch:
      src:
        files: 'src/jquery.snipe.coffee'
        tasks: 'coffee'
      js:
        files: [
          'js/jquery.snipe.js'
        ]
        tasks: ['uglify']
        options:
          livereload: true
      demo:
        files: [
          'demo/**/*'
          'js/jquery.snipe.min.js'
        ]
        options:
          livereload: true

    connect:
      preview:
        options:
          port: 9000
          base: './'

  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'

  grunt.registerTask 'default', ['preview']

  grunt.registerTask 'preview', ['connect','watch','coffee']
  grunt.registerTask 'build', ['coffee', 'uglify']
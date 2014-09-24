module.exports = (grunt) ->

  # TASKS
  # ============================================================================
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    # Cleaning
    # --------
    clean:
      tpl    : ['src/js/templates/**/*.js']
      js     : ['build/js/']
      css    : ['build/css/']
      html   : ['build/*.html']
      assets : ['build/fonts/','build/img/','build/*.{ico,png}']
      all    : ['build/','src/templates/**/*.js']

    # Copying
    # -------
    copy:
      assets:
        expand : true
        cwd    : 'src/'
        src    : ['files/**', 'fonts/**','img/**','*.{png,ico}']
        dest   : 'build/'
      libs:
        expand : true
        cwd    : 'src/'
        src    : ['js/lib/**']
        dest   : 'build/'

    # Assembling
    # ----------
    assemble:
      options:
        assets    : 'build/'
        data      : ['src/tpl/_data/**/*.{json,yml}', 'package.json'],
        helpers   : ['src/tpl/_helpers/**/*.js','node_modules/prettify/prettify.js']
        partials  : ['src/tpl/_includes/**/*.{md,html,hbs}','src/tpl/pages/**/*-ajax-*.{md,html,hbs}','src/tpl/pages/**/pop-*.{md,html,hbs}']
        layoutdir : 'src/tpl/_layouts'
        layout    : 'default.hbs'

        # Prettify helpers configuration
        prettify:
          indent   : 2
          condense : true
          newlines : true

      pages:
        files: [{
          expand : true
          cwd    : 'src/tpl/'
          src    : ['index.hbs','**/*.{md,html,hbs}','!_**/*','!**/_*']
          dest   : 'build/'
          ext    : '.html'
        }]

    # Compass / CSS
    # -------------
    compass:
      options:
        config     : './config.rb'
        force      : true
        bundleExec : true
      compile:
        clean : true
        trace : false
      watch:
        clean : false
        trace : true
        watch : true

    # RequireJS
    # ---------
    requirejs:
      compile:
        options:
          baseUrl: 'src/js'
          mainConfigFile: 'src/js/main.js'
          preserveLicenseComments: false
          optimize: 'uglify2'
          uglify2:
            mangle: true
          generateSourceMaps: true
          paths:
            almond: '../../node_modules/almond/almond'
            settings: 'empty:'
          name: 'main'
          fileExclusionRegExp: /tpl|_/,
          out: 'build/js/main.js'
          include: ['almond']

    # JSHint
    # ------
    jshint:
      options:
        jshintrc : '.jshintrc'
      files: ['src/js/**/*.js','!src/js/lib/**/*.js']

    # JS Compiling
    # ------------
    jst:
      options:
        amd       : true
        namespace : false
      compile:
        files: [{
          expand : true
          cwd    : 'src/js/templates/'
          src    : ['**/*.tpl']
          dest   : 'src/js/templates/'
          ext    : '.js'
        }]

    modernizr:
      dist:
        devFile    : 'remote'
        outputFile : 'build/js/lib/modernizr.js'
        parseFiles : true
        extra:
          shiv       : true
          printshiv  : false
          load       : false
          mq         : false
          cssclasses : true
        tests: ['touch']
        uglify: true
        files :
          src: ['src/js/**/*.js','src/scss/project/**/*.scss']

    # Compress Build to TGZ
    # ---------------------
    compress:
      build:
        options:
          archive: ->
            date = new Date
            return "build-#{date.toISOString()}.tar.gz"
          mode: "tgz"
        files: [{
          expand: true
          cwd: 'build/'
          src: ['**', '!files/*.{m4v,ogv,webm}']
          dest: './'
        }]

    # Livereload
    # ----------
    connect:
      options:
        base: 'build'
      basic :
        options:
          livereload: true
      server:
        options :
          keepalive : true

    watch:
      options:
        livereload: true
        atBegin: true
      css:
        files: ['src/scss/**/*.scss']
        tasks: ['assets', 'compass:watch']
      js:
        files: ['src/js/templates/**/*.tpl','src/js/**/*.js','Requirefile.js']
        tasks: ['js']
      html:
        files: ['src/tpl/**/*.{md,hbs,html}']
        tasks: ['html']


  # DEPS / REGISTER
  # ============================================================================
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks
  grunt.loadNpmTasks 'assemble'

  grunt.registerTask 'live', ['connect:basic','watch']

  grunt.registerTask 'libs', ['modernizr']
  grunt.registerTask 'assets', ['clean:assets','clean:css','copy:assets']

  grunt.registerTask 'css', ['assets','compass:compile']
  grunt.registerTask 'js', ['clean:js','clean:tpl','libs','copy:libs','requirejs:compile']
  grunt.registerTask 'html', ['clean:html','assemble:pages']

  grunt.registerTask 'build', ['clean:all','libs','jshint','js','css','html']
  grunt.registerTask 'snapshot', ['build', 'compress:build']

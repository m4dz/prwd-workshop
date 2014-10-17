module.exports = (grunt) ->

  # HELPERS
  # ============================================================================
  getDeployMessage = ->
    if not process.env.TRAVIS
      return """
             missing env vars for travis-ci
             """

    return """
           Branch: #{ process.env.TRAVIS_BRANCH }
           SHA: #{ process.env.TRAVIS_COMMIT }
           Range SHA: #{ process.env.TRAVIS_COMMIT_RANGE }
           Build id: #{ process.env.TRAVIS_BUILD_ID }
           Build number: #{ process.env.TRAVIS_BUILD_NUMBER }
           """

  getBuildPrefix = ->
    if process.env.TRAVIS_PULL_REQUEST isnt 'false' then process.env.TRAVIS_PULL_REQUEST else process.env.TRAVIS_BRANCH

  getBuildPath = ->
    path = ['build']
    path.push getBuildPrefix() if process.env.TRAVIS is 'true' and process.env.TRAVIS_SECURE_ENV_VARS is 'true'
    path.join('/') + '/'

  registerTracks = ->
    opts =
      cwd: 'build/'
    content =
      branches: grunt.file.expand(opts, ['*','!_data','!css'])
    grunt.file.write('src/tpl/_data/tracks.json', JSON.stringify(content))

  pageurl = "http://m4dz.github.io/prwd-workshop/#{getBuildPrefix()}/index.html"


  # TASKS
  # ============================================================================
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    # Cleaning
    # --------
    clean:
      tpl    : ["src/js/templates/**/*.js"]
      js     : ["#{getBuildPath()}js/"]
      css    : ["#{getBuildPath()}css/"]
      html   : ["#{getBuildPath()}*.html"]
      assets : ["#{getBuildPath()}fonts/","#{getBuildPath()}img/","#{getBuildPath()}*.{ico,png}"]
      all    : ["#{getBuildPath()}","src/templates/**/*.js"]

    # Copying
    # -------
    copy:
      assets:
        expand : true
        cwd    : 'src/'
        src    : ['files/**', 'fonts/**','images/**','*.{png,ico}']
        dest   : getBuildPath()
      libs:
        expand : true
        cwd    : 'src/'
        src    : ['js/lib/**']
        dest   : getBuildPath()
      themecss:
        expand : true
        cwd    : 'src/'
        src    : ['css/**']
        dest   : getBuildPath()
      themejs:
        expand : true
        cwd    : 'src/'
        src    : ['js/**']
        dest   : getBuildPath()
      data:
        expand : true
        cwd    : 'build/_data/'
        src    : ['*.json']
        dest   : 'src/tpl/_data/'

    rename:
      pagespeed:
        files:[
          src: ['reports/json/desktop.json']
          dest: "build/_data/pagespeed_#{getBuildPrefix()}.json"
        ]
      loadreport:
        files:[
          src: ['reports/loadreport.json']
          dest: "build/_data/loadreport_#{getBuildPrefix()}.json"
        ]

    # Assembling
    # ----------
    assemble:
      options:
        assets    : "#{getBuildPath()}"
        data      : ['src/tpl/_data/**/**/*.{json,yml}','package.json'],
        helpers   : ['src/tpl/_helpers/**/*.js','node_modules/prettify/prettify.js']
        partials  : ['src/tpl/_includes/**/*.{md,html,hbs}','src/tpl/pages/**/*-ajax-*.{md,html,hbs}','src/tpl/pages/**/pop-*.{md,html,hbs}']
        layoutdir : 'src/tpl/_layouts'
        layoutext : '.hbs'
        # Prettify helpers configuration
        prettify:
          indent   : 2
          condense : true
          newlines : true
      pages:
        files: [{
          expand : true
          cwd    : 'src/tpl/pages/'
          src    : ['**/*.{md,html,hbs}']
          dest   : getBuildPath()
          ext    : '.html'
        }]
      index:
        files: [{
          expand : true
          cwd    : 'src/tpl/'
          src    : ['index.hbs']
          dest   : getBuildPath()
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
      files: ['src/js/**/*.js','!src/js/**/lib/**/*.js']

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
        outputFile : "#{getBuildPath()}js/lib/modernizr.js"
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
          cwd: getBuildPath()
          src: ['**', '!files/*.{m4v,ogv,webm}']
          dest: './'
        }]

    # Continuous Deploy
    #------------------
    'gh-pages':
      options:
        branch: 'gh-pages'
        base: 'build'
      deploy:
        options:
          user:
            name: 'Travis for m4dz'
            email: 'code@m4dz.net'
          repo: "https://#{process.env.GH_TOKEN}@github.com/m4dz/prwd-workshop.git"
          message: """
                   deploy to gh-pages (auto)
                   #{getDeployMessage()}
                   """
          silent: true
        src: ['**/*']


    # Test / Perfs
    # ------------
    pagespeed_report:
      desktop:
        options:
          reporters: ['json']
          key: process.env.GAPI_TOKEN
          url: pageurl
          locale: 'en_US'
          strategy: 'desktop'
          threshold: 80
          dest: 'reports'

    exec:
      loadreport:
        cmd: ->
          binPath = require('phantomjs').path
          loadreportPath = require('loadreport').load_reports
          "#{binPath} #{loadreportPath} #{pageurl} performance json"

      loadcache:
        cmd: ->
          cmd  = 'git remote add gh git://github.com/m4dz/prwd-workshop.git;'
          cmd += 'git fetch gh;'
          cmd += 'git read-tree --prefix=build/ -u gh/gh-pages;'


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
        files: ['src/scss/**/*.scss', 'src/css/**/*.css']
        tasks: ['assets', 'compass:watch', 'copy:themecss']
      js:
        files: ['src/js/templates/**/*.tpl','src/js/**/*.js']
        tasks: ['js']
      html:
        files: ['src/tpl/**/*.{md,hbs,html}']
        tasks: ['html']


  # DEPS / REGISTER
  # ============================================================================
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks
  grunt.loadNpmTasks 'assemble'

  grunt.registerTask 'libs', ['modernizr','copy:libs']
  grunt.registerTask 'assets', ['clean:assets','clean:css','copy:assets']

  grunt.registerTask 'css', ['assets','compass:compile','copy:themecss']
  grunt.registerTask 'js', ['clean:js','clean:tpl','libs','jshint','copy:themejs']
  grunt.registerTask 'html', ['clean:html','assemble:pages']

  grunt.registerTask 'pagespeed', ['pagespeed_report','rename:pagespeed']
  grunt.registerTask 'loadreport', ['exec:loadreport','rename:loadreport']

  grunt.registerTask 'live', ['connect:basic','watch']
  grunt.registerTask 'build', ['clean:all','js','css','html']
  grunt.registerTask 'snapshot', ['build','compress:build']

  grunt.registerTask 'travis-deploy', ->
    this.requires ['exec:loadcache']
    this.requires ['build']
    if process.env.TRAVIS is 'true' and process.env.TRAVIS_SECURE_ENV_VARS is 'true'
      grunt.log.writeln 'deploy'
      grunt.task.run 'gh-pages:deploy'
      grunt.task.run 'pagespeed'
      grunt.task.run 'loadreport'
      grunt.task.run 'copy:data'
      registerTracks()
      # grunt.task.run 'assemble:index'
      grunt.task.run 'gh-pages:deploy'
    else
      grunt.log.writeln 'skip deploy'

  grunt.registerTask 'deploy', ['exec:loadcache','build','travis-deploy']

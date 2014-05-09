
module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  APP_PATH = "app"
  ASSETS_PATH = "app/assets/"
  WEBAPP_PATH = "app/assets/webapp/"

  grunt.initConfig
    compass:
      dev:
        options:
          sassDir:"./app/assets/sass/"
          cssDir:"./public/assets/css/"
          noLineComments:true
          outputStyle:"nested"
    clean:
      public:["./public/assets/"]
      tmp:[".tmp"]
    express:
      options:
        cmd: './node_modules/.bin/coffee'
      dev:
        options:
          node_env:'development'
          debug: false
          port:4100
          script: "./app/main.coffee"
      debug:
        options:
          node_env:'development'
          debug: true
          port:4100
          script: "./app/main.coffee"
      mochaTest:
        test:
          options:
            reporter: 'spec'
            clearRequireCache: true
            require: 'coffee-script/register'
            src: [
                  "test/app/start.coffee"
                    "test/app/**/*_spec.coffee"
                    "test/app/finish.coffee"
                ]
        testlib:
          options:
            reporter:'nyan'
            clearRequireCache: true
            require: 'coffee-script/register'
            src:[
              'test/lib/**/*_spec.coffee'
            ]
    coffee:
      base:
        options:
          bare:false
          assets:
            files:
              "public/assets/js/main-home.js":[
                "app/assets/scripts/main-home.coffee"
              ]
              "public/assets/js/ie-support.js":[
                "app/assets/scripts/ie-support.coffee"
              ]
      webapp:
        options:
          bare:true
        assets:
          files:
            ".tmp/webapp/webapp.js":[
               "./app/assets/webapp/webapp.coffee"
               ,"./app/assets/webapp/**/*.coffee"
            ]
    ngmin:
      webapp:
        src:[".tmp/webapp/webapp.js"]
        dest:".tmp/webapp/webapp-ngmin.js"
    uglify:
      lib:
        options:
          mangle:false
          compress:false
        files:
          "./public/assets/js/libraries.js":[
            "./bower_components/jquery/dist/jquery.js"
          ]
      webapp:
        options:
          mangle:false
          compress:false
        files:
          "./public/assets/js/webapp.js":[
            ".tmp/webapp/webapp-ngmin.js"
          ]
    jade:
      server:
        files:[
          expand:true
          cwd:"./pages/src/"
          src:"**/*.jade"
          dest:"./pages/dest/"
          ext:".html"
        ]
      webapp:
        files:[
          expand:true
          cwd:"./app/assets/webapp/views"
          src:["**/*.jade"]
          dest:"./public/assets/scripts/webapp/views/"
          ext:".html"
        ]
    sass:
      assets:
        files:
          "public/assets/css/main.css":[
            "app/assets/stylesheets/base.scss"
          ]
    watch:
      options:
        livereload: true
      sass:
        files:["#{APP_PATH}/assets/scss/**/*.scss"]
        tasks:["compass:dev"]
      server:
        files: ["#{APP_PATH}/**/*.coffee", "#{APP_PATH}/**/*.jade","!#{APP_PATH}/assets"]
        tasks: ["express:dev", 'delay']
        options:
          spawn:false
      webappjs:
        files:["#{WEBAPP_PATH}/**/*.coffee","#{WEBAPP_PATH}/assets/**/*.jade"]
        tasks: ['build-webapp']
      testlib:
        files:["test/lib/**/*_spec.coffee"]
        tasks:['mochaTest:testlib']

  grunt.registerTask 'delay', 'delay', ->
    delayPeriod = 1000
    grunt.log.write "delay for #{delayPeriod} ms\n"
    done = @async()
    delay = ->
      console.log 'delay completed\n'
      done()
    setTimeout delay, delayPeriod

  grunt.registerTask 'cleaning'     , ['clean:public','clean:tmp']
  grunt.registerTask 'build-scss'   , ['compass:dev']
  grunt.registerTask 'build-jslib'  , ['uglify:lib']
  grunt.registerTask 'build-webapp' , ['coffee:webapp','ngmin:webapp','uglify:webapp','jade:webapp','clean:tmp']
  grunt.registerTask 'testlib'      , ['mochaTest:testlib','watch:testlib']
  grunt.registerTask 'default'      , ['cleaning','build-scss','build-jslib','build-webapp','express:dev','watch','delay']
  grunt.registerTask 'debug'        , ['express:debug','watch','delay']

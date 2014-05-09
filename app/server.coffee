express = require 'express'
moment = require 'moment'
mongoose = require 'mongoose'
dbconf = require process.cwd()+"/app/database/database-local"

class Server
    constructor: ->
        @app = express()
        @_setupDB()
        @_setupPassport()
        @_createApp()
        @_setRoute()
    _setupDB: ->
        app  = @app
        mongoose.connect "mongodb://#{dbconf.mongo.host}/#{dbconf.mongo.database}"
        app.set 'mongoose',mongoose
    _setupPassport: ->
        app = @app
    _createApp: ->
        app = @app
        app.set 'port', process.env.PORT || 3200
        app.set 'view engine', 'jade'
        app.set 'views','./app/views'
        env = process.env.NODE_ENV || 'development'
        if( env == 'development')
            app.use(require('connect-livereload')())
            app.use('/public',require('serve-static')('public'))
            app.locals.pretty = true

        app.locals.moment = moment
        app.use(require('cookie-parser')())
        app.use(require('body-parser')())
        app.use(require('express-session')(
            secret:"KSj&djsm##"
        ))
    _setRoute: ->
        app = @app
        app.use(require('body-parser')())
        app.use "/", require("./routes")(app)
    start:(callback) ->
        app = @app
        app.listen app.get('port'), ->
            callback.call null, app, nodeserver if callback?
            console.log "Express #{process.env.NODE_ENV} server is up on port #{app.get('port')} at #{new Date()}"
            callback && callback.call null, nodeServer

exports = module.exports = Server

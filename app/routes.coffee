express = require "express"

_homectr= null

class AppRoute
  constructor: (app) ->
    router = express.Router()
    @passport = app.get 'passport'
    @router = router
    @app = app
    @_setController()
    @_setRoute()
  _setController: ->
    app = @app
    _homectr = require("./controllers/home")(app)
  _setRoute: ->
    router = @router
    passport = @passport

    router.get( "/", _homectr.getHomeIndex)

exports = module.exports = (app) ->
  approute = new AppRoute(app)
  return approute.router

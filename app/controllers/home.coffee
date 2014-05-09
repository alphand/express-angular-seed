
class HomeController
  constructor:(app)->
  getHomeIndex:(req, res)->
    res.render("home/index")

module.exports = exports = (app)->
  homectr = new HomeController(app)
  homectr

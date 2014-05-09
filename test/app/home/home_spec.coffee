chai = require "chai"
expect = chai.expect
Server = require process.cwd()+"/app/server"
Browser = require "zombie"

chai.should()
#server = new Server()
#server.start()

describe "App", ->
	before(()->
		@server = new Server()
		@browser = new Browser(
			site:'http://localhost:3200'
		)
		@server.start()
	)
	before((done)->
		@browser.visit('/',done)
	)

	it 'should exists', (done) ->
		@server.app.should.exist
		done()
	
	it 'should show homepage', (done) ->
		@browser.visit('/',done)
			.then( ->
				@browser.text("H1").should.contains("HELLO")
				done()
			)

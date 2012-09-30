require('lib/setup')

Spine   = require('spine')

Authorization = require('authorization')

# Models
Feed = require('models/feed')
MyCollection = require('models/my_collection')
Friend = require('models/friend')

# Controllers
#Manager = require('spine/lib/manager')
Config = require('controllers/config')
Controller = require('controllers/controller')
Main = require('controllers/main')
Sidebar = require('controllers/sidebar')

Spine.Model.host = Config.host
Spine.Ajax.defaults.headers['X-Version'] = Config.version

class App extends Spine.Controller

  constructor: ->
    super
    Authorization.setup()
    return Authorization.login() unless Authorization.is_loggedin()

    @sidebar = new Sidebar
    @main    = new Main

    $('body').keydown (e) -> Spine.trigger('keypress', e)

    @routes
      '/': (params) -> @sidebar.active(params)

    @append @sidebar, @main
    Spine.Route.setup()

    Feed.fetch()
    MyCollection.fetch()
    Friend.fetch()

module.exports = App
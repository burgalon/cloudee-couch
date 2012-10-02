Authorization = require('authorization')

# Models
Feed = require('models/feed')
MyCollection = require('models/my_collection')
Friend = require('models/friend')

Main = require('controllers/main')
Sidebar = require('controllers/sidebar')
Files = require('controllers/files')

class MainWrapper extends Spine.Controller
  className: 'main-wrapper'

  constructor: ->
    super
    Authorization.setup()
    return Authorization.login() unless Authorization.is_loggedin()

    @sidebar = new Sidebar
    @main = new Main
    @files = new Files

    $('body').keydown (e) -> Spine.trigger('keypress', e)

    @routes
      '/': (params) -> @sidebar.active(params)
      '/collection/:id': (params) -> @files.active(params)

    @append @sidebar, @main, @files

    Feed.fetch()
    MyCollection.fetch()
    Friend.fetch()

module.exports = MainWrapper
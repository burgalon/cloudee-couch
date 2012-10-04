require('lib/setup')

Spine   = require('spine')
Authorization = require('authorization')

# Controllers
MainWrapper = require('controllers/main_wrapper')
Player = require('controllers/player')

Config = require('controllers/config')

Spine.Model.host = Config.host
Spine.Ajax.defaults.headers['X-Version'] = Config.version

class App extends Spine.Stack
  className: ''
  controllers:
    player: Player
    mainWrapper: MainWrapper

  routes:
    '/': 'mainWrapper'
    '/file/:id/play': 'player'

  default: 'mainWrapper'

  constructor: ->
    Authorization.setup()
    return Authorization.login() unless Authorization.is_loggedin()
    boxeeAPI.keyboardMode();
    boxeeAPI.hookMenuToEsc();
    super
    @navigate '/'
    Spine.Route.setup()

module.exports = App
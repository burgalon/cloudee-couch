require('lib/setup')

Spine   = require('spine')

# Controllers
MainWrapper = require('controllers/main_wrapper')
Player = require('controllers/player')

Config = require('controllers/config')

Spine.Model.host = Config.host
Spine.Ajax.defaults.headers['X-Version'] = Config.version

class App extends Spine.Stack
  controllers:
    mainWrapper: MainWrapper
    player: Player

  routes:
    '/': 'mainWrapper'
    '/file/:id/play': 'player'

  default: 'mainWrapper'

  constructor: ->
    super
    @navigate '/'
    Spine.Route.setup()

module.exports = App
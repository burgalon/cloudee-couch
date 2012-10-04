Controller = require('./controller')

# models
File = require('models/file')

class Player extends Controller
  className: 'player'
  elements:
    'video': 'player'
  constructor: ->
    super
    @active @change

  render: ->
    @html require('views/player')(@file)
    @player[0].play()

  blur: ->
    app.mainWrapper.activate()

  change: (params) =>
    @file = File.exists(params.id)
    console.log 'file', @file.name
    @render()

module.exports = Player
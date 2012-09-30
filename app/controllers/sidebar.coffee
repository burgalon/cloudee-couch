Controller = require('./controller')

class Sidebar extends Controller
  className: 'sidebar'

  constructor: ->
    super
    @render()

  render: ->
    @html require('views/sidebar')(@item)

  right: ->
    @enter()
module.exports = Sidebar
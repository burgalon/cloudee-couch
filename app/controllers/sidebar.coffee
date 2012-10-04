Controller = require('./controller')
Authorization = require('authorization')

class Sidebar extends Controller
  className: 'sidebar panel'

  constructor: ->
    @elements['.logout'] = 'logout'
    super
    @render()
    @logout.click Authorization.logout

  render: ->
    @html require('views/sidebar')(@item)
    super

  right: ->
    @enter()
module.exports = Sidebar
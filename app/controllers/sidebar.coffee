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

  # Update the panels without needing to press ENTER
  down: ->
    super
    Spine.Route.matchRoute(@selectedEl().attr('href').substring(1)) if @selectedIndex<3
    Spine.Route.matchRoute '/'

  up: ->
    super
    Spine.Route.matchRoute(@selectedEl().attr('href').substring(1)) if @selectedIndex<3
    Spine.Route.matchRoute '/'


module.exports = Sidebar
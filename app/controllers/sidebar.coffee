Controller = require('./controller')
Authorization = require('authorization')

class Sidebar extends Controller
  className: 'sidebar'

  constructor: ->
    @elements['.quit'] = 'quit'
    @elements['.logout'] = 'logout'
    super
    @render()
    @quit.click @doQuit
    @logout.click Authorization.logout

  doQuit: =>
    @log 'doQuit'
    if window.boxee?.fake
      window.close()
    else
      boxeeAPI.closeApp()



  render: ->
    @html require('views/sidebar')(@item)
    super

  right: ->
    @enter()
module.exports = Sidebar
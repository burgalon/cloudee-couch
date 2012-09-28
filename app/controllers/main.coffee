Spine = require('spine')
List = require('spine/lib/list')
Controller = require('./controller')

# Models
Feed = require('models/feed')

class ListWrapperController extends Controller
  template: -> throw 'Override template'
  wrapperTemplate: -> throw 'Override wrapperTemplate'

  elements:
    '.items': 'items'

  constructor: ->
    super
    @html require(@wrapperTemplate)
    @list = new List
      el: @items
      template: require(@template)
    @render()
    @model.bind 'refresh', @change if @model

  render: ->
    @list.render(@data())

  change: =>
    @render()

  data: ->
    @model.all()

class Collections extends ListWrapperController
  className: 'collections'
  wrapperTemplate: 'views/collections'
  template: 'views/collection'
  data: ->
    [{name: 'Vacation Videos'}, {name: 'All Boxee Videos'}]

class Activity extends ListWrapperController
  className: 'activity'
  wrapperTemplate: 'views/activity'
  template: 'views/feed'
  model: Feed

class Friends extends ListWrapperController
  className: 'friends'
  wrapperTemplate: 'views/friends'
  template: 'views/user'
  data: ->
    [{name: 'Alon Burg'}, {name: 'Jose Saramago'}]

class Main extends Spine.Stack
  className: 'main stack'

  controllers:
    activity: Activity
    collections: Collections
    friends: Friends

  routes:
    '/activity': 'activity'
    '/collections': 'collections'
    '/friends': 'friends'

  default: 'activity'

module.exports = Main
Spine = require('spine')
List = require('spine/lib/list')
Controller = require('./controller')

# Models
Feed = require('models/feed')
MyCollection = require('models/my_collection')
Friend = require('models/friend')

class ListWrapperController extends Controller
  template: -> throw 'Override template'
  wrapperTemplate: -> throw 'Override wrapperTemplate'

  constructor: ->
    @elements['.items'] = 'items'
    super
    @html require(@wrapperTemplate)
    @list = new List
      el: @items
      template: require(@template)
    @render()
    @model.bind 'refresh', @change if @model

  render: ->
    @list.render(@data())
    super

  change: =>
    @render()

  data: ->
    @model.all()

  select: ->
    super
    selectedElOffset = @selectedEl().offset().top
    if selectedElOffset + @selectedEl().height() > @el.height() || selectedElOffset<0
      @el.animate({
        scrollTop: @el.scrollTop()+selectedElOffset
      }, 200);

class Collections extends ListWrapperController
  className: 'collections'
  wrapperTemplate: 'views/collections'
  template: 'views/collection'
  model: MyCollection

class Activity extends ListWrapperController
  className: 'activity'
  wrapperTemplate: 'views/activity'
  template: 'views/feed'
  model: Feed

class Friends extends ListWrapperController
  className: 'friends'
  wrapperTemplate: 'views/friends'
  template: 'views/user'
  model: Friend

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
Spine = require('spine')
Controller = require('./controller')
ListWrapperController = require('./list_wrapper_controller')

# Models
Feed = require('models/feed')
MyCollection = require('models/my_collection')
Friend = require('models/friend')

class Collections extends ListWrapperController
  className: 'collections panel'
  wrapperTemplate: 'views/collections'
  template: 'views/collection'
  model: MyCollection

# Feed panel
class Activity extends ListWrapperController
  className: 'activity panel'
  wrapperTemplate: 'views/activity'
  template: 'views/feed'
  model: Feed
  paginatedIndex: 0

  select: ->
    super
    if @selectedIndex > @paginatedIndex && @selectedIndex > @model.all().length - (Feed.PAGINATION_LIMIT * 0.25) && !@stopPaginating
      @paginatedIndex = @model.all().length
      @model.fetch(data: {before_id: @model.last().id})
      @model.one 'refresh', =>
        @stopPaginating = true if @model.all.length % Feed.PAGINATION_LIMIT != 0

class Friends extends ListWrapperController
  className: 'friends panel'
  wrapperTemplate: 'views/friends'
  template: 'views/user'
  model: Friend

# Panels stack helps make sure that only one panel is shown each time
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
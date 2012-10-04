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

class Activity extends ListWrapperController
  className: 'activity panel'
  wrapperTemplate: 'views/activity'
  template: 'views/feed'
  model: Feed

class Friends extends ListWrapperController
  className: 'friends panel'
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
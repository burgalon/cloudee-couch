User = require('models/user')
Collection = require('models/collection')

class Friend extends User
  @extend Spine.Model.Ajax
  @url: ->
    Spine.Model.host + '/users/friends_collections'


  load: (atts) ->
    for key, value of atts
      if typeof @[key] is 'function'
        @[key](value)
      else
        if key=='collections'
          @collections = value.map (collection) ->
            Collection.exists(collection.id) || Collection.refresh([collection]).find(collection.id)
        else
          @[key] = value
    this


module.exports = Friend
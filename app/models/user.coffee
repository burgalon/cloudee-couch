Model = require('./model')
Collection = require('./collection')

class User extends Model
  @configure 'User', 'name', 'images', 'collections'
  firstName: ->
    @name.split(' ')[0]
  picture: ->
    @images.normal

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


module.exports = User

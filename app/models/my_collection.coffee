Collection = require('./collection')

class MyCollection extends Collection
  @extend Spine.Model.Ajax
  @url: ->
    Spine.Model.host + '/users/editable_collections'

  @fromJSON: (objects) ->
    objects = objects.owned
    super


module.exports = MyCollection
User = require('models/user')
Collection = require('models/collection')

class Friend extends User
  @configure 'Friend'
  @extend Spine.Model.Ajax
  @url: ->
    Spine.Model.host + '/users/friends_collections'

module.exports = Friend
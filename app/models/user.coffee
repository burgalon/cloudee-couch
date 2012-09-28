Model = require('./model')

class User extends Model
  @configure 'User', 'name', 'images'
  firstName: ->
    @name.split(' ')[0]
  picture: ->
    @images.normal

module.exports = User

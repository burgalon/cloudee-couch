Config = require('controllers/config')
Model = require('./model')
File = require('./file')

class Collection extends Model
  PAGINATION_LIMIT = 25
  @configure 'Collection', 'id', 'name', 'image_hash', 'files_count', 'created_at_ago'
  @extend Spine.Model.Ajax
  @url: ->
    Spine.Model.host + '/collections'

  couchUrl: ->
    '/collection/'+@id

  thumb: ->
    if Config.env == 'development'
      return "http://assets.cloudee.com/media/BAhbCFsHOgZmSSI5bWVkaWFfZmlsZS80Zjk5OWNjOTdkNDBiMTQxNWUwMDAyZWMvaS8xL21hc3Rlci8yLmpwZwY6BkVUWwg6BnA6CnRodW1iSSIOMzA2eDE3NCNuBjsGRlsHOgZlOghqcGc.jpg"
    @image_hash.medium

  load: (atts) ->
    for key, value of atts
      if typeof @[key] is 'function'
        @[key](value)
      else
        if key=='user'
          User = require('models/user')
          @user = User.exists(value.id) || User.refresh([value]).find(value.id)
        else if key=='files'
          @files = value.map (file) ->
            File.exists(file.id) || File.refresh([file]).find(file.id)
        else
          @[key] = value
    this


module.exports = Collection

Config = require('controllers/config')
Model = require('./model')

class Collection extends Model
  @configure 'Collection', 'name', 'image_hash'
  thumb: ->
    if Config.env == 'development'
      return "http://assets.cloudee.com/media/BAhbCFsHOgZmSSI5bWVkaWFfZmlsZS80Zjk5OWNjOTdkNDBiMTQxNWUwMDAyZWMvaS8xL21hc3Rlci8yLmpwZwY6BkVUWwg6BnA6CnRodW1iSSIOMzA2eDE3NCNuBjsGRlsHOgZlOghqcGc.jpg"
    @image_hash.medium

module.exports = Collection

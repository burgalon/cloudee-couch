Model = require('./model')

class File extends Model
  @configure 'File', 'name', 'image_hash', 'location', 'recorded_at_ago'
  thumb: ->
    @image_hash.medium
  fallbackName: ->
    @name || ('from ' + @location)
module.exports = File

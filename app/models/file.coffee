Model = require('./model')

class File extends Model
  @configure 'File', 'name', 'image_hash', 'location', 'recorded_at_ago', 'runtime', 'file_url'
  thumb: ->
    @image_hash.medium
  fallbackName: ->
    @name || ('from ' + @location)

  couchUrl: ->
    "/file/#{@id}/play"

module.exports = File

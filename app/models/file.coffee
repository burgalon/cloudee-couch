Model = require('./model')

class File extends Model
  @configure 'File', 'name', 'image_hash', 'location', 'recorded_at_ago', 'runtime', 'file_url'
  thumb: ->
    @image_hash.medium
  fallbackName: ->
    name = @name || ('from ' + @location)
    if name.length > 30 then name.substring(0, 30) + '...' else name

  couchUrl: ->
    "/file/#{@id}/play"

module.exports = File

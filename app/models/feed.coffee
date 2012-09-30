#Model = require('./model')
Spine = require('spine')
Model = require('./model')

# Models
User = require('models/user')
Collection = require('models/collection')
File = require('models/file')

# Constants
VERBS =
  'JoinFeed': 'joined'
  'ShareFileListFeed': 'shared colleciton'
  'AddedFeed': 'added'
  'ShareFileFeed': 'shared'
  'CommentFeed': 'commented'
  'LikeFeed': 'liked'
  'UploadFeed': 'uploaded'

class Feed extends Model
  @configure 'Feed', 'type', 'created_at_ago'
  #, 'user', 'collection', 'files'

  @extend Spine.Model.Ajax
  @url: ->
    Spine.Model.host + '/users/feeds'

  @fromJSON: (objects) ->
    objects = objects.feed
    super

  load: (atts) ->
    for key, value of atts
      if typeof @[key] is 'function'
        @[key](value)
      else
        if key=='user'
          @user = new User(value)
        else if key=='collection'
          @collection = Collection.exists(value.id) || Collection.refresh([value]).find(value.id)
        else if key=='file'
          @file = File.exists(value.id) || File.refresh([value]).find(value.id)
        else if key=='files'
          @files = value.map (file) ->
            File.exists(file.id) || File.refresh([file]).find(file.id)
        else
          @[key] = value
    this

  verb: ->
    VERBS[@type]

module.exports = Feed

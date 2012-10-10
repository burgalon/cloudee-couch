Controller = require('./controller')

# models
File = require('models/file')

class Player extends Controller
  className: 'player'
  seekTime: 3
  backIndex: 0
  elements:
    'video': 'player'
    '.up-next': 'upNext'
    '.time': 'time'
    '.controls': 'controls'
    '.duration': 'duration'
    '.time-bar': 'timeBar'
    '.scrubber': 'scrubber'

  constructor: ->
    super
    @active @change
    @html require('views/player')
    @video = @player[0]
    @player.bind 'play', @onPlay
    @player.bind 'pause', @onPause
    @player.bind 'ended', @onEnded
    @player.bind 'seeking', @onSeeking
    @player.bind 'seeked', @onSeeked
    @player.bind 'timeupdate', @onTimeUpdate

    @player.bind 'boxee:play', @onBoxeePlay
    @player.bind 'boxee:pause', @onBoxeePause

  render: ->
    # Load new source url
    @video.src = @file.video_url
    @video.load()
    @upNext.html require('views/file')(@file)
    @video.play()

    # Update UI
    @setVideoDuration(@file.runtime_seconds)
    # Set seeking jump interval depending on the video length with a maximum of 28 seconds and minimum of 3 seconds
    @seekTime = Math.min(25, @file.runtime_seconds / 60) + 3
    @fadeIn()

  # This is necessary since the player may play sequentially one video after another, and so back will just
  # get us to the last playbacked movie instead of the navigation
  navigateBack: ->
    history.go(@backIndex)

  blur: (newController) ->
    @backIndex = 0 if newController!=@
    app.mainWrapper.activate()

  # Called when new video is loaded
  change: (params) =>
    # See @navigateBack() comment
    @backIndex = @backIndex - 1
    return true if @file && @file.id == params.id && !@video.paused
    @file = File.exists(params.id)
    @render()

  togglePlayback: ->
    if @video.paused then @video.play() else @video.pause()

  enter: ->
    @togglePlayback()

  space: ->
    @togglePlayback()

  ## Event handlers
  onBoxeePlay: =>
    @togglePlayback()

  onBoxeePause: =>
    @togglePlayback()

  onPlay: =>
    @el.removeClass 'paused ended seeking'
    @player.one 'timeupdate', =>
      @fadeOut()

  onPause: =>
    @el.addClass 'paused'
    @el.removeClass 'ended'
    @fadeIn()

  onEnded: =>
    @el.addClass 'ended'
    @el.removeClass 'ended'
    @fadeIn()
    if @isFocused()
      @log 'triggering playEnded'
      Spine.trigger 'playEnded'

  onSeeking: =>
    @el.addClass 'seeking'
    @fadeIn()

  onSeeked: =>
    @el.removeClass 'seeking'
    @fadeOut()

  # Called when video playback progresses
  onTimeUpdate: =>
    # Set digits
    @setVideoTime @video.currentTime

    # Update bars
    duration = (if @video.currentTime > @currentTime then null else 0)
    @currentTime = @video.currentTime
    @timeBar.stop().animate(width: @video.currentTime/@video.duration * (900 - 34 / 2) + 34 / 2, duration)
    @scrubber.stop().animate(left: @video.currentTime/@video.duration * 900 - 34 / 2 + (1280 - 900) / 2, duration)


  ## Video helpers
  fadeIn: ->
    clearTimeout(@timerId) if @timerId
    @controls.fadeIn()

  fadeOut: ->
    @timerId = setTimeout (=> @controls.fadeOut() unless @video.paused), 2000

  left: ->
    @seekTo @video.currentTime - @seekTime

  right: ->
    @seekTo @video.currentTime + @seekTime

  # Prevent default behaviour
  up: ->
  down: ->
    
  seekTo: (time) ->
    time = @video.duration - 1 if time >= @video.duration
    time=0 if @time<0
    return if time==@video.currentTime
    @video.currentTime = time

  formatSeconds: (s) ->
    total = parseInt(s)
    return "00:00:00"  if isNaN(total) or total < 0
    seconds = total % 60
    total = total - seconds
    minutes = total % (60 * 60)
    minutes = minutes / 60
    total = total - (minutes * 60)
    minutes = "0" + minutes  if minutes < 10
    seconds = "0" + seconds  if seconds < 10

    hours = total / (60 * 60)
    if hours == 0
      return minutes + ":" + seconds
    hours = "0" + hours  if hours < 10
    return hours + ":" + minutes + ":" + seconds

  setVideoTime: (seconds) =>
    @time.html @formatSeconds(seconds)

  setVideoDuration: (seconds) =>
    @duration.html @formatSeconds(seconds)

module.exports = Player
Spine = require('spine')
App = require('../index')

focusedController = null;

# Base controller which adds support for keyboard handling
# and managing one focused panel each time
class Controller extends Spine.Controller
  selectedIndex: 0
  selected: false
  elements:
    '.f': 'els'

  events:
    'click .f': 'click'

  constructor: ->
    super
    Spine.bind 'keypress', @keypress
    @bind 'left', @left
    @bind 'right', @right
    @bind 'down', @down
    @bind 'up', @up
    @bind 'enter', @enter
    @bind 'esc', @esc
    @bind 'space', @space

    @bind 'blur', @blur
    @bind 'focus', @focus

    # Manage only one controller each time in focus
    @active ->
      if focusedController
        focusedController.trigger('blur', @)
        $('body').removeClass focusedController.className.split(' ')[0]+'-wrapper'
      focusedController = @
      $('body').addClass focusedController.className.split(' ')[0]+'-wrapper'
      focusedController.trigger('focus')

  click: (e) ->
    return unless @isFocused()
    @deselect()
    @selectedIndex =  @els.index(e.currentTarget)
    @select()
    @enter()

  # Remove focus class from the panel
  blur: ->
    @el.removeClass('focus')

  # Add focus class to the panel
  focus:->
    @el.addClass('focus')

  # Helper to determine if current panel is in focus and should handle keyboard events
  isFocused: ->
    focusedController == @

  render: ->
    # Sometime this is needed since a subview is rendered and so refreshElements is not called
    # like in the case of ListWrapper
    @refreshElements()
    # Set focus on first element
    @select() if @els?.length

  # Returns the currently selected element in the list
  selectedEl: ->
    $(@els[@selectedIndex])

  # Adds 'select' class to the currently selected class in the list
  select: ->
    @selectedEl().addClass('select')

  # Remove 'select' class to the currently selected class in the list
  deselect: ->
    @selectedEl().removeClass('select')

  # Moves selection to the next element in the list
  nextSelect: ->
    @selectedIndex+=1 if @selectedIndex<@els.length-1

  # Moves selection to the previous element in the list
  prevSelect: ->
    @selectedIndex-=1 if @selectedIndex>0

  # Fires specific keypresses events
  keypress: (e) =>
    return true unless isFocused()
    @trigger 'left' if e.keyCode==37
    @trigger 'space' if e.keyCode==32
    @trigger 'right' if e.keyCode==39
    @trigger 'down' if e.keyCode==40
    @trigger 'up' if e.keyCode==38
    @trigger 'enter' if e.keyCode==13
    @trigger 'esc' if e.keyCode==27
    return false

  down: ->
#    @log 'down'
    @deselect()
    @nextSelect()
    @select()

  up: ->
#    @log 'up'
    @deselect()
    @prevSelect()
    @select()

  closeWindow: ->
    @log 'closeWindow'
    if window.boxee?.fake
      window.close()
    else
      boxeeAPI.closeApp()

  navigateBack: ->
    if Spine.Route.path=='/'
      @closeWindow()
    else
      history.go(-1)

  left: ->
#    @log 'left'
    @navigateBack()

  right: ->
#    @log 'right'
    @enter()

  esc: ->
    @navigateBack()

  space: ->
    @log 'space'

  enter: ->
#    @log 'enter'
    return true unless @els.length
    href = @selectedEl().attr('href')
    # substr(1) for removing the # from the url
    return @navigate href.substring(1) if href
    # Else
    @selectedEl().trigger 'click'

  log: ->
    console.info.apply console, arguments

module.exports = Controller
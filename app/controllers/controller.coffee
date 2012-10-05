Spine = require('spine')
App = require('../index')

focusedController = null;

class Controller extends Spine.Controller
  selectedIndex: 0
  selected: false
  elements:
    '.f': 'els'

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


  blur: ->
    @el.removeClass('focus')

  focus:->
    @el.addClass('focus')

  isFocused: ->
    focusedController == @

  render: ->
    @refreshElements()
    @select() if @els?.length

  selectedEl: ->
    $(@els[@selectedIndex])

  select: ->
    @selectedEl().addClass('select')

  deselect: ->
    @selectedEl().removeClass('select')

  nextSelect: ->
    @selectedIndex+=1 if @selectedIndex<@els.length-1

  prevSelect: ->
    @selectedIndex-=1 if @selectedIndex>0

  keypress: (e) =>
    return true unless focusedController is @
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
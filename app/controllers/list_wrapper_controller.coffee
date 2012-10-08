List = require('spine/lib/list')

Controller = require('./controller')

class ListWrapperController extends Controller
  template: -> throw 'Override template'
  wrapperTemplate: -> throw 'Override wrapperTemplate'

  constructor: ->
    @elements['.items'] = 'items'
    super
    @html require(@wrapperTemplate)
    @list = new List
      el: @items
      template: require(@template)
    @render()
    @model.bind 'refresh', @change if @model

  render: ->
    @list.render(@data())
    super

  change: =>
    @render()

  data: ->
    @model.all()

  right: ->
    return if @selectedEl().attr('href').indexOf('play')!=-1
    super

  select: ->
    super
    selectedElOffset = @selectedEl().offset().top
    if selectedElOffset + @selectedEl().height() > @el.height() || selectedElOffset<0
      if @selectedIndex
        scrollTop = @el.scrollTop()+selectedElOffset
      else
        scrollTop = 0
      @el.animate({
        scrollTop: scrollTop
      }, 100);

module.exports = ListWrapperController
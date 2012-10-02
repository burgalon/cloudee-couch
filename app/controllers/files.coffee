# Controllers
ListWrapperController = require('./list_wrapper_controller')
Controller = require('./controller')

# Models
Collection = require('/models/collection')

class Files extends Controller
  className: 'files hide'

  constructor: ->
    super
    @active @change
    Collection.bind 'refresh', @render
    @bind 'blur', @blur

  render: =>
    return if !@collectionId
    @collection = Collection.exists(@collectionId)
    return if !@collection || !@collection.user || !@collection.files
    @log 'actually rendering files', @collection.name
    @html require('views/files')(@collection)
    @el.removeClass('hide')
    super

  change: (params) =>
    @collectionId = params.id
    return @log 'no id in params', params unless @collectionId
    @collection = Collection.exists(@collectionId)
    if @collection && @collection.user && @collection.files && (@collection.files_count==@collection.files.length || Collection.PAGINATION_LIMIT==@collection.files.length)
      @log 'load Collection - render'
      @render()
    else
      @log 'load Collection - fetch',@collectionId
      Collection.fetch(id: @collectionId)

  select: ->
    super
    selectedElOffset = @selectedEl().offset().top
    if selectedElOffset + @selectedEl().height() > @el.height() || selectedElOffset<0
      @el.animate({
      scrollTop: @el.scrollTop()+selectedElOffset
      }, 200);

  blur: =>
    @collectionId = null
    @selectedIndex = 0
    @html ''
    @el.addClass('hide')

  navigateBack: ->
    href = $('.sidebar .select').attr('href')
    return @navigate(if href then href.substring(1) else '/activity')

module.exports = Files
File = require('/models/file')

# Controllers
ListWrapperController = require('./list_wrapper_controller')
Controller = require('./controller')

# Models
Collection = require('/models/collection')

class Files extends Controller
  className: 'files hide'
  # Helps keep track of pagination
  paginatedIndex: 0

  constructor: ->
    super
    @active @change
    Collection.bind 'refresh', @render
    @bind 'blur', @blur
    Spine.bind 'playEnded', @playNext

  playNext: =>
    if @el.hasClass('hide')
      @navigateBack()
    if @selectedIndex >= @collection.files_count
      @navigateBack()
    @down()
    @enter()

  render: =>
    return if !@collectionId
    @collection = Collection.exists(@collectionId)
    return if !@collection || !@collection.user || !@collection.files
    @html require('views/files')(@collection)
    @el.removeClass('hide')
    super

  change: (params) =>
    if params.id != @collectionId
      @collectionId = params.id
      @collection = Collection.exists(@collectionId)
      @selectedIndex = 0
      @paginatedIndex = 0

    if @collection && @collection.user && @collection.files && (@collection.files_count==@collection.files.length || Collection.PAGINATION_LIMIT==@collection.files.length)
      @render()
    else
      Collection.fetch(id: @collectionId)

  select: ->
    super
    if @selectedIndex > @paginatedIndex && @selectedIndex > @collection.files.length - (Collection.PAGINATION_LIMIT * 0.25) && @collection.files.length<@collection.files_count
      @paginatedIndex = @collection.files.length
      @collection.loadMoreFiles(@paginatedIndex).success(@render)

    # Scrolling
    selectedElOffset = @selectedEl().offset().top
    if selectedElOffset + @selectedEl().height() > @el.height() || selectedElOffset<0
      @el.animate({
      scrollTop: @el.scrollTop()+selectedElOffset
      }, 50);

  navigateBack: =>
    @el.addClass('hide')
    super

module.exports = Files
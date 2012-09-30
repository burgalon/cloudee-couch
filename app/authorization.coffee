Config = require('./controllers/config')
Spine   = require('spine')
App = require("index")

class Authorization extends Spine.Module
  clientId: Config.clientId
  oauthEndPoint: "#{Config.oauthEndpoint}authorize?client_id=#{@::clientId}&response_type=token&redirect_uri=#{Config.oauthRedirectUri}"

  @setup: ->
    $(document).ajaxError (event, xhr, ajaxSettings, thrownError) =>
      console.log("Global ajaxError", arguments)
      console.log("XHR.status", xhr.status)
      console.log("XHR.responseText", xhr.responseText)
      if xhr.status is 401
        @promptLogin()
      else
        try
          errorData = JSON.parse(xhr.responseText)
          @alert "Network Error: #{xhr.statusText}. #{errorData.message}"
        catch error
          @alert "Network Error: #{xhr.statusText}. #{xhr.responseText}"

    @token = @getToken()
    @setupAjax()

  @setupAjax: ->
    if @token
      Spine.Ajax.defaults.headers['Authorization'] = @token
    else
      delete Spine.Ajax.defaults.headers['Authorization']

  @alert: (msg) ->
    Spine.trigger 'notify', msg: msg

  @saveToken: (token) ->
    localStorage['access_token'] = token if token
    localStorage['access_token'] || null

  @getToken: ->
    token = document.location.hash.match(/access_token=(\w+)/)?[1]
    @saveToken token

  @logout: ->
    @token = null
    delete localStorage['access_token']
    window.location.reload()

  @login: =>
    window.location = @::oauthEndPoint

  @promptLogin: ->
    delete localStorage['access_token']
    @alert "Invalid login. Please sign in again"
    @login()

  @is_loggedin: ->
    !!@token

module.exports = Authorization
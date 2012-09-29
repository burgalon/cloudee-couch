if document.location.href.match(/dev.cloudee.com|localhost|192./)
   # Development
  Config =
    env: 'development'
    host: 'http://dev.cloudee.com:3000/api/v1'
    clientId: 'cloudee-couch-localhost'
    oauthEndpoint: 'http://dev.cloudee.com:3000/oauth/'
    oauthRedirectUri: 'http://dev.cloudee.com:9294'

  # Staging
  Config =
    env: 'staging'
    host: 'http://staging.gomullet.com/api/v1'
    clientId: 'cloudee-couch-localhost'
    oauthEndpoint: 'http://staging.gomullet.com/oauth/'
    oauthRedirectUri: 'http://dev.cloudee.com:9294'

else
  # Production
  Config =
    env: 'production'
    host: 'http://api.cloudee.com/api/v1'
    clientId: 'cloudee-couch'
    oauthEndpoint: 'http://api.cloudee.com/oauth/'
    oauthRedirectUri: 'http://couch.cloudee.com/'

Config['version'] = 0.1
module.exports = Config

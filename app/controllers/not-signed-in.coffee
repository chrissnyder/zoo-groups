BaseController = require './base-controller'

class notSignedIn extends BaseController
  template: require '../views/not-signed-in'

  events:
    'click .sign-in': 'onSignIn'

  constructor: ->
    super
    @html @template()

  onSignIn: (e) ->
    e.preventDefault()
    require('zooniverse/controllers/login-dialog').show()

module.exports = notSignedIn
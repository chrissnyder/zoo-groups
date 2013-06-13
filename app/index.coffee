require './lib/setup'

api = new (require 'zooniverse/lib/api')
(require 't7e').load require './lib/en-us'

# Build app
app = {}
app.container = '#app'
$(app.container).html require('./views/attempt-sign-in')

spinner = new Spinner({width: 3}).spin(document.querySelector app.container)

TopBar = require 'zooniverse/controllers/top-bar'
app.topBar = new TopBar
app.topBar.el.prependTo 'body'

User = require 'zooniverse/models/user'
User.on 'change', (e, user) ->
  unless user
    $(app.container).html (new (require('./controllers/not-signed-in'))).el
    return

  spinner.stop()

  Home = require './controllers/home'

  {Stack} = require 'spine/lib/manager'
  app.stack = new Stack
    controllers:
      'home': Home

    routes:
      '/': 'home'
      '/:id': 'home'

    default: 'home'

  $(app.container).html app.stack.el

  Route = require 'spine/lib/route'
  Route.setup()

# GO
User.fetch()
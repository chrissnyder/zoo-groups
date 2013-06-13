require './lib/setup'

new (require 'zooniverse/lib/api')
(require 't7e').load require './lib/en-us'

# Build app
app = {}
app.container = '#app'
$(app.container).html require('./views/attempt-sign-in')

spinner = new Spinner({width: 3}).spin(document.querySelector app.container)

app.topBar = new (require 'zooniverse/controllers/top-bar')
app.topBar.el.prependTo 'body'

User = require 'zooniverse/models/user'
User.on 'change', (e, user) ->
  unless user
    $(app.container).html (new (require('./controllers/not-signed-in'))).el
    return

  spinner.stop()

  {Stack} = require 'spine/lib/manager'
  app.stack = new Stack
    controllers:
      'home': require './controllers/home'

    routes:
      '/': 'home'
      '/:id': 'home'

    default: 'home'

  $(app.container).html app.stack.el

  (require 'spine/lib/route').setup()

# GO
User.fetch()
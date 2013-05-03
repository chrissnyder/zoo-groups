{Controller} = require 'spine'

dasherize = (name) ->
  new_name = name.replace /([a-z][A-Z])+/g, (string, offset) ->
    "#{ string[0] }-#{ string[1] }"
  new_name.toLowerCase()

class BaseController extends Controller
  className: => dasherize(@constructor.name)

  constructor: ->
    super

  render: (model = {}) =>
    # model is a loose term here.
    @html @template(model)

module.exports = BaseController
{Controller} = require 'spine'

class BaseController extends Controller

  constructor: ->
    super

  render: (model = {}) =>
    # model is a loose term here.
    @html @template(model)

module.exports = BaseController
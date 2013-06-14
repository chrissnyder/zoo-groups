BaseController = require './base-controller'

UserGroup = require '../models/user-group'

class CurrentGroup extends BaseController
  className: 'current-group'
  template: require '../views/current-group'

  events:
    'click #leave': 'onLeave'

  constructor: ->
    super
    @html @template()
    
    UserGroup.on 'select destroy', =>
      @render group: UserGroup.current

  onLeave: ->
    request = UserGroup.current.leave()

    request.done =>
      @render()
      UserGroup.list()

    request.fail =>
      alert 'Failed to leave group!'

module.exports = CurrentGroup

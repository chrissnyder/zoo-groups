BaseController = require './base-controller'

UserGroup = require '../models/user_group'

class CurrentGroup extends BaseController
  template: require '../views/current-group'

  events:
    'click #leave': 'onLeave'

  constructor: ->
    super
    @html @template()
    
    UserGroup.on 'select', =>
      @render group: UserGroup.current

  onLeave: ->
    UserGroup.leave()


module.exports = CurrentGroup
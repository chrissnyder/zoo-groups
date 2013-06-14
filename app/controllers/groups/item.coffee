BaseController = require '../base-controller'

User = require 'zooniverse/models/user'
UserGroup = require '../../models/user-group'

class GroupItem extends BaseController
  className: 'group-item'
  tag: 'li'
  template: require '../../views/groups/item'

  events:
    'click .classify-in-group': 'onJoin'
    'click .destroy-group': 'onDestroy'

  constructor: (@group) ->
    super

    UserGroup.on 'select', @render
    @group.on 'destroy', @release

    @render()

  render: =>
    @html @template
      group: @group
      current_group: UserGroup.current
      user: User.current

  # Events
  onDestroy: (e) =>
    @destroyGroup()

  onJoin: (e) =>
    @joinGroup()

  # "API"
  destroyGroup: =>
    request = @group.destroy()

    request.done =>
      @el.remove()
      UserGroup.off 'select'

    request.fail =>
      console.log 'group destroying failed'

  joinGroup: =>
    request = @group.participate()

    request.done =>
      @render()

    request.fail =>
      console.log 'group doesnt exist'

module.exports = GroupItem

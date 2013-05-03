BaseController = require '../base-controller'
_ = require 'underscore'

UserGroup = require '../../models/user_group'

Item = require './item'

class GroupList extends BaseController
  template: require '../../views/groups/list'

  elements:
    '#list': 'list'

  constructor: ->
    super

    UserGroup.on 'list', (e, groups) =>
      @makeList groups

  makeList: (groups) =>
    @html @template()
    for group in _(groups.member_of).sortBy((group) -> -(new Date(group.created_at))) when groups?
      (new Item(new UserGroup group)).el.appendTo @list

module.exports = GroupList
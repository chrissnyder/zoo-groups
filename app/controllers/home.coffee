BaseController = require './base-controller'

User = require 'zooniverse/models/user'
UserGroup = require '../models/user-group'

class Home extends BaseController
  template: require '../views/main'

  elements:
    '#create-group': 'createGroup'
    '#current-group': 'currentGroup'
    '#groups': 'groups'

  constructor: ->
    super
    @html @template()

    @currentGroup.html (new (require('./current-group'))).el
    @createGroup.html (new (require('./create-group'))).el
    @groups.html (new (require('./groups/list'))).el

    if User.current.user_group_id?
      UserGroup.currentId = User.current.user_group_id 
      UserGroup.fetch()

    UserGroup.list()

  active: (params = {}) =>
    super
    if params.id
      UserGroup.join(params.id).done =>
        UserGroup.list()

module.exports = Home
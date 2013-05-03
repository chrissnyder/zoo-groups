{Controller} = require 'spine'

User = require 'zooniverse/models/user'
UserGroup = require '../models/user_group'

class Home extends Controller
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
    if params.id then UserGroup.join params.id


module.exports = Home
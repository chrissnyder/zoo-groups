BaseController = require './base-controller'

UserGroup = require '../models/user-group'

class CreateGroup extends BaseController
  className: 'create-group'
  template: require '../views/create-group'

  events:
    'click #create': 'onCreateGroup'

  constructor: ->
    super
    @html @template()

  onCreateGroup: (e) =>
    e.preventDefault()
    @createGroup $('#group-name').val()

  createGroup: (name) =>
    request = UserGroup.create name

    request.done =>
      UserGroup.list()

module.exports = CreateGroup
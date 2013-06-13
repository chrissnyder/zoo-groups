BaseController = require './base-controller'

UserGroup = require '../models/user-group'

REQUIRED_KEYS = ['group-name']

class CreateGroup extends BaseController
  className: 'create-group'
  template: require '../views/create-group'

  elements:
    'form': 'form'
    'input[name="group-name"]': 'nameInput'

  events:
    'click #create': 'onCreateGroup'

  constructor: ->
    super
    @html @template()

  onCreateGroup: (e) =>
    e.preventDefault()

    metadata = {}

    for element in @form.find('input, select').toArray() when (!~REQUIRED_KEYS.indexOf element.name)
      {name, value, attributes} = element

      switch attributes.getNamedItem('type').nodeValue
        when 'checkbox'
          metadata[name] = element.checked
        else
          metadata[name] = value

    request = UserGroup.create @nameInput.val(), metadata

    request.done =>
      UserGroup.list()

module.exports = CreateGroup

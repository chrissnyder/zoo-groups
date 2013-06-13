Api = require 'zooniverse/lib/api'
BaseModel = require 'zooniverse/models/base-model'

class UserGroup extends BaseModel
  @current: null
  @currentId: -1

  @path: ->
    'user_groups'

  @create: (name, metadata = {}) =>
    metadata['open'] = true # for now

    json =
      user_group:
        name: name
        metadata: metadata
    
    Api.current.getJSON "#{ @path() }/create", json, (rawGroup) =>
      group = new @ rawGroup
      @trigger 'create', group

  @fetch: =>
    fetcher = new $.Deferred

    request = Api.current.getJSON "#{ @path() }/#{ @currentId }"

    request.done (rawGroup) =>
      (new @ rawGroup).select()
      @trigger 'fetch', @current
      fetcher.resolve @current

    fetcher.promise()

  @join: (@currentId) =>
    joiner = new $.Deferred

    request = Api.current.getJSON "#{ @path() }/#{ @currentId }/join", (rawGroup) =>

    request.done (rawGroup) =>
      (new @ rawGroup).select()
      @trigger 'join', @current
      joiner.resolve @current

    request.fail =>
      @trigger 'join-fail'
      joiner.reject arguments...

    joiner.promise()

  @participate: (@currentId) =>
    participater = new $.Deferred

    request = Api.current.getJSON "#{ @path() }/#{ @currentId }/participate", (rawGroup) =>

    request.done (rawGroup) =>
      (new @ rawGroup).select()
      @trigger 'participate', @current
      participater.resolve @current

    request.fail =>
      @trigger 'participate-fail'
      participater.reject arguments...

    participater.promise()

  @list: =>
    lister = new $.Deferred

    request = Api.current.getJSON "#{ @path() }"

    request.done (groupData) =>
      @trigger 'list', groupData
      lister.resolve groupData

    lister.promise()

  id: ''
  unique_name: ''

  constructor: (params = {}) ->
    super params
    @[property] = value for own property, value of params

  url: =>
    "#{ @constructor.path() }/#{ @id }"

  joinLink: =>
    "#{ location.origin }#{ location.pathname }#/#{ @unique_name }"

  select: =>
    @constructor.current = @
    @trigger 'select'

  destroy: =>
    @constructor.current = null if @constructor.current is @

    destroyer = new $.Deferred

    request = Api.current.getJSON "#{ @url() }/destroy"

    request.done =>
      @trigger 'destroy'
      destroyer.resolve()

    request.fail =>
      @trigger 'destroy-fail', arguments...
      destroyer.reject arguments...

    destroyer.promise()

  leave: =>
    leaver = new $.Deferred

    request = Api.current.getJSON "#{ @url() }/leave"

    request.done =>
      @current.destroy()
      @trigger 'leave'
      leaver.resolve arguments...

    request.fail =>
      @trigger 'leave-fail'
      leaver.reject arguments...

    leaver.promise()

  participate: =>
    participater = new $.Deferred

    request = Api.current.getJSON "#{ @url() }/participate"

    request.done =>
      @select()
      @trigger 'participate'
      participater.resolve()

    request.fail =>
      @trigger 'participate-fail'
      participater.reject arguments...

    participater.promise()


module.exports = UserGroup
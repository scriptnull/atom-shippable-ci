# Core Modules
{CompositeDisposable} = require 'atom'
shell = require 'shell'

# Others
doBaseCheck = require './common/base-check.coffee'
ApiClient = require './common/ApiClient.js'
client = ApiClient.getInstance()

module.exports = AtomShippableCi =
  subscriptions: null
  shipBadge: null
  config:
    checkBuildStatusOnStartup:
      type: 'boolean'
      default: false

    apiToken:
      title: 'API Token'
      type: 'string'
      default: '< Your API Token >'


  activate: (state) ->

    ShippableBadgeView = require './common/shippable-badge-view.coffee'
    @shipBadge = new ShippableBadgeView();
    @shipBadge.init()

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'shippable-ci:current-status': => @currentStatus()
    @subscriptions.add atom.commands.add 'atom-workspace', 'shippable-ci:open-project-in-browser': => @openProjectInBrowser()
    @subscriptions.add atom.commands.add 'atom-workspace', 'shippable-ci:open-latest-build-in-browser': => @openLatestBuildInBrowser()

    #Check if we should check build status on startup
    if atom.config.get 'shippable-ci.checkBuildStatusOnStartup'
      @currentStatus()

  deactivate: ->
    console.log 'deactivated main file'
    @subscriptions.dispose()
    @shipBadge.destroy()

  serialize: ->

  consumeStatusBar: (statusBar) ->
    statusBar.addLeftTile(item: @shipBadge, priority: 100)

  currentStatus: ->
    currentStatusCommand = require './commands/current-status.coffee'
    c = new currentStatusCommand @shipBadge
    c.run()

  openProjectInBrowser: ->
    doBaseCheck (err, projectId) =>
      return @handleError err if err
      shell.openExternal "https://shippable.com/projects/#{projectId}"

  openLatestBuildInBrowser: ->
    doBaseCheck (err, projectId) =>
      return @handleError err if err
      client.getLatestBuild projectId, (err, data) =>
        return @handleError err if err
        build = data.body?[0]
        return @handleError new Error "Cannot retrieve build details from server." if !build
        shell.openExternal "https://shippable.com/runs/#{build.id}"

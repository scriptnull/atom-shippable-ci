# Core Modules
{CompositeDisposable} = require 'atom'

# Others
doBaseCheck = require './common/base-check.coffee'
ApiClient = require './common/ApiClient.js'
client = ApiClient.getInstance()

module.exports = AtomShippableCi =
  subscriptions: null
  shipBadge: null
  command: null
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
    @subscriptions.add atom.commands.add 'atom-workspace', 'shippable-ci:open-latest-run-in-browser': => @openLatestRunInBrowser()

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
    @command = new currentStatusCommand @shipBadge
    @command.run()

  openProjectInBrowser: ->
    openProjectInBrowserCommand = require './commands/open-project-in-browser.coffee'
    @command = new openProjectInBrowserCommand()
    @command.run()

  openLatestRunInBrowser: ->
    openLatestRunInBrowserCommand = require './commands/open-latest-run-in-browser.coffee'
    @command = new openLatestRunInBrowserCommand()
    @command.run()

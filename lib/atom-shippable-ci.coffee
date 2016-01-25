# View Modules
AtomShippableCiView = require './atom-shippable-ci-view'

# Core Modules
{CompositeDisposable} = require 'atom'
shell = require 'shell'

# Others
doBaseCheck = require './base-check.coffee'
ApiClient = require './ApiClient.js'
client = ApiClient.getInstance()

module.exports = AtomShippableCi =
  atomShippableCiView: null
  modalPanel: null
  subscriptions: null
  shipBadge: null

  activate: (state) ->
    @atomShippableCiView = new AtomShippableCiView(state.atomShippableCiViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomShippableCiView.getElement(), visible: false)
    ShippableBadgeView = require './views/shippable-badge-view.coffee'
    @shipBadge = new ShippableBadgeView();
    @shipBadge.init()

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    #@subscriptions.add atom.commands.add 'atom-workspace', 'shippable-ci:toggle': => @toggle()

    # Commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'shippable-ci:current-status': => @currentStatus()
    @subscriptions.add atom.commands.add 'atom-workspace', 'shippable-ci:open-project-in-browser': => @openProjectInBrowser()
    @subscriptions.add atom.commands.add 'atom-workspace', 'shippable-ci:open-latest-build-in-browser': => @openLatestBuildInBrowser()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomShippableCiView.destroy()
    @shipBadge.destroy()

  serialize: ->
    atomShippableCiViewState: @atomShippableCiView.serialize()

  consumeStatusBar: (statusBar) ->
    console.log "consumeStatusBar"
    statusBar.addLeftTile(item: @shipBadge, priority: 100)

  toggle: ->
    console.log 'AtomShippableCi was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  openProjectInBrowser: ->
    __ = @
    @shipBadge.setText "Opening Project in browser"
    doBaseCheck (err, projectId) ->
      return __.handleError err if err
      shell.openExternal "https://shippable.com/projects/#{projectId}"

  openLatestBuildInBrowser: ->
    __ = @
    doBaseCheck (err, projectId) ->
      return __.handleError err if err
      client.getLatestBuild projectId, (err, data) ->
        return __.handleError err if err
        build = data.body?[0]
        return __.handleError new Error "Cannot retrieve build details from server." if !build
        shell.openExternal "https://shippable.com/builds/#{build.id}"

  currentStatus: ->
    __ = @
    doBaseCheck (err, projectId) ->
      return __.handleError err if err
      client.getLatestBuild projectId, (err, data)->
        return __.handleError err if err
        build = data.body?[0]
        return __.handleError new Error "Cannot retrieve build details from server." if !build
        buildItems = require './views/build-status.js'
        buildItem = buildItems[build.status]
        atom.notifications["add#{buildItem.type}"] "Build Status : #{buildItem.message}",
          icon: buildItem.icon
          detail: "\n
          BUILD ##{build.buildGroupNumber}\n
          BRANCH #{build.branch}\n
          COMMIT MSG \"#{build.lastCommitShortDescription}\"\n
          TRIGGERED BY #{build.triggeredBy.displayName || build.triggeredBy.login}\n
          "
          __.shipBadge.setBuildItemResult buildItem
        return
      return
    return

  handleError: (err) ->
    @shipBadge.setText '[Shippable-CI] Error !'
    atom.notifications.addError '[Shippable-CI] Something went wrong.' ,
       detail : err.message
    console.error err

runItems = require '../common/runStatus.js'
doBaseCheck = require '../common/base-check.coffee'
ApiClient = require '../common/ApiClient.js'
client = ApiClient.getInstance()

module.exports =
  class currentStatus
    shipBadge: null

    handleError: (err) ->
      @shipBadge.setErrorText()
      atom.notifications.addError '[Shippable-CI] Something went wrong.' ,
         detail : err.message
      console.error err

    constructor: (badge, handleError) ->
      @shipBadge = badge

    showNotificationForRun: (run, runItem) ->
      atom.notifications["add#{runItem.type}"] "Run Status : #{runItem.message}",
        icon: runItem.icon
        detail: "\n
        RUN ##{run.runNumber}\n
        BRANCH #{run.branchName}\n
        COMMIT MSG \"#{run.lastCommitShortDescription}\"\n
        TRIGGERED BY #{run.triggeredBy.displayName || run.triggeredBy.login}\n
        "

    run: ->
      doBaseCheck (err, projectId) =>
        return @handleError err if err
        @shipBadge.setLoadingText()
        client.getLatestBuild projectId, (err, data) =>
          return @handleError err if err
          #Parse Run Item
          run = data.body?[0]
          return @handleError new Error "Cannot retrieve run details from server." if !run
          runItem = runItems[run.statusCode]
          #Show notification for the Run
          @showNotificationForRun run, runItem
          #Update the Status Bar with Run results
          @shipBadge.setRunItemResult runItem

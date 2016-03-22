doBaseCheck = require '../common/base-check.coffee'
ApiClient = require '../common/ApiClient.js'
client = ApiClient.getInstance()
shell = require 'shell'

module.exports =
  class openLatestRunInBrowser
    handleError: (err) ->
      atom.notifications.addError '[Shippable-CI] Something went wrong.' ,
         detail : err.message
      console.error err

    run: ->
      doBaseCheck (err, projectId) =>
        return @handleError err if err
        client.getLatestBuild projectId, (err, data) =>
          return @handleError err if err
          run = data.body?[0]
          return @handleError new Error "Cannot retrieve run details from server." if !run
          shell.openExternal "https://shippable.com/runs/#{run.id}"

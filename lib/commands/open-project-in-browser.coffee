doBaseCheck = require '../common/base-check.coffee'
shell = require 'shell'

module.exports =
  class openProjectInBrowser
    handleError: (err) ->
      atom.notifications.addError '[Shippable-CI] Something went wrong.' ,
         detail : err.message
      console.error err

    run: ->
      doBaseCheck (err, projectId) =>
        return @handleError err if err
        shell.openExternal "https://shippable.com/projects/#{projectId}"

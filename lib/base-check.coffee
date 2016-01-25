fs = require 'fs'
yaml = require 'yaml-js'

# Base check
# returns projectId if everything goes right
# returns err if something goes wrong
# consume as (err, projectId) ->

module.exports = (cb) ->

  class Core
    # If shippable.yml is present , returns data else error
    getShippableYmlData : (cb)->
      fs.readFile "#{atom.project.getDirectories()[0].path}/shippable.yml" , (err, data) ->
        cb(err , data ?= data.toString())

    getProjectId: (yamlAsJson) ->
        return yamlAsJson?.atom?.projectId

    constructor : (cb) ->
      __ = @
      @getShippableYmlData (err, data ) ->
        return cb new Error "Cannot retrieve shippable.yml file" if err
        projectId = __.getProjectId yaml.load data
        return cb new Error "Cannot retrieve ProjectId. Please check shippable.yml" if !projectId
        cb null , projectId

  return new Core(cb)

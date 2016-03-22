moment = require 'moment'
class ShippableBadgeView extends HTMLElement
  init: ->
    @classList.add('shippable-badge-view', 'inline-block')

  setText: (text) ->
    @innerText = text

  setLoadingText: ->
    @innerText = 'Loading Shippable...'

  setErrorText: ->
    @innerText = 'Shippable - Error !'

  startSyncTimer: ->
    @updateLastSynced()
    @syncTimer = setInterval @updateLastSynced.bind(@) , 61000

  updateLastSynced: ->
    @lastSynced.innerText = " #{moment(@lastSyncedDate).fromNow()}"

  setRunItemResult : (runItem) ->
    #Create Icon
    icon = document.createElement 'span'
    icon.classList.add 'icon' , "icon-#{runItem.icon}"
    #Create Message
    message = document.createElement 'span'
    message.innerText = "Shippable"
    #Create LastSynced
    @lastSynced = document.createElement 'span'
    @lastSyncedDate = new Date()
    #Create badge
    badge = document.createElement 'span'
    badge.classList.add 'badge' , "badge-#{runItem.type.toLowerCase()}"
    badge.appendChild icon
    badge.appendChild message
    #Append badge
    @innerHTML = ""
    @appendChild badge
    setTimeout ( => @appendChild @lastSynced ) , 5000
    #Start timer to show last synced time
    @startSyncTimer()

  activate: ->
    @element

  deactivate: ->
    clearInterval @syncTimer


module.exports = document.registerElement('shippable-badge-view', prototype: ShippableBadgeView.prototype, extends: 'div')

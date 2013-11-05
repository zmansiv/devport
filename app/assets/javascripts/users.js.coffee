###
= require hamlcoffee
= require underscore
= require backbone
= require jquery.serializeJSON
= require_tree ../templates
= require_tree ./models
= require_tree ./collections
= require_tree ./views
= require_tree ./routers
###

window.Profile =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    console.log "backbone loaded"

$(document).ready ->
  Profile.initialize()
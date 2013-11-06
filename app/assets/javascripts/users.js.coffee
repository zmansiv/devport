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

  $(".linkedin-account-connect").click ->
    window.location.href = "/auth/linkedin";

  $(".linkedin-account-disconnect").click (e) ->
    el = $ e.currentTarget
    github_id = el.data("github-id")
    $.ajax {
      url: Routes.api_destroy_provider_path github_id, 'linkedin'
      type: 'DELETE'
      success: ->
        window.location.href = Routes.user_path github_id
      failure: ->
        window.location.href = Routes.edit_user_path github_id
    }

  $(".delete-account").click (e) ->
    el = $ e.currentTarget
    github_id = el.data("github-id")
    $.ajax {
      url: Routes.api_user_path github_id
      type: 'DELETE'
      success: ->
        window.location.href = Routes.root_path()
    }
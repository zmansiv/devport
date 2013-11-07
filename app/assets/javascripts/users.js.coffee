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
    #console.log "backbone loaded"

$(document).ready ->
  Profile.initialize()

  $(".project-nav").each (idx, el) ->
    el = $ el
    if el.data "sortable"
      el.sortable {
        stop: (event, ui) ->
          projects = {}
          projectEls = {}
          $(".project-container").each (idx, el) ->
            el = $ el
            projectEls[el.data "name"] = el
          projDiv = $ ".projects"
          projDiv.empty()
          el.children("li").each (idx, el) ->
            el = $ el
            projects[el.data "name"] = idx
            projDiv.append projectEls[el.data "name"]
          github_id = el.data "github-id"
          $.ajax {
            url: Routes.api_reorder_projects_path github_id
            data: { projects: projects }
            type: "POST"
            success: ->
              console.log "yay!"
          }
      }

  $(".linkedin-account-connect").click ->
    window.location.href = "/auth/linkedin";

  $(".linkedin-account-disconnect").click (e) ->
    el = $ e.currentTarget
    github_id = el.closest(".box").data "github-id"
    $.ajax {
      url: Routes.api_destroy_provider_path github_id, "linkedin"
      type: 'DELETE'
      success: ->
        window.location.href = Routes.user_path github_id
      failure: ->
        window.location.href = Routes.edit_user_path github_id
    }

  $(".linkedin-account-sync").click (e) ->
    el = $ e.currentTarget
    github_id = el.closest(".box").data "github-id"
    $.ajax {
      url: Routes.api_sync_provider_path github_id, "linkedin"
      type: 'PUT'
      success: ->
        window.location.href = Routes.user_path github_id
      failure: ->
        window.location.href = Routes.edit_user_path github_id
    }

  $(".github-account-sync").click (e) ->
    el = $ e.currentTarget
    github_id = el.closest(".box").data "github-id"
    $.ajax {
      url: Routes.api_destroy_provider_path github_id, "github"
      type: 'PUT'
      success: ->
        window.location.href = Routes.user_path github_id
      failure: ->
        window.location.href = Routes.edit_user_path github_id
    }

  $(".delete-account").click (e) ->
    el = $ e.currentTarget
    github_id = el.closest(".box").data "github-id"
    $.ajax {
      url: Routes.api_user_path github_id
      type: 'DELETE'
      success: ->
        window.location.href = Routes.root_path()
    }
$(document).ready ->

  $(".project-nav").each (idx, el) ->
    el = $ el
    if el.data "sortable"
      el.sortable {
        stop: ->
          projectEls = {}
          $(".project-container").each (idx, el) ->
            el = $ el
            projectEls[el.data "name"] = el

          projectsEl = $ ".projects"
          projectsEl.empty()

          projects = {}
          el.children("li").each (idx, el) ->
            el = $ el
            projects[el.data "name"] = idx
            projectsEl.append projectEls[el.data "name"]

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
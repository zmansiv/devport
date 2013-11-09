###
= require underscore
= require backbone
= require hamlcoffee
= require_tree ../templates
= require_tree ./models
= require_tree ./collections
= require_tree ./views
= require_tree ./routers
###


$(document).ready ->
  Profile.initialize()

  jQuery.event.props.push "dataTransfer"

  $(".upload-image").tooltip {
    title: "Drag a photo onto the project box to upload it"
  }

  $(document).on "dragover", (e) ->
    e.preventDefault()
    e.stopPropagation()

  $(document).on "drop", (e) ->
    e.preventDefault()
    e.stopPropagation()

  $(".project").on "dragover", (e) ->
    e.stopPropagation()
    e.preventDefault()
    e.dataTransfer.dropEffect = "copy"

  $(".project").on "drop", (e) ->
    el = $ e.currentTarget
    e.preventDefault()
    e.stopPropagation()

    github_id = el.closest(".user").data "github-id"

    console.log file.name for file in e.dataTransfer.files

    console.log Routes.api_project_images_path(github_id, el.data "repo-name")



  $(".show-images").click (e) ->
    console.log "no"

  $(".delete-project").click (e) ->
    el = $ e.currentTarget
    github_id = el.closest(".user").data "github-id"
    project_name = el.closest(".project").data "repo-name"
    $.ajax {
      url: Routes.api_project_path github_id, project_name
      type: "DELETE"
      success: ->
        el.closest(".project-container").slideOut()
    }

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

          github_id = el.closest(".user").data "github-id"

          $.ajax {
            url: Routes.api_reorder_projects_path github_id
            data: { projects: projects }
            type: "POST"
          }
      }

  replaceWithProgressBar = (el) ->
    progressBar = $("<div/>", {
      class: "progress progress-striped active sync-progress-bar"
    }).append $("<div/>", {
      class: "progress-bar progress-bar-info"
    })

    el.replaceWith progressBar

  $(".linkedin-account-connect").click (e) ->
    replaceWithProgressBar $(e.currentTarget)
    window.location.href = "/auth/linkedin"

  $(".linkedin-account-disconnect").click (e) ->
    el = $ e.currentTarget
    github_id = el.closest(".box").data "github-id"
    $.ajax {
      url: Routes.api_destroy_provider_path github_id, "linkedin"
      type: "DELETE"
      success: ->
        window.location.href = Routes.user_path github_id
      failure: ->
        window.location.href = Routes.edit_user_path github_id
    }

  $(".linkedin-account-sync").click (e) ->
    el = $ e.currentTarget
    github_id = el.closest(".box").data "github-id"
    replaceWithProgressBar el
    $.ajax {
      url: Routes.api_sync_provider_path github_id, "linkedin"
      type: "PUT"
      success: ->
        window.location.href = Routes.user_path github_id
      failure: ->
        window.location.href = Routes.edit_user_path github_id
    }

  $(".github-account-sync").click (e) ->
    el = $ e.currentTarget
    github_id = el.closest(".box").data "github-id"
    replaceWithProgressBar el
    $.ajax {
      url: Routes.api_destroy_provider_path github_id, "github"
      type: "PUT"
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
      type: "DELETE"
      success: ->
        window.location.href = Routes.root_path()
    }
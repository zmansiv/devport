$ ->

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
###
= require js-routes
= require jquery
= require jquery_ujs
= require jquery-ui-1.10.3.custom
= require jquery.alert
= require bootstrap
= require typeahead
###

window.Profile =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    window.user = $.parseJSON($("#user-json").html())
    if user.skills
      user.skills = user.skills.sort()
    if user.projects
      user.projects = user.projects.sort (proj, otherProj) ->
        return proj.display_pos - otherProj.display_pos
    window.owner = $("#owner").html()
    new Profile.Routers.Profile()
    Backbone.history.start()

$.fn.slideOut = ->
  @each ->
    el = $ this
    el.fadeTo 200, 0, ->
      el.slideUp 500, ->
        el.remove()

$ ->
  _typeahead = $(".user-search-bar").typeahead [
    {
      name: "user_github_ids"
      valueKey: "github_id"
      prefetch: {
        url: Routes.api_users_path()
        ttl: 600000
      }
    },
    {
      name: "user_names"
      valueKey: "name"
      prefetch: {
        url: Routes.api_users_path()
        ttl: 600000
      }
    }
  ]

  _typeahead.on 'typeahead:selected', (evt, data) ->
    window.location.href = Routes.user_path data.github_id
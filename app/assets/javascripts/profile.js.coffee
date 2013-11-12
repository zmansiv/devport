###
= require underscore
= require backbone
= require hamlcoffee
= require_self
= require_tree ../templates
= require_tree ./models
= require_tree ./collections
= require_tree ./views
= require_tree ./routers
###

$ ->
  Profile.initialize()

window.Profile =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    window.user = $.parseJSON $("#user-json").html()
    if user.skills
      user.skills = user.skills.sort()
    if user.projects
      user.projects = user.projects.sort (proj, otherProj) ->
        return proj.display_pos - otherProj.display_pos
    window.owner = $.trim($("#owner").html()) == "true"
    new Profile.Routers.Profile()
    Backbone.history.start()

_.extend Backbone.View.prototype, {
  ensure: (obj, action) ->
    if obj != undefined && obj != null && obj != false && obj != "" && (obj !instanceof Array || obj.length > 0)
      return action.bind(obj)()
    else
      return null

  formatDate: (dateString) ->
    months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ]
    parts = dateString.split(" ")
    return months[parseInt(parts[0])] + " " + parts[1]

  languagesToStr: (langs) ->
    totalBytes = langs.reduce((memo, lang) ->
      return memo + lang.bytes
    , 0)

    langsPercs = langs.map (lang) ->
      return Math.round (lang.bytes * 100) / totalBytes

    langsStr = ""
    $.each langs, (idx, lang) ->
      langsStr += (if idx == 0 then "" else ", ") + langsPercs[idx] + "% " + lang.name

    return langsStr
}
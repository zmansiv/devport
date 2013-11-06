$(document).ready ->
  $(".destroy-session").click (e) ->
    el = $ e.currentTarget
    $.ajax {
      url: Routes.session_path el.data("token-id")
      type: "DELETE"
      success: ->
        el.closest(".session").slideOut()
        if el.data("current")
          window.location.replace Routes.root_path()
    }
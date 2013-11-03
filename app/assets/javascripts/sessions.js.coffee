$(document).ready ->
  $(".destroy-session").click (e) ->
    el = $ e.currentTarget
    url = Routes.session_path el.data("token-id")
    console.log el.data("current")
    $.ajax {
      url: url
      type: "DELETE"
      success: ->
        el.closest(".session").slideOut()
        if el.data("current")
          window.location.replace Routes.root_path()
    }
class Profile.Routers.Profile extends Backbone.Router
  routes: {
    "": "show"
    "edit": "edit"
  }

  show: ->
    console.log "showing profile"
    showView = new window.Profile.Views.Show {
      model: window.user
    }

    $(".user").html showView.render().$el

  edit: ->
    console.log "editing profile"
#    newView = new Journal.Views.PostForm
#    $("#content").html newView.render().$el
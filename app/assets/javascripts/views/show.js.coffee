class Profile.Views.Show extends Backbone.View
  template: JST["show"]

  render: ->
    formatDate = (dateString) ->
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

    renderedContent = this.template {
      user: this.model
      owner: window.owner
      formatDate: formatDate
    }
    this.$el.html renderedContent
    return this
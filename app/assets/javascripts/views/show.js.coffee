class Profile.Views.Show extends Backbone.View
  template: JST["show"]

  events: {
    "dragover .project": "projectDragover"
    "drop .project": "projectDrop"
    "click .show-images": "showImages"
    "click .delete-project": "deleteProject"
  }

  initialize: (options) ->
    jQuery.event.props.push "dataTransfer"

    that = this
    $ ->
      $(".upload-image").tooltip {
        title: "Drag a photo onto the project box to upload it"
      }

      $(".project-nav").each that.eachProjectNav.bind(that)

    $(document).on "dragover", this.cancel
    $(document).on "drop", this.cancel

  render: ->
    renderedContent = this.template {
      user: this.model
      owner: window.owner
      ensure: this.ensure
      formatDate: this.formatDate
      languagesToStr: this.languagesToStr
    }
    this.$el.html renderedContent
    return this

  cancel: (e) ->
    e.preventDefault()
    e.stopPropagation()

  projectDragover: (e) ->
    this.cancel e
    e.dataTransfer.dropEffect = "copy"

  projectDrop: (e) ->
    this.cancel e

    el = $ e.currentTarget

    console.log file.name for file in e.dataTransfer.files
    console.log Routes.api_project_images_path(this.model.github_id, el.data "repo-name")

  showImages: (e) ->
    console.log "no"

  deleteProject: (e) ->
    el = $ e.currentTarget
    projectName = el.closest(".project").data "repo-name"
    $.ajax {
      url: Routes.api_project_path this.model.github_id, projectName
      type: "DELETE"
      success: ->
        el.closest(".project-container").slideOut()
        $(".project-nav > li").filter(-> return $(this).data("name") == projectName).slideOut()
    }

  eachProjectNav: (idx, el) ->
    that = this

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

          $.ajax {
            url: Routes.api_reorder_projects_path that.model.github_id
            data: { projects: projects }
            type: "POST"
          }
      }
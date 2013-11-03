#modified alert.js v3.0.0 for smoother close transition and translated to CoffeeScript

(($) ->
  "use strict"

  dismiss = "[data-dismiss=\"alert\"]"
  Alert = (el) ->
    $(el).on "click", dismiss, @close

  Alert::close = (e) ->
    $this = $(this)
    selector = $this.attr "data-target"

    unless selector
      selector = $this.attr "href"
      selector = selector and selector.replace /.*(?=#[^\s]*$)/, "" # strip for ie7

    $parent = $ selector

    e.preventDefault() if e

    unless $parent.length
      $parent = (if $this.hasClass "alert" then $this else $this.parent())

    $parent.trigger e = $.Event "close.bs.alert"

    return if e.isDefaultPrevented()

    $parent.removeClass "in"

    $parent.slideOut()

  old = $.fn.alert

  $.fn.alert = (option) ->
    @each ->
      $this = $(this)
      data = $this.data "bs.alert"
      $this.data "bs.alert", (data = new Alert this) unless data
      data[option].call $this if typeof option is "string"
      $this.data "initHeight", $this.height()

  $.fn.alert.Constructor = Alert

  $.fn.alert.noConflict = ->
    $.fn.alert = old
    this

  $(document).on "click.bs.alert.data-api", dismiss, Alert::close
) jQuery
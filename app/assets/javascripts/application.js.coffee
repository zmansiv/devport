###
= require js-routes
= require jquery
= require jquery_ujs
= require jquery.alert
= require bootstrap
###

$.fn.slideOut = ->
  @each ->
    el = $ this
    el.slideUp "slow", ->
      el.remove()
###
= require hamlcoffee
= require js-routes
= require jquery
= require jquery_ujs
= require jquery.serializeJSON
= require underscore
= require backbone
= require bootstrap
= require_tree .
###

$.fn.slideOut = ->
  @each ->
    el = $ this
    el.slideUp "slow", ->
      el.remove()
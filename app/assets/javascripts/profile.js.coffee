###
= require underscore
= require backbone
= require hamlcoffee
= require_tree ../templates
= require_tree ./models
= require_tree ./collections
= require_tree ./views
= require_tree ./routers
###


$ ->
  Profile.initialize()
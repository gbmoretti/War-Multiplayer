class ActionController

  constructor: (@app) ->
    @controllerName = 'action'
    @modal = $('div#action')
    @modal.hide()    
    
  open: (title,msg) ->
    
    @modal.find('#msg').html("")
    @modal.find('#modal-title').html("")
    
    @modal.find('#modal-title').html(title)
    @modal.find('#msg').html(msg)
    @modal.show()
    
  close: () ->
    @modal.hide()
    

class ActionController

  constructor: (@app) ->
    @controllerName = 'action'
    @modal = $('div#action')
    console.log @modal
    @modal.hide()    
    
  open: (title,msg) ->
    @modal.find('#modal-title').html(title)
    @modal.find('#msg').html(msg)
    @modal.show()
    
  close: () ->
    @modal.hide()
    

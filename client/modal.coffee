class Modal

  constructor: (@modal) ->
    @overlay = $('.modal-overlay')

    $('.closebtn').click () =>
      @close $(this).parent()
      
  open: () ->
    @overlay.show()
    @modal.show()
    
  close: () ->
    @modal.hide();
    @overlay.hide();  

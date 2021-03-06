/* Controlador da janela de ação */

  var ActionController;

  ActionController = (function() {

    function ActionController(app) {
      this.app = app;
      this.controllerName = 'action';
      this.modal = $('div#action');
      this.modal.hide();
    }

    ActionController.prototype.open = function(title, msg) {
      this.modal.find('#modal-title').html(title);
      this.modal.find('#msg').html(msg);
      return this.modal.show();
    };

    ActionController.prototype.close = function() {
      this.modal.find("#msg").html("Vazio");
      return this.modal.hide();
    };

    return ActionController;

  })();



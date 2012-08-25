/* controlador de 'login'. No caso, apenas a escolha do nick */
  var InitMessage, SetNickController;

  InitMessage = (function() {

    function InitMessage(nick) {
      this.controller = 'set_nick';
      this.action = 'set';
      this.params = {
        'nick': nick
      };
    }

    return InitMessage;

  })();

  SetNickController = (function() {

    function SetNickController(app) {
      var _this = this;
      this.app = app;
      this.controllerName = 'setNick';
      this.modal = $('#login');
      this.inputNick = $('#login input[type=text]');
      this.btn = $('#login input[type=button]');
      this.inputNick.focus();
      this.btn.click(function() {
        return _this.setNick();
      });
      this.inputNick.keydown(function(eventObject) {
        if (eventObject.keyCode === 13) {
          return _this.setNick();
        }
      });
    }

    SetNickController.prototype.open = function() {
      return this.app.openModal(this.modal);
    };

    SetNickController.prototype.setNick = function() {
      if (this.inputNick.val() !== '') {
        this.app.user = this.inputNick.val();
        this.app.conn.send(new InitMessage(this.app.user));
        return this.app.closeModal(this.modal);
      }
    };

    return SetNickController;

  })();


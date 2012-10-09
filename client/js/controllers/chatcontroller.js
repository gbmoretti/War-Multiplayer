/* Controlador do chat */

  var ChatController, TxtMessage;

  TxtMessage = (function() {

    function TxtMessage(msg) {
      this.controller = 'chat';
      this.action = 'send_msg';
      this.params = {
        'msg': msg
      };
    }

    return TxtMessage;

  })();

  ChatController = (function() {

    function ChatController(app) {
      var _this = this;
      this.app = app;
      this.controllerName = 'chat';
      this.inputElmnt = $('div#chatinput input[type=text]');
      this.chatElmnt = $('div#chat');
      this.chatWindow = $('div#chat-window');
      this.btnElmnt = $('#btnchat');

      this.inputElmnt.keydown(function(eventObject) {
        if (eventObject.keyCode === 13) {
          return _this.sendTxt();
        }
      });
      this.btnElmnt.click(function(eventObject) {
        return _this.chatWindow.toggle();
      });
    }

    ChatController.prototype.txt = function(msg) {
      this.chatElmnt.append('&lt' + msg.author + '&gt ' + msg.msg + '<br/>');
      this.chatElmnt.scrollTop(this.chatElmnt.height());
      return this.animBtn();
    };

    ChatController.prototype.warn = function(msg) {
      this.chatElmnt.append('<span class="warn">' + msg.msg + '</span><br/>');
      return this.chatElmnt.scrollTop(this.chatElmnt.height());
    };

    ChatController.prototype.sendTxt = function() {
      var txt;
      txt = this.inputElmnt.val();
      this.app.conn.send(new TxtMessage(txt));
      return this.inputElmnt.val('');
    };

    ChatController.prototype.animBtn = function() {
      this.btnElmnt.animate({
        'background-color': '#444'
      }, 'slow');
      return this.btnElmnt.animate({
        'background-color': '#000'
      }, 'slow');
    };

    return ChatController;

  })();



(function() {
  var Client, Modal, WSConnection;

  Modal = (function() {

    function Modal(modal) {
      var _this = this;
      this.modal = modal;
      this.overlay = $('.modal-overlay');
      $('.closebtn').click(function() {
        return _this.close($(_this).parent());
      });
    }

    Modal.prototype.open = function() {
      this.overlay.show();
      return this.modal.show();
    };

    Modal.prototype.close = function() {
      this.modal.hide();
      return this.overlay.hide();
    };

    return Modal;

  })();

  WSConnection = (function() {

    function WSConnection(addr, statusElmnt) {
      this.addr = addr;
      this.statusElmnt = statusElmnt != null ? statusElmnt : $('div#status');
      this.socket = new WebSocket(this.addr);
    }

    WSConnection.prototype.send = function(obj) {
      var msg;
      msg = JSON.stringify(obj);
      console.log("Enviando " + msg);
      return this.socket.send(msg);
    };

    /*
       ** por algum motivo bisonho isso nao funciona
    */

    WSConnection.prototype.on_close = function(func) {
      this.socket.onclose = func;
      return refreshStatus();
    };

    WSConnection.prototype.on_open = function(func) {
      this.socket.onopen = func;
      return refreshStatus();
    };

    WSConnection.prototype.on_message = function(func) {
      var _this = this;
      return this.socket.onmessage = function(msg) {
        console.log(msg);
        msg = eval("(" + msg + ")");
        return func(msg);
      };
    };

    /* 
     ** até aqui
    */

    WSConnection.prototype.refreshStatus = function() {
      var state;
      state = this.socket.readyState;
      console.log(state);
      this.statusElmnt.removeClass();
      if (state === 0) {
        this.statusElmnt.addClass('connecting');
        this.statusElmnt.html('conectando');
      }
      if (state === 1) {
        this.statusElmnt.addClass('online');
        this.statusElmnt.html('conectado');
      }
      if (state === 2 || state === 3) {
        this.statusElmnt.addClass('offline');
        return this.statusElmnt.html('DESCONECTADO');
      }
    };

    return WSConnection;

  })();

  Client = (function() {

    function Client(addr) {
      var _this = this;
      this.listening = [];
      this.socket = new WSConnection(addr);
      this.socket.socket.onmessage = function(msg) {
        msg = eval("(" + msg.data + ")");
        if (_this.listening[msg.name]) {
          _this.listening[msg.name].call(_this, msg.params);
        }
        if (!_this.listening[msg.name]) {
          return console.log('Nao estou ouvindo essa mensagem! ' + msg.name);
        }
      };
      this.socket.socket.onopen = function() {
        return console.log('Abriu!');
      };
      this.socket.socket.onclose = function() {
        return console.log('Fechou!');
      };
    }

    Client.prototype.send = function(obj) {
      return this.socket.send(obj);
    };

    Client.prototype.listen = function(msg, func) {
      return this.listening[msg] = func;
    };

    return Client;

  })();

  $(function() {
    var client;
    $("#game").svg({
      onLoad: function() {
        var svg;
        svg = $("#game").svg('get');
        return svg.load('map.svg', {
          addTo: true,
          changeSize: false
        });
      },
      settings: {}
    });
    client = new Client("ws://192.168.1.102:3000/websocket");
    client.listen('chat', function(msg) {
      var chat_window;
      chat_window = $('div#chat');
      return chat_window.append("&lt;" + msg.author + "&gt; " + msg.msg + "<br/>");
    });
    client.listen('warn', function(msg) {
      var chat_window;
      chat_window = $('div#chat');
      return chat_window.append("<span class=warn>" + msg.msg + "</span><br/>");
    });
    client.listen('set_nick', function(msg) {
      var l_el, nick_modal,
        _this = this;
      l_el = $('div#login');
      nick_modal = new Modal($('div#login'));
      nick_modal.open();
      l_el.find('input[type=button]').click(function() {
        var n;
        n = l_el.find('input[type=text]').val();
        if (n !== '') {
          _this.send({
            controller: 'set_nick',
            action: 'set',
            params: {
              nick: n
            }
          });
        }
        return nick_modal.close();
      });
      l_el.find('input[type=text]').keydown(function(eventObj) {
        var n;
        if (eventObj.keyCode === 13) {
          n = l_el.find('input[type=text]').val();
          if (n !== '') {
            _this.send({
              controller: 'set_nick',
              action: 'set',
              params: {
                nick: n
              }
            });
          }
          return nick_modal.close();
        }
      });
      return $('div#login').find('input[type=text]').focus();
    });
    client.listen('rooms', function(msg) {
      return console.log('OPEN_ROOMS ' + msg.list);
    });
    client.listen('player_list', function(msg) {
      return console.log('PLAYER_LIST ' + msg);
    });
    return client.listen('rooms_list', function(msg) {
      return console.log('ROOMS_LIST', msg);
    });
  });

}).call(this);

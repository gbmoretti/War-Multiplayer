(function() {
  var Client, WSConnection;

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

    WSConnection.prototype.on_close = function(func) {
      this.socket.onclose = func.call;
      return refreshStatus();
    };

    WSConnection.prototype.on_open = function(func) {
      this.socket.onopen = func.call;
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

    WSConnection.prototype.refreshStatus = function() {
      var state;
      state = this.socket.readyState;
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
      this.socket.on_msg = function(msg) {
        if (_this.listening[msg.name]) {
          _this.listening[msg.name].call(_this, msg.params);
        }
        if (!_this.listening[msg.name]) {
          return console.log('Nao estou ouvindo essa mensagem! ' + msg.name);
        }
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
    client = new Client("ws://192.168.1.102:3000/websocket");
    client.listen('print', function(msg) {
      var chat_window;
      chat_window = $('div#chat');
      return console.log('CHAT: ' + msg);
    });
    client.listen('warn', function(msg) {
      var chat_window;
      chat_window = $('div#chat');
      return console.log('WARN: ' + msg);
    });
    client.listen('set_nick', function(msg) {
      console.log('OPEN_SET_NICK: ' + msg);
      return this.send({
        controller: 'set_nick',
        action: 'set',
        nick: 'CLIENTE_BURRO'
      });
    });
    client.listen('rooms', function(msg) {
      return console.log('OPEN_ROOMS ' + msg);
    });
    client.listen('player_list', function(msg) {
      return console.log('PLAYER_LIST ' + msg);
    });
    return client.listen('rooms_list', function(msg) {
      return console.log('ROOMS_LIST', msg);
    });
  });

}).call(this);

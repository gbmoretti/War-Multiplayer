(function() {
  var AppController, ChatController, InitMessage, PlayerListController, SetNickController, TxtMessage, WSConnection;

  WSConnection = (function() {

    function WSConnection(addr, statusElmnt) {
      this.addr = addr;
      this.statusElmnt = statusElmnt != null ? statusElmnt : $('div#status');
      if ($.browser.mozilla) {
        this.socket = new MozWebSocket(this.addr);
      } else {
        this.socket = new WebSocket(this.addr);
      }
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

  TxtMessage = (function() {

    function TxtMessage(msg) {
      this.msg = msg;
      this.action = 'chat';
      this.type = 'txt';
    }

    return TxtMessage;

  })();

  InitMessage = (function() {

    function InitMessage(nick) {
      this.nick = nick;
      this.action = 'set_nick';
    }

    return InitMessage;

  })();

  ChatController = (function() {

    function ChatController(app) {
      var _this = this;
      this.app = app;
      this.controllerName = 'chat';
      this.inputElmnt = $('div#chatinput input[type=text]');
      this.chatElmnt = $('div#chat');
      this.inputElmnt.keydown(function(eventObject) {
        if (eventObject.keyCode === 13) return _this.sendTxt();
      });
    }

    ChatController.prototype.txt = function(msg) {
      this.chatElmnt.append('&lt' + msg.author + '&gt ' + msg.msg + '<br/>');
      return this.chatElmnt.scrollTop(this.chatElmnt.height());
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

    return ChatController;

  })();

  PlayerListController = (function() {

    function PlayerListController(app) {
      this.app = app;
      this.controllerName = 'playerList';
      this.listElmnt = $('div#players');
    }

    PlayerListController.prototype.update = function(args) {
      var nick, _i, _len, _ref, _results;
      this.listElmnt.html('');
      _ref = args.list;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        nick = _ref[_i];
        _results.push(this.listElmnt.append("<div class='nick'>" + nick + "</div>"));
      }
      return _results;
    };

    return PlayerListController;

  })();

  InitMessage = (function() {

    function InitMessage(nick) {
      this.nick = nick;
      this.action = 'set_nick';
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
      this.btn.click(function() {
        return _this.setNick();
      });
      this.inputNick.keydown(function(eventObject) {
        if (eventObject.keyCode === 13) return _this.setNick();
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

  AppController = (function() {

    function AppController(wsAddr) {
      var self;
      this.wsAddr = wsAddr;
      this.conn = null;
      this.user = 'nick';
      this.controllers = {};
      self = this;
      $('.closebtn').click(function() {
        return self.closeModal($(this).parent());
      });
    }

    AppController.prototype.add_controller = function(obj) {
      return this.controllers[obj.controllerName] = obj;
    };

    AppController.prototype.openModal = function(elmnt) {
      $('.modal-overlay').show();
      return elmnt.show();
    };

    AppController.prototype.closeModal = function(elmnt) {
      elmnt.hide();
      return $('.modal-overlay').hide();
    };

    AppController.prototype.start = function() {
      var _this = this;
      this.conn = new WSConnection(this.wsAddr);
      this.conn.socket.onopen = function() {
        return _this.conn.refreshStatus();
      };
      this.conn.socket.onclose = function() {
        return _this.conn.refreshStatus();
      };
      return this.conn.socket.onmessage = function(msg) {
        var c_name, controller, msgObj;
        msgObj = eval("(" + msg.data + ")");
        c_name = msgObj.controller;
        console.log("" + c_name + "#" + msgObj.action + "(" + msgObj.params + ")");
        controller = _this.controllers[c_name];
        console.log(controller);
        if (msgObj.params === '') controller[msgObj.action]();
        if (msgObj.params !== '') return controller[msgObj.action](msgObj.params);
      };
    };

    return AppController;

  })();

  $(function() {
    var app;
    app = new AppController("ws://192.168.1.102:3000/websocket");
    app.add_controller(new ChatController(app));
    app.add_controller(new PlayerListController(app));
    app.add_controller(new SetNickController(app));
    return app.start();
  });

}).call(this);

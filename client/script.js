(function() {
  var AppController, ChatController, InitMessage, NewRoomMessage, PlayerListController, RoomsController, SetNickController, TxtMessage, WSConnection;

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
      this.btnElmnt = $('div#btnchat');
      this.chatWindow.hide(0);
      this.inputElmnt.keydown(function(eventObject) {
        if (eventObject.keyCode === 13) return _this.sendTxt();
      });
      this.btnElmnt.click(function(eventObject) {
        return _this.chatWindow.toggle(0);
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

  NewRoomMessage = (function() {

    function NewRoomMessage(name) {
      this.controller = 'rooms';
      this.action = 'new_room';
      this.params = {
        'name': name
      };
    }

    return NewRoomMessage;

  })();

  RoomsController = (function() {

    function RoomsController(app) {
      var _this = this;
      this.app = app;
      this.controllerName = 'rooms';
      this.modal = $('.modal-div#rooms');
      this.listElmt = this.modal.find('ul');
      this.btn = this.modal.find('button');
      this.input = this.modal.find('input');
      this.btn.click(function() {
        if (_this.input.val !== '') return _this.newRoom(_this.input.val());
      });
      this.input.keydown(function(eventObject) {
        if (eventObject.keyCode === 13) return _this.btn.click;
      });
    }

    RoomsController.prototype.list = function(msg) {
      var sala, _i, _len, _ref;
      this.list = msg.list;
      _ref = this.list;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        sala = _ref[_i];
        console.log(sala);
        this.listElmt.append('<li id="sala">' + sala + '</li>');
      }
      if (this.list.length === 0) {
        this.listElmt.append('<li id="none">Nenhuma sala encontrada</li>');
      }
      return this.open();
    };

    RoomsController.prototype.open = function(msg) {
      return this.app.openModal(this.modal);
    };

    RoomsController.prototype.newRoom = function(name) {
      console.log('Criando nova sala com o nome de ' + name);
      return this.app.conn.send(new NewRoomMessage(name));
    };

    return RoomsController;

  })();

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
        console.log(_this.controllers);
        controller = _this.controllers[c_name];
        if (msgObj.params === '') controller[msgObj.action]();
        if (msgObj.params !== '') return controller[msgObj.action](msgObj.params);
      };
    };

    return AppController;

  })();

  $(function() {
    var app;
    app = new AppController("ws://localhost:3000/websocket");
    app.add_controller(new ChatController(app));
    app.add_controller(new PlayerListController(app));
    app.add_controller(new SetNickController(app));
    app.add_controller(new RoomsController(app));
    app.start();
    return $("#game").svg({
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
  });

}).call(this);

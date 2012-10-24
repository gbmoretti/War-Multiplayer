/* controlador de lista de salas */
  var JoinRoomMessage, NewRoomMessage, RoomsController;

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

  JoinRoomMessage = (function() {

    function JoinRoomMessage(sala) {
      this.controller = 'rooms';
      this.action = 'join';
      this.params = {
        'room': sala
      };
    }

    return JoinRoomMessage;

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
      this.linkJoin = this.modal.find('ul a');
      this.openBtn = $('#btnrooms');
      this.btn.click(function() {
        if (_this.input.val !== '') {
          return _this.newRoom(_this.input.val());
        }
      });
      this.openBtn.click(function() {
        return _this.open(null);
      });
      this.input.keydown(function(eventObject) {
        if (eventObject.keyCode === 13) {
          return _this.btn.click;
        }
      });
      this.linkJoin.live('click', function(o) {
        return _this.joinRoom($(o.target).attr('sala'));
      });
    }

    RoomsController.prototype.list = function(msg) {
      var list, sala, _i, _len;
      list = msg.list;
      this.listElmt.html('');
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        sala = list[_i];
        html = '<li class="sala">' + sala.name + ' (' + sala.players.length + '/' + sala.size + ')' ;
        if (sala.players.length < sala.size && sala.game === false) html += ' <a href="#" class="join" sala=' + sala.id + '>entrar</a>';
        html += '</li>';
        this.listElmt.append(html);
      }
      if (list.length === 0) {
        return this.listElmt.append('<li id="none">Nenhuma sala encontrada</li>');
      }
    };

    RoomsController.prototype.open = function(msg) {
      return this.app.openModal(this.modal);
    };

    RoomsController.prototype.newRoom = function(name) {
      this.app.conn.send(new NewRoomMessage(name));
      return this.app.closeModal(this.modal);
    };

    RoomsController.prototype.joinRoom = function(sala) {
      this.app.conn.send(new JoinRoomMessage(sala));
      return this.app.closeModal(this.modal);
    };

    return RoomsController;

  })();


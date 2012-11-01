/* controlador da janela pré-jogo, onde se definem os jogadores e as cores */
  var ChangeColorMessage, PregameController, ToggleStateMessage;

  ChangeColorMessage = (function() {

    function ChangeColorMessage(i) {
      this.controller = 'pregame';
      this.action = 'change_color';
      this.params = {
        'color': i
      };
    }

    return ChangeColorMessage;

  })();

  ToggleStateMessage = (function() {

    function ToggleStateMessage() {
      this.controller = 'pregame';
      this.action = 'toggle_state';
      this.params = {};
    }

    return ToggleStateMessage;

  })();
  
  AddIaMessage = (function() {

    function AddIaMessage() {
      this.controller = 'pregame';
      this.action = 'add_ia';
      this.params = {};
    }

    return AddIaMessage;

  })();

  PregameController = (function() {

    function PregameController(app) {
      var _this = this;
      this.app = app;
      this.controllerName = 'pregame';
      this.modal = $('.modal-div#pregame');
      this.players = this.modal.find('ul#players');
      this.colorSelect = this.modal.find('select[name=colors]');
      this.readyButton = this.modal.find('button#ready');
      this.addIaButton = this.modal.find("button#addia");
      this.title = null;
      this.list = null;
      this.is_owner = false;
      this.colorSelect.change(function(eventObject) {
        var index;
        index = $(eventObject.target).val();
        return _this.app.conn.send(new ChangeColorMessage(index));
      });
      this.readyButton.click(function(eventObject) {
        return _this.app.conn.send(new ToggleStateMessage());
      });
      
    }

    PregameController.prototype.update_ia_button = function() {
      var _this = this;
      
      if(!this.is_owner) {
        this.addIaButton.hide();
      }else {
        this.addIaButton.click(function() {
          _this.app.conn.send(new AddIaMessage());
        });
      }
    };

    PregameController.prototype.open = function(msg) {    
      var color, i, _ref;
      this.colorSelect.html('');
      _ref = this.app.controllers['definitions'].get_colors();
      for (i in _ref) {
        color = _ref[i];
        this.colorSelect.append("<option value=" + i + " style=\"color: " + color.hex + "\">" + color.name + "</option>");
      }
      return this.app.openModal(this.modal);
    };

    PregameController.prototype.close = function(msg) {
      return this.app.closeModal(this.modal);
    };

    PregameController.prototype.update = function(msg) {
      this.modal.find('div#modal-title').html(msg.name);
      this.players.html('');
      this.list = msg.players;
      return this.update_list();
    };

    PregameController.prototype.set_owner = function(msg) {
      console.log(msg.is_owner);
      this.is_owner = msg.is_owner;
      this.update_ia_button();
    };

    PregameController.prototype.update_player = function(msg) {
      this.list[msg.index].nick = msg.nick;
      this.list[msg.index].color = msg.color;
      this.list[msg.index].ready = msg.ready;
      return this.update_list();
    };

    PregameController.prototype.update_list = function(list) {
      var colors, hex, p, _i, _len, _ref, _results, line;
      this.players.html('');
      _ref = this.list;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        colors = this.app.controllers['definitions'].get_colors();
        hex = colors[p.color].hex;
        line = '<li>';
        line += '<div class=\"ready-state\" id="' + p.ready + '">';
        line += p.ready ? 'Pronto' : 'Aguardando';
        line += "</div><div class=\"color\" style=\"background-color: " + hex + "\">&nbsp;</div>";
        line += "</div> " + p.nick + "</li>"
        this.players.append(line);
      }
    };

    return PregameController;

  })();


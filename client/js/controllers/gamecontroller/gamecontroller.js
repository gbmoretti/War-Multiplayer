/*
Controller game. Responsavel por por manipular os eventos em todas as fases do jogo
*/

  var EndAttackMessage, EndDistributionMessage, EndMovementMessage, GameController;

  EndDistributionMessage = (function() {

    function EndDistributionMessage(id, d) {
      this.controller = 'game';
      this.action = 'distribution_end';
      this.params = {
        'id': id,
        'territories': d
      };
    }

    return EndDistributionMessage;

  })();

  EndAttackMessage = (function() {

    function EndAttackMessage(id) {
      this.controller = 'game';
      this.action = 'attack_end';
      this.params = {
        'id': id
      };
    }

    return EndAttackMessage;

  })();

  EndMovementMessage = (function() {

    function EndMovementMessage(id, m) {
      this.controller = 'game';
      this.action = 'movement_end';
      this.params = {
        'id': id,
        'm': m
      };
    }

    return EndMovementMessage;

  })();

  GameController = (function() {

    function GameController(app) {
      this.app = app;
      this.controllerName = 'game';
      this.roomid = null;
      this.playerid = null;
      this.roomname = null;
      this.rightbar = $('div#rightbar');
      this.territories = null;
      this.cards = null;
      this.objective = null;
      this.phase = null;
      this.attackController = null;
    }

    //método chamado para iniciar a fase de distribuição
    GameController.prototype.distribution = function(msg) {
      var distribution;
      return distribution = new Distribution(msg.bonus, this.territories, this.app.controllers['action'], this, (function(d) {
        this.app.conn.send(new EndDistributionMessage(this.roomid, d));
        return distribution = null;
      }));
    };

    //chamado para iniciar fase de ataque
    GameController.prototype.attack = function(msg) {
      return this.attackController = new Attack(this.app, this.app.controllers['definitions'].get_territories(), this.territories, this.app.controllers['action'], this, (function() {
        this.app.conn.send(new EndAttackMessage(this.roomid));
        return this.attackController = null;
      }));
    };

    //recebe resultado do ataque e reenvia para classe de ataque (Attack)
    GameController.prototype.attack_result = function(msg) {
      return this.attackController.attackWindow(msg);
    };

    //chamado para iniciar fase de movimentação
    GameController.prototype.movement = function(msg) {
      var movement;
      return movement = new Movement(this.territories, this.app.controllers['definitions'].get_territories(), this.app.controllers['action'], this, (function(m) {
        return this.app.conn.send(new EndMovementMessage(this.roomid, m));
      }));
    };

    //recebe informações do jogador
    GameController.prototype.update_status = function(msg) {
      var phase_line, status_bar, str;
      this.territories = msg.territories;
      this.phase = msg.phase;
      this.playerid = msg.id;
      status_bar = this.rightbar.find('div#player-status .content');
      status_bar.html('');
      status_bar.append("<div class=\"status-line\">Exércitos: " + msg.troops + "</div>");
      status_bar.append("<div class=\"status-line\">Bônus: " + msg.bonus + "</div>");
      status_bar.append("<div class=\"status-line\">Territórios: " + this.territories.length + "</div>");
      this.cards = msg.cards;
      str = "<div class=\"status-line\">Cartas: " + this.cards + "</div>";
      status_bar.append(str);
      phase_line = this.rightbar.find('div.phase-line');
      phase_line.each(function(i, o) {
        o = $(o);
        o.removeClass('active');
        return o.removeClass('possibnext');
      });
      this.rightbar.find('div.phase-line#phase' + this.phase).addClass('active');
      if (this.attackController !== null) {
        return this.attackController.updateTerritories_id(this.territories);
      }
    };

    //recebe objetivo
    GameController.prototype.update_objective = function(msg) {
      var objective_bar;
      this.objective = msg.objective;
      objective_bar = this.rightbar.find('div#objetivo #texto-objetivo');
      return objective_bar.html(this.objective);
    };

    //recebe dados do mapa
    GameController.prototype.update_territories = function(msg) {
      var color, i, max, owner, t, _results;
      max = msg.length;
      i = 0;
      _results = [];
      while (i < max) {
        t = msg[i];
        owner = this.players[t.owner];
        color = this.app.controllers['definitions'].colors[owner.color];
        this.change_color(t.id, color.hex);
        this.change_troops(t.id, t.troops);
        _results.push(i++);
      }
      return _results;
    };

    //recebe dados da sala
    GameController.prototype.update_room_data = function(msg) {
      this.roomname = msg.name;
      return this.roomid = msg.id;
    };

    //recebe dados dos outros jogadores da sala
    GameController.prototype.update_players = function(msg) {
      this.players = msg;
      return this.update_rightbar();
    };

    //atualiza barra lateral direita
    GameController.prototype.update_rightbar = function() {
      var color, id, pl, player, player_line, _ref, _results;
      pl = this.rightbar.find('div#playerslist');
      pl.html("<div id=\"title\">" + this.roomname + "</div>");
      _ref = this.players;
      _results = [];
      for (id in _ref) {
        player = _ref[id];
        color = this.app.controllers['definitions'].colors[player.color];
        player_line = "<div class=player>" + player.nick + "</div>      <div class=\"color\" style=\"background-color: " + color.hex + ";\"></div>      <div class=\"turn\"";
        if (player.turn) {
          player_line += " id=\"active\"";
        }
        player_line += "></div>";
        _results.push(pl.append(player_line));
      }
      return _results;
    };

    //responsavel por mudar a cor de um territorio e, se for o caso, mudar a cor do texto
    GameController.prototype.change_color = function(id, color) {
      $('path#' + id).attr('fill', color);
      if (color === '#0000DD' || color === '#333333') {
        $('#l' + id + ' tspan').attr('fill', '#FFFFFF');
        return $('#l' + id + ' tspan').attr('stroke', '#FFFFFF');
      }
    };

    //muda quantidade de tropas em um territorio
    GameController.prototype.change_troops = function(id, troops) {
      var o;
      o = $('#l' + id);
      return o.find('tspan').text(troops);
    };

    return GameController;

  })();


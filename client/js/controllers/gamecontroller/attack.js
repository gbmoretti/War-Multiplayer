/*
Classe responsavel por manipular os eventos durante a fase de ataque
*/
  var Attack, AttackMessage;

  AttackMessage = (function() {

    function AttackMessage(origin, destiny, qtd) {
      this.controller = 'game';
      this.action = 'attack_order';
      this.params = {
        'origin': origin,
        'destiny': destiny,
        'qtd': qtd
      };
    }

    return AttackMessage;

  })();

  Attack = (function() {

    function Attack(app, allTerritories, territories, actionController, callBackContext, callBackFunction) {
      var _this = this;
      this.app = app;
      this.allTerritories = allTerritories; //todos os territorios do jogo
      this.territories = territories; //territorios que o jogador possui
      this.actionController = actionController; //controller da janela de mensagem
      this.callBackContext = callBackContext; //contexto em que a funcao callback sera chamada
      this.callBackFunction = callBackFunction; //funcao callback
      this.modal = $('.modal-div#attack'); //janela de status do ataque
      this.nomeAtk = this.modal.find('.nome_atk');
      this.nomeDef = this.modal.find('.nome_def');
      this.troopsAtk = this.modal.find('#troops_atk');
      this.troopsDef = this.modal.find('#troops_def');
      this.selectTroops = this.modal.find('#qtd_troops');
      this.atkButton = this.modal.find('#btnattack');
      this.resultDiv = this.modal.find('#result');
      this.territories_id = null;
      this.divEndPhase = "<div style=\"text-align: right\"><button id=\"endattack\">Terminei ataque</button></div>";
      
      this.modal.find("#parar").click(function() {
        _this.app.closeModal(_this.modal);
        return _this.reset();
      });
      $(document).on('click', 'button#endattack', function() {
        return _this.endPhase();
      });
      this.updateTerritories_id(this.territories);
      this.chooseOrigin();
    }

    //método chamado quando a fase é terminada. Desliga os eventos e chama a função de callback
    Attack.prototype.endPhase = function() {
      $('button#endattack').off("click");
      $('button#parar').off("click")
      $("path").off("hover click");
      return this.callBackFunction.call(this.callBackContext, null);
    };

    //atualiza vetor territories_id com os id's dos territorios que o jogador possiu
    Attack.prototype.updateTerritories_id = function(territories) {
      var t, _i, _len, _results;
      this.territories_id = [];
      _results = [];
      for (_i = 0, _len = territories.length; _i < _len; _i++) {
        t = territories[_i];
        _results.push(this.territories_id.push(t.id));
      }
      return _results;
    };

    //recomeça a fase de ataque
    Attack.prototype.reset = function() {
      $('path').off("hover click");
      $('path').attr('stroke-width', 1);
      return this.chooseOrigin();
    };

    //método para escolhar territorio de origem do ataque
    Attack.prototype.chooseOrigin = function() {
      var id, self, _i, _len, _ref, _results, troops;
      self = this;
      this.origin_id = null;
      this.destiny_id = null;
      this.actionController.open("Ataque", "Escolha um território para ser a origem do ataque" + this.divEndPhase);
      _ref = this.territories_id;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        $('#' + id).hover(function(o) {          
          troops = $("#l" + $(this).attr('id')).find("tspan").text();
          if (troops !== '1') {
            $(this).attr('stroke-width', 2);
          }
        }, function(o) {
          if ($(this).attr('id') !== self.origin_id) {
            $(this).attr('stroke-width', 1);
          }
        });
        
        $('#' + id).click(function(o) {
          troops = $("#l" + $(this).attr('id')).find("tspan").text();
          if (troops !== '1') {
            self.origin_id = $(this).attr('id');
            self.chooseDestiny();
          }else {
            self.actionController.open("Ataque", "Escolha um território para ser a origem do ataque. Apenas territórios com mais de 1 exército podem ser origem de ataque." + self.divEndPhase);
          }
        });
      }      
    };

    //método para escolher territorio alvo do ataque
    Attack.prototype.chooseDestiny = function() {
      var nome, self, t, _i, _len, _ref;
      $('path').off("hover click");
      self = this;
      nome = this.allTerritories[this.origin_id].nome;
      this.actionController.open("Ataque", ("Escolha um território alvo<br/>Atacando de <b>" + nome + "</b>") + this.divEndPhase);
      _ref = this.allTerritories[this.origin_id].vizinhos;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        if ($.inArray(t + "",this.territories_id) === -1) {
          $('#' + t).hover(function(o) {
            return $(this).attr('stroke-width', 2);
          }, function(o) {
            if ($(this).attr('id') !== self.destiny_id) {
              return $(this).attr('stroke-width', 1);
            }
          });
          $('#' + t).click(function(o) {
            id = parseInt($(this).attr('id'));
            if ($.inArray(t + "",this.territories_id) !== -1) {
              self.reset();
            }else {
              self.destiny_id = $(this).attr('id');
              self.attackWindow();
            }
            
          });
        }
        
      }
      return $('#' + this.origin_id).click(function() {
        return self.reset();
      });
    };

    //janela de status do ataque
    Attack.prototype.attackWindow = function(result) {
      var html, qtd_troops, terAtk, terDef,
        _this = this;
      
      $('path').off("hover click");
      this.actionController.close();
      
      terAtk = this.allTerritories[this.origin_id].nome;
      terDef = this.allTerritories[this.destiny_id].nome;
      
      this.nomeAtk.text(terAtk);
      this.nomeDef.text(terDef);

      this.troopsAtk.text($('#l' + this.origin_id + ' tspan').text());
      this.troopsDef.text($('#l' + this.destiny_id + ' tspan').text());
      qtd_troops = parseInt($('#l' + this.origin_id + ' tspan').text());
      qtd_troops -= 1;
      if (qtd_troops > 3) {
        qtd_troops = 3;
      }
      this.selectTroops.html("");
      while (qtd_troops > 0) {
        this.selectTroops.append("<option value=\"" + qtd_troops + "\">" + qtd_troops + "</option>");
        qtd_troops--;
      }
      $("div#attack_actions").show();
      this.resultDiv.html("");
      this.app.openModal(this.modal);
      this.atkButton.off("click");
      this.atkButton.html("Atacar!");
      this.atkButton.click(function() {
        return _this.app.conn.send(new AttackMessage(_this.origin_id, _this.destiny_id, _this.selectTroops.val()));
      });
      if (result != null) {
        html = "Resultados do último ataque:<br/>";
        html += terAtk + " perdeu " + result.atk.lost + " exércitos (" + result.atk.dice[0] + " / ";
        html += (result.atk.dice[1] == 0 ? '-' : result.atk.dice[1]) + " / "; 
        html += (result.atk.dice[2] == 0 ? '-' : result.atk.dice[2]) + ")<br/>";
        html += terDef + " perdeu " + result.def.lost + " exércitos (" + result.def.dice[0] + " / "
        html += (result.def.dice[1] == 0 ? '-' : result.def.dice[1]) + " / "
        html += (result.def.dice[2] == 0 ? '-' : result.def.dice[2]) + ")<br/>";
        this.resultDiv.html(html);
        if (result.winner !== null) {
          $("div#attack_actions").hide();
        }
      }
    };

    return Attack;

  })();


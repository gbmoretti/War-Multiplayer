/*
Classe responsavel pelos eventos da fase de movimentação
*/
  var Movement;

  Movement = (function() {

    function Movement(app, territories, allTerritories, actionController, callBackContext, callBackFunction) {
      var t, _i, _len, _ref,
        _this = this;
      this.app = app;
      this.territories = territories; //territorios do jogador
      this.allTerritories = allTerritories; //todos os territorios do jogo
      this.actionController = actionController;
      this.callBackContext = callBackContext;
      this.callBackFunction = callBackFunction;
      this.modal = $("div#movement");
      this.territories_id = null;
      this.movement = {};
      this.divEndPhase = "<div style=\"text-align: right\"><button id=\"endmovement\">Terminei movimentação</button></div>";
      this.divCancel = "<div style=\"text-align: right\"><button id=\"cancelmovement\">Escolher outro território</button> <button id=\"endmovement\">Terminei movimentação</button></div>"
      $(document).off("click", 'button#endmovement');
      $(document).off("click", 'button#cancelmovement');
      
      $(document).on('click', 'button#endmovement', function() {
        return _this.endPhase();
      });
      
      $(document).on('click', 'button#cancelmovement',function() {
        _this.reset();
      });
      
      this.updateTerritories_id(this.territories);
      this.total_movement = {};
      _ref = this.territories;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        this.total_movement[t.id] = parseInt($('#l' + t.id + ' tspan').text());
        this.total_movement[t.id] -= 1;
      }
      this.chooseOrigin();
    }
    
    //termina a fase e chama funcao callback
    Movement.prototype.endPhase = function() {
      $('button#endmovement').off("click");
      $("path").off("hover click");
      this.actionController.close();
      return this.callBackFunction.call(this.callBackContext, this.movement);
    };

    //atualiza vetor de id's dos territorios que o jogador é o dono
    Movement.prototype.updateTerritories_id = function(territories) {
      var t, _i, _len, _results;
      this.territories_id = [];
      _results = [];
      for (_i = 0, _len = territories.length; _i < _len; _i++) {
        t = territories[_i];
        _results.push(this.territories_id.push(t.id));
      }
      return _results;
    };

    //reinicia a fase
    Movement.prototype.reset = function() {
      $('path').off("hover click");
      this.app.controllers['game'].refresh_colors();
      this.app.closeModal(this.modal);
      this.chooseOrigin();
    };

    //método para escolher territorio origem
    Movement.prototype.chooseOrigin = function() {
      var id, self, _i, _len, _ref, _results, list;
      self = this;
      this.origin_id = null;
      this.destiny_id = null;
      this.actionController.open("Movimentação de exércitos", "Escolha um território para mover tropas" + this.divEndPhase);
      
      list = this.territories.map(function(o) { return o.troops > 1 ? o.id : '0'; });
      selectable_territories(list,this,function(id) {
        if (this.total_movement[id] !== void 0 || this.total_movement[id] > 1) {
            this.origin_id = id;
            this.chooseDestiny();
          }
      });
      
    };

    //método para escolher territorio destino
    Movement.prototype.chooseDestiny = function() {
      var nome, self, t, _i, _len, _ref, list;
      
      self = this;
      nome = this.allTerritories[this.origin_id].nome;
      this.actionController.open("Movimentação de exércitos", ("Clique em um território vizinho ao " + nome + " para receber uma tropa.") + this.divCancel);
      
      list = [];
      for(i in this.allTerritories[this.origin_id].vizinhos) {
        v = this.allTerritories[this.origin_id].vizinhos[i];
        if($.inArray(v + "",this.territories_id) !== -1) {
          list.push(v);
        }
      }
      
      selectable_territories(list,this,function(id) {
        this.destiny_id = id;
        //this.move(this.origin_id, this.destiny_id);
        this.movementWindow();
      });
      
    };

    Movement.prototype.movementWindow = function() {
      var select, i, max, _this;
      
      _this = this;
      select = this.modal.find("select[name=qtd]");
      select.html("");
      max = this.total_movement[this.origin_id];
      for(i=1;i<=max;i++) {
        select.append("<option>" + i + "</option>");
      }
      
      $("button#cancelmovement").off("click");
      $("button#makemovement").off("click");
      $("button#cancelmovement").click(function() {
        _this.reset();
        _this.app.closeModal(this.modal);
      });
      $("button#makemovement").click(function() {
        console.log('movendo: ' + select.val());
        _this.move(_this.origin_id,_this.destiny_id,select.val());
      });
      
      this.modal.find("span#nome1").text(this.allTerritories[this.origin_id].nome);
      this.modal.find("span#nome2").text(this.allTerritories[this.destiny_id].nome);
      
      this.app.openModal(this.modal);
    };

    //executa a movimentação
    Movement.prototype.move = function(origin, destiny, qtd) {
      var t, total;
      qtd = parseInt(qtd);
      if (qtd > this.total_movement[origin]) qtd = this.total_movement[origin];
      if (this.total_movement[origin] === 0) {
        return this.reset();
      }
      this.total_movement[origin] -= qtd;
      if (this.movement[origin] === void 0) {
        this.movement[origin] = {};
      }
      if (this.movement[origin][destiny] === void 0) {
        this.movement[origin][destiny] = 0;
      }
      this.movement[origin][destiny] += qtd;
      t = $("#l" + origin + " tspan");
      total = parseInt(t.text());
      total -= qtd;
      t.text(total);
      t = $("#l" + destiny + " tspan");
      total = parseInt(t.text());
      total += qtd;
      t.text(total);
      this.app.closeModal(this.modal);
      return this.chooseDestiny();
    };

    return Movement;

  })();


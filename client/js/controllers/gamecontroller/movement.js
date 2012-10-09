/*
Classe responsavel pelos eventos da fase de movimentação
*/
  var Movement;

  Movement = (function() {

    function Movement(territories, allTerritories, actionController, callBackContext, callBackFunction) {
      var t, _i, _len, _ref,
        _this = this;
      this.territories = territories; //territorios do jogador
      this.allTerritories = allTerritories; //todos os territorios do jogo
      this.actionController = actionController;
      this.callBackContext = callBackContext;
      this.callBackFunction = callBackFunction;
      this.territories_id = null;
      this.movement = {};
      this.divEndPhase = "<div style=\"text-align: right\"><button id=\"endmovement\">Terminei movimentação</button></div>";
      $(document).off("click", 'button#endmovement');
      $(document).on('click', 'button#endmovement', function() {
        return _this.endPhase();
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
      console.log(this.territories_id);
      return _results;
    };

    //reinicia a fase
    Movement.prototype.reset = function() {
      $('path').off("hover click");
      $('path').attr('stroke-width', 1);
      return this.chooseOrigin();
    };

    //método para escolher territorio origem
    Movement.prototype.chooseOrigin = function() {
      var id, self, _i, _len, _ref, _results;
      self = this;
      this.origin_id = null;
      this.destiny_id = null;
      this.actionController.open("Movimentação de exércitos", "Escolha um território para mover tropas" + this.divEndPhase);
      $("path").off("hover click");
      _ref = this.territories_id;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        $('#' + id).hover(function(o) {
          var t_id;
          t_id = $(this).attr('id');
          if (self.total_movement[t_id] !== 0) {
            return $(this).attr('stroke-width', 2);
          }
        }, function(o) {
          if ($(this).attr('id') !== self.origin_id) {
            return $(this).attr('stroke-width', 1);
          }
        });
        _results.push($('#' + id).click(function(o) {
          var t_id;
          t_id = $(this).attr('id');
          if (self.total_movement[t_id] !== void 0 || self.total_movement[t_id] > 1) {
            self.origin_id = $(this).attr('id');
            return self.chooseDestiny();
          }
        }));
      }
      return _results;
    };

    //método para escolher territorio destino
    Movement.prototype.chooseDestiny = function() {
      var nome, self, t, _i, _len, _ref;
      $('path').off("hover click");
      self = this;
      nome = this.allTerritories[this.origin_id].nome;
      this.actionController.open("Movimentação de exércitos", ("Clique em um território vizinho ao " + nome + " para receber uma tropa.") + this.divEndPhase);
      _ref = this.allTerritories[this.origin_id].vizinhos;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        if ($.inArray(t + "", this.territories_id) > -1) {
          $('#' + t).hover(function(o) {
            return $(this).attr('stroke-width', 2);
          }, function(o) {
            if ($(this).attr('id') !== self.destiny_id) {
              return $(this).attr('stroke-width', 1);
            }
          });
          $('#' + t).click(function(o) {
            if ($(this).attr('id') === self.origin_id) {
              self.reset();
            }
            self.destiny_id = $(this).attr('id');
            return self.move(self.origin_id, self.destiny_id);
          });
        }
      }
      return $('#' + this.origin_id).click(function() {
        return self.reset();
      });
    };

    //executa a movimentação
    Movement.prototype.move = function(origin, destiny) {
      var t, total;
      if (this.total_movement[origin] === 0) {
        return this.reset();
      }
      this.total_movement[origin] -= 1;
      if (this.movement[origin] === void 0) {
        this.movement[origin] = {};
      }
      if (this.movement[origin][destiny] === void 0) {
        this.movement[origin][destiny] = 0;
      }
      this.movement[origin][destiny] += 1;
      t = $("#l" + origin + " tspan");
      total = parseInt(t.text());
      total -= 1;
      t.text(total);
      t = $("#l" + destiny + " tspan");
      total = parseInt(t.text());
      total += 1;
      t.text(total);
      return this.chooseDestiny();
    };

    return Movement;

  })();


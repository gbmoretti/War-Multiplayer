/* 
Classe responsavel por manipular os eventos durante a fase de distribuição
*/

  var Distribution;

  Distribution = (function() {

    function Distribution(bonus, territories, allTerritories, regions, actionController, callBackContext, callBackFunction) {
      var i, t, _ref,
        _this = this;
      this.bonus = $.extend(true, {}, bonus); //clonando objeto
      this.territories = territories; //vetor com os territorios do jogador
      this.allTerritories = allTerritories; //vetor com todos os territorios do tabuleiro
      this.regions = regions //vetor com todas as regioes do jogo
      this.actionController = actionController; //controller da janela de ação
      this.callBackContext = callBackContext; //contexto em que a funcao callback sera chamada
      this.callBackFunction = callBackFunction; //funcao callback
      this.distribuition = {}; //vetor que guarda as movimentações feita pelo jogador
      this.update_action();
      _ref = this.territories;
      for (i in _ref) {
        t = _ref[i];
        $('path#' + t.id).hover(function(o) {
          return $(this).attr('stroke-width', 2);
        }, function(o) {
          return $(this).attr('stroke-width', 1);
        });
        $('path#' + t.id).click(function(o) {
          return _this.add_troop($(this).attr('id'));
        });
      }
    }

    Distribution.prototype.reset = function() {
      $('path').off("hover click");
      this.actionController.close();
      this.callBackFunction.call(this.callBackContext, null);
    }

    Distribution.prototype.confirm = function() {
      $('path').off("hover click");
      this.actionController.close();
      this.callBackFunction.call(this.callBackContext, this.distribuition);
    }

    //adiciona uma tropa no territorio com id 'id'
    Distribution.prototype.add_troop = function(id) {
      var i, o, t, x, _ref, territory, sum_bonus, flag, _this;
      
      _this = this;
      sum_bonus = 0;
      _ref = this.bonus;
      for(i in _ref) {      
        sum_bonus += parseInt(_ref[i]); 
      }
      
      territory = this.allTerritories[id];
      
      if (sum_bonus > 0) {
        flag = false;
        region = territory.region;
        if (this.bonus[region] !== void 0 && this.bonus[region] !== 0) {
          this.bonus[region]--;
          flag = true;
        }else if (this.bonus['troops'] > 0) {
          this.bonus['troops']--;
          flag = true;
        }
        
        if (this.distribuition[id] === void 0) {
          this.distribuition[id] = 0;
        }
        
        if (flag) {
          this.distribuition[id]++;
          o = $('#l' + id + " tspan");
          x = o.text();
          o.text(parseInt(x) + 1);
          this.update_action();
        }
        
      }
      
      sum_bonus = 0;
      _ref = this.bonus;
      for(i in _ref) {      
        sum_bonus += parseInt(_ref[i]); 
      }
      if (sum_bonus === 0) {
        _ref = this.territories;
        for (i in _ref) {
          t = _ref[i];
          $('path#' + t.id).attr('stroke-width', 1);
        }
        msg = 'Não há mais exércitos para distribuir.<br/>';
        msg += '<div style="text-align: right;"><button id="confirm_distribuition">Confirmar distribuição</button>';
        msg += '<button id="reset_distribuition">Recomeçar</button></div>';
        this.actionController.open('Distribuição de exércitos', msg);
        
        $("button#confirm_distribuition").click(function() {
          _this.confirm();
        });
        $("button#reset_distribuition").off();
        $("button#reset_distribuition").click(function() {
          _this.reset();
        });
      }
    };


    //atualiza janela de ação
    Distribution.prototype.update_action = function(b) {
      var msg, bonus, i, _this;
      
      _this = this;
      msg = "Para adicionar exércitos a um território, clique com o botão esquerdo do mouse sobre um território com sua cor.<br/>"
      msg += "Você tem <b>" + this.bonus['troops'] + "</b> tropas para distribuir em qualquer território.";
      
      bonus = $.extend(true, {}, this.bonus); //clonando objeto
      delete bonus['troops'];
      if(Object.keys(bonus).length > 0) {
        msg += " E ";
        
        for(i in bonus) {
          msg += bonus[i] + " na <b>" + this.regions[i].nome + "</b>. ";
        }
      }

      msg += '<div style="text-align: right;"><button id="reset_distribuition">Recomeçar</button></div>'
      this.actionController.open('Distribuição de exércitos', msg);
      
      $("button#reset_distribuition").off();
      $("button#reset_distribuition").click(function() {
          _this.reset();
      });
    };

    return Distribution;

  })();


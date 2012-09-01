/* 
Classe responsavel por manipular os eventos durante a fase de distribuição
*/

  var Distribution;

  Distribution = (function() {

    function Distribution(bonus, territories, actionController, callBackContext, callBackFunction) {
      var i, t, _ref,
        _this = this;
      this.bonus = bonus;

      this.territories = territories; //vetor com os territorios do jogador
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
          return _this.add_troop(o.currentTarget.id);
        });
      }
    }

    //adiciona uma tropa no territorio com id 'id'
    Distribution.prototype.add_troop = function(id) {
      var i, o, t, x, _ref, territory, sum_bonus;
      
      sum_bonus = 0;
      _ref = this.bonus;
      for(i in _ref) {      
        sum_bonus += parseInt(_ref[i]); 
      }

      if (sum_bonus > 0) {
        region = this.territories[id].region;
        if (this.bonus[region] != undefined || this.bonus[region] != 0) {
          this.bonus[region]--;
        }else {
          this.bonus['troops']--;
        }
        
        if (this.distribuition[id] === void 0) {
          this.distribuition[id] = 0;
        }
        this.distribuition[id] = this.distribuition[id] + 1;
        o = $('#l' + id + " tspan");
        x = o.text();
        o.text(parseInt(x) + 1);
        this.update_action();
      }
      if (sum_bonus === 0) {
        _ref = this.territories;
        for (i in _ref) {
          t = _ref[i];
          $('path#' + t.id).attr('stroke-width', 1);
        }
        $('path').off("hover click");
        this.actionController.close();
        return this.callBackFunction.call(this.callBackContext, this.distribuition);
      }
    };

    //atualiza janela de ação
    Distribution.prototype.update_action = function(b) {
      var msg, bonus, i;
      
      
      msg = "Você tem " + this.bonus['troops'] + " tropas para distribuir em qualquer território.";
      
      bonus = $.extend(true, {}, this.bonus); //clonando objeto
      delete bonus['troops'];
      if(Object.keys(bonus).length > 0) {
        msg += "<br/>E ";
        
        for(i in bonus) {
          msg += bonus[i] + " em " + i + ". ";
        }
      }
      
      return this.actionController.open('Distribuição', msg);
    };

    return Distribution;

  })();


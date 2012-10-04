var Cards, ChangeMessage;

ChangeMessage = (function() {

    function ChangeMessage(cards) {
      this.controller = 'game';
      this.action = 'exchange_cards';
      this.params = {
        'cards': cards
      };
    }

    return ChangeMessage;

  })();

Cards = (function() {
  
  function Cards(cards,app,context,callBack) {
    _this = this;
    this.app = app;
    this.cards = cards;
    this.context = context;
    this.callBackFunction = callBack;
    this.bonus = 0;
    
    this.modal = $('div#cards');
    this.endPhaseButton = this.modal.find('button#terminar');
    this.closeButton = this.modal.find('.closebtn');
    this.send = this.modal.find('button#trocar');
    this.divCards = this.modal.find('div#cards-list');
    
    this.endPhaseButton.off("click");
    this.send.off("click");
    
    this.modal.find("div#msg").html("");
    
    this.endPhaseButton.click(function() {
      _this.endPhase();
    });
    
    this.closeButton.click(function() {
      _this.endPhase();
    });
    
    this.send.show();
    this.send.click(function() {
      var cards;
      
      cards = [];
      _this.modal.find(":checked").each(function(k,v) {
        cards.push($(this).val());
      });
      _this.app.conn.send(new ChangeMessage(cards));
    });
    
    this.show();
    
  };

  Cards.prototype.show = function() {
    var i, str;
    
    str = "";
    for(i in this.cards) {
      card = this.cards[i];
      str += "<div class=\"card simbolo" + card.simbolo + "\">" + card.nome;
      str += "<input type=\"checkbox\" value=\"" + card.id + "\"/></div><br/>"; 
      
    }
    
    if (str === "") str = "Nenhuma carta";
    
    this.divCards.html(str);
    
    if (this.cards.length < 3) this.modal.find("#opt2").show();
    else this.modal.find("#opt1");
    
    this.app.openModal(this.modal);
  };

  Cards.prototype.exchange_result = function(msg) {
    var msgDiv = this.modal.find("div#msg")
    if (msg.bonus == -1) {
      msgDiv.html("Nao é possível fazer a troca com essas cartas.");
    }else {
      msgDiv.html("<b>Feito!</b> Você tem mais " + msg.bonus + " tropas para distribuir");
      this.send.hide();
    }
  }

  Cards.prototype.endPhase = function() {
    this.callBackFunction.call(this.context, this.bonus);
    this.modal.find("#opt1").hide();
    this.modal.find("#opt2").hide();
    this.app.closeModal(this.modal);
  };
  
  return Cards;
  
})();

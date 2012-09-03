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
    
    this.endPhaseButton.click(function() {
      _this.endPhase();
    });
    
    this.closeButton.click(function() {
      _this.endPhase();
    });
    
    this.send.click(function() {
      var cards;
      
      cards = [];
      _this.modal.find(":checked").each(function() {
        cards.push($(this).attr('id'));
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
    
    this.app.openModal(this.modal);
  };

  Cards.prototype.endPhase = function() {
    this.callBackFunction.call(this.context, this.bonus);
    this.app.closeModal(this.modal);
  };
  
  return Cards;
  
})();

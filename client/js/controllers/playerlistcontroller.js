/* controlador que manipula a lista de jogadores */

  var PlayerListController;

  PlayerListController = (function() {

    function PlayerListController(app) {
      this.app = app;
      this.controllerName = 'playerList';
      this.listElmnt = $('div#players');
    }

    PlayerListController.prototype.update = function(args) {
      var nick, _i, _len, _ref, _results;
      console.log("Atualizando lista de jogadores");
      console.log(args.list);
      this.listElmnt.html('<div id="title">Jogadores online</div>');
      _ref = args.list;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        nick = _ref[_i];
        _results.push(this.listElmnt.append("<div class='nick'>" + nick + "</div>"));
      }
      return _results;
    };

    return PlayerListController;

  })();



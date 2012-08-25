/*
Arquivo principal da aplicação. Carrega o plugin SVG do JQuery, inicia o AppController e registra os
controllers.
*/

$(document).ready(function() {
  var host, svg;

  host = $(location).attr('host');
  this.app = new AppController("ws://" + host + "/websocket");
  $("#game").svg({
    onLoad: function() {
      var svg;
      svg = $("#game").svg('get');
      return svg.load('map.svg', {
        addTo: true,
        changeSize: false
      });
    },
    settings: {}
  });

  svg = $("#game").svg('get');
  this.app.add_controller(new ChatController(this.app));
  this.app.add_controller(new DefinitionsController(this.app));
  this.app.add_controller(new PlayerListController(this.app));
  this.app.add_controller(new SetNickController(this.app));
  this.app.add_controller(new RoomsController(this.app));
  this.app.add_controller(new PregameController(this.app));
  this.app.add_controller(new GameController(this.app));
  this.app.add_controller(new ActionController(this.app));

  this.app.start();

})



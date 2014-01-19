/*
Arquivo principal da aplicação. Carrega o plugin SVG do JQuery, inicia o AppController e registra os
controllers.
*/

$(document).ready(function() {
  var host, svg, app;

  function loadApp() {
    $("path").attr('fill',"#FFFFFF");
    app.add_controller(new ChatController(app));
    app.add_controller(new DefinitionsController(app));
    app.add_controller(new PlayerListController(app));
    app.add_controller(new SetNickController(app));
    app.add_controller(new RoomsController(app));
    app.add_controller(new PregameController(app));
    app.add_controller(new GameController(app));
    app.add_controller(new ActionController(app));
    app.add_controller(new EventsController(app));

    app.start();
    $("#loading").hide();
    $("div#btnreset").show();
    $("div#btnreset").click(function() {
      location.reload();
    });
  }

  host = $(location).attr('host');
  app = new AppController("ws://" + host + "/websocket");
  $("#loading").show();
  $("#game").svg({
    onLoad: function() {
      var svg;
      svg = $("#game").svg('get');
      return svg.load('client/map.svg', {
        addTo: true,
        changeSize: false,
        onLoad: function() {
          loadApp();
        }
      });
    },
    settings: {}
  });  

})



var InitMessage, EventsController;

  EventsController = (function() {

    function EventsController(app) {
      this.app = app;
      this.controllerName = 'events';
      this.contentElmnt = $("div#events .content");
    }
    
    EventsController.prototype.refresh = function(msg) {
      var eventos, i, evento;
      this.contentElmnt.html("");
      eventos = msg.events;
      for(i = 0; i < eventos.length ;i++) {
        evento = eventos[i];
        this.contentElmnt.append('<div class="evento">' + evento + '</div>');
      }
    }

    return EventsController;

  })();

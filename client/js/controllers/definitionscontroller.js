/* Controlador que recebe as definições do jogo, como territorios, cartas, cores... */

  var DefinitionsController;

  DefinitionsController = (function() {

    function DefinitionsController(app) {
      this.app = app;
      this.controllerName = 'definitions';
      this.colors = null;
      this.territories = null;
      this.regions = null;
    }

    DefinitionsController.prototype.set_colors = function(msg) {
      return this.colors = msg.colors;
    };

    DefinitionsController.prototype.set_territories = function(msg) {
      return this.territories = msg.territories;
    };

    DefinitionsController.prototype.set_regions = function(msg) {
      return this.regions = msg.regions;
    };

    DefinitionsController.prototype.get_colors = function() {
      return this.colors;
    };

    DefinitionsController.prototype.get_territories = function() {
      return this.territories;
    };
    
    DefinitionsController.prototype.get_regions = function() {
      return this.regions;
    };
    

    return DefinitionsController;

  })();



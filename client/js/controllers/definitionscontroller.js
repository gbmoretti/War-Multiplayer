/* Controlador que recebe as definições do jogo, como territorios, cartas, cores... */

  var DefinitionsController;

  DefinitionsController = (function() {

    function DefinitionsController(app) {
      this.app = app;
      this.controllerName = 'definitions';
      this.colors = null;
      this.territories = null;
    }

    DefinitionsController.prototype.set_colors = function(msg) {
      console.log('Recebendo lista de cores');
      return this.colors = msg.colors;
    };

    DefinitionsController.prototype.set_territories = function(msg) {
      console.log('Recebendo lista de territórios');
      return this.territories = msg.territories;
    };

    DefinitionsController.prototype.get_colors = function() {
      return this.colors;
    };

    DefinitionsController.prototype.get_territories = function() {
      return this.territories;
    };

    return DefinitionsController;

  })();



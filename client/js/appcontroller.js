/*
Controlador geral da aplicação.

Ele mantem um lista de todos os controladores utilizados pela aplicação. Também implementa um diálogo modal.
*/

  var AppController;

  AppController = (function() {

    function AppController(wsAddr) {
      var self;
      this.wsAddr = wsAddr; //endereço para a conexao websocket
      this.conn = null; //objeto WSConnection
      this.controllers = {}; //hash com a lista de controladores
      self = this;
      $('.closebtn').click(function() {
        return self.closeModal($(this).parent());
      });
    }

    //método utilizada no arquivo principale para registrar os controladores
    AppController.prototype.add_controller = function(obj) {
      return this.controllers[obj.controllerName] = obj;
    };

    //abre uma div modal
    AppController.prototype.openModal = function(elmnt) {
      $('.modal-overlay').show();
      return elmnt.show();
    };

    //fecha uma div modal
    AppController.prototype.closeModal = function(elmnt) {
      elmnt.hide();
      return $('.modal-overlay').hide();
    };

    //inicia a aplicação. Conecta ao servidor e registra os eventos da API Websocket
    AppController.prototype.start = function() {
      var _this = this;
      this.conn = new WSConnection(this.wsAddr);
      this.conn.socket.onopen = function() { //atualiza status ao conseguir conexão
        return _this.conn.refreshStatus();
      };
      this.conn.socket.onclose = function() { //atualiza status ao fechar conexão
        return _this.conn.refreshStatus();
      };
      
      /*Evento disparado quando uma mensagem é recebida.
        Padrão de mensagem:
          {
            'controller': 'nome_do_controlador',
            'action': 'nome_do_metodo',
            'params': {} <-- hash com os parametros passado ao método do controlador
          }
          
        Ao receber a mensagem procura pelo controlador e chama o método especificados pela mensagem
      */
      return this.conn.socket.onmessage = function(msg) {
        var c_name, controller, msgObj;
        msgObj = eval("(" + msg.data + ")");
        c_name = msgObj.controller;
        controller = _this.controllers[c_name];
        if (msgObj.params === '') {
          controller[msgObj.action]();
        }
        if (msgObj.params !== '') {
          return controller[msgObj.action](msgObj.params);
        }
      };
    };

    return AppController;

  })();



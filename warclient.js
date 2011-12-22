socket = null; //objeto websocket
nick = null; //sring com o nick do usuario

$(document).ready(function() {

  do {
    nick = prompt("Escolha seu nick:");
  } while(nick=="");
  
  atualizaStatus('conectando');
  
  //Event handler ao apertar enter no #chatinput
  $('#chatinput input[type=text]').keydown(function(eventObject) {
    if(eventObject.keyCode == 13) {
      sendText();
    }
  });
  
  //Event handler ao clicar no botao Enviar
  $('#chatinput input[type=button]').click(function(eventObject) {
    sendText();
  });
  
  //     ============= Websocket =================
  //Conexao websocket
  if($.browser.mozilla) {
    socket = new MozWebSocket("ws://warchat.herokuapp.com/websocket"); //para FF8
  }else {
    socket = new WebSocket("ws://warchat.herokuapp.com/websocket");
  }
  
  
  //Evento onopen
  socket.onopen = function() {
    atualizaStatus('conectado');
    send(new InitMessage(nick));
  }
  
  //Evento onmessage
  socket.onmessage = function(msg) {
    msg = eval("(" + msg.data + ")");
    if(msg.type == 'warn') writeChat('<span class="warn">' + msg.msg + '</span>');
    if(msg.type == 'txt') writeChat('&lt' + msg.author + '&gt' + msg.msg);
  }
  
  //Evento onclose
  socket.onclose = function() {
    atualizaStatus('desconectado');
  }
  
  // ===================

  
});

function writeChat(msg) {
  $('#chat').append(msg + "<br>");
  $('#chat').scrollTop($('#chat').height());//atualiza barra de rolagem
}

function sendText() {
  var msg = $('#chatinput input[type=text]').val();
  send(new TxtMessage(msg));
  $($('#chatinput input[type=text]')).val("");
}

function send(obj) {
  msg = JSON.stringify(obj);
  socket.send(msg);
}

function atualizaStatus(str) {
  e = $('div#status');
  e.removeClass();
  console.log('Mudando para: ' + str);
  if(str=='conectando') {
    e.addClass('connecting');
    e.html('CONECTANDO...');
  }
  if(str=='conectado') {
    e.addClass('online');
    e.html('ONLINE :)');
  }
  if(str=='desconectado') { 
    e.addClass('offline');
    e.html('OFFLINE :(');
  }
}

//DEFININDO AQUI A CLASSE MESSAGE, DEPOIS COLOCAR NUM ARQUIVO SEPARADO
function InitMessage(n) {
  this.type = "init";
  this.nick = n; 
}

function TxtMessage(m,a) {
  this.type = "txt";
  this.msg = m;
}

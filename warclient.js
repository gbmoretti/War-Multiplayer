conn = null; //objeto Connection
nick = null; //nick do cliente

//Classe de conexão WebSocket
function Connection() {
  this.socket = null;
  
  if($.browser.mozilla) {
    this.socket = new MozWebSocket("ws://192.168.132.134:3000/websocket"); //para FF8
  }else {
    this.socket = new WebSocket("ws://192.168.132.134:3000/websocket");
  }
}


$(document).ready(function() {

  atualizaStatus('conectando');
  
  //Event handler ao apertar enter no #chatinput
  $('#chatinput input[type=text]').keydown(function(eventObject) {
    if(eventObject.keyCode == 13) {
      sendText();
    }
  });
  
  //     ============= Websocket =================
  //Conexao websocket
  
  conn = new Connection();
  
  //Evento onopen
  conn.socket.onopen = function() {
    atualizaStatus('conectado');
    send(new InitMessage('nick'));
  }
  
  //Evento onmessage
  conn.socket.onmessage = function(msg) {
    msg = eval("(" + msg.data + ")");
    if(msg.type == 'warn') writeChat('<span class="warn">' + msg.msg + '</span>');
    if(msg.type == 'txt') writeChat('&lt' + msg.author + '&gt ' + msg.msg);
    if(msg.type == 'player_list') refreshPlayerList(msg.list);
  }
  
  //Evento onclose
  conn.socket.onclose = function() {
    atualizaStatus('desconectado');
  }
  
  // ===================

  //atribui funcao onclick para botao fechar
  $('.closebtn').click(function() {
    hideModal($(this).parent());
  });
  
  showModal($('#login'));
  
});

function refreshPlayerList(l) {
  console.log(l);
  e = $('#players');
  e.html(' ');
  $.each(l, function(i,v) {
    e.append(v + '<br>');
  });
}


function writeChat(msg) {
  $('#chat').append(msg + "<br>");
  $('#chat').scrollTop($('#chat').height()); //atualiza barra de rolagem
}

function sendText() {
  var msg = $('#chatinput input[type=text]').val();
  if(msg!='') send(new TxtMessage(msg));
  $($('#chatinput input[type=text]')).val("");
}

function send(obj) {
  msg = JSON.stringify(obj);
  console.log('Enviando ' + msg);
  conn.socket.send(msg);
}

function atualizaStatus(str) {
  e = $('div#status');
  e.removeClass();
  if(str=='conectando') {
    e.addClass('connecting');
    e.html('CONECTANDO...');
  }
  if(str=='conectado') {
    e.addClass('online');
    e.html('CONECTADO!');
  }
  if(str=='desconectado') { 
    e.addClass('offline');
    e.html('DESCONECTADO');
  }
}

//DEFININDO AQUI A CLASSE MESSAGE, DEPOIS COLOCAR NUM ARQUIVO SEPARADO
function InitMessage(n) {
  this.action = 'set_nick';
  this.nick = n; 
}

function TxtMessage(m,a) {
  this.action = 'chat';
  this.type = 'txt';
  this.msg = m;
}


//FUÇÕES PARA DIV MODAL
function showModal(e) {
  $('.modal-overlay').show();
  e.show();
} 

function hideModal(e) {
  e.hide();
  $('.modal-overlay').hide();
}



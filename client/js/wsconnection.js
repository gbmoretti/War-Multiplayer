  var WSConnection;

  WSConnection = (function() {

    function WSConnection(addr, statusElmnt) {
      this.addr = addr;
      this.statusElmnt = statusElmnt != null ? statusElmnt : $('div#status');
      this.socket = new WebSocket(this.addr);
    }

    WSConnection.prototype.send = function(obj) {
      var msg;
      msg = JSON.stringify(obj);
      return this.socket.send(msg);
    };

    WSConnection.prototype.on_close = function(func) {
      this.socket.onclose = func.call;
      return refreshStatus();
    };

    WSConnection.prototype.on_open = function(func) {
      this.socket.onopen = func.call;
      return refreshStatus();
    };

    WSConnection.prototype.on_message = function(func) {
      var _this = this;
      return this.socket.onmessage = function(msg) {
        msg = eval("(" + msg + ")");
        return func(msg);
      };
    };

    WSConnection.prototype.refreshStatus = function() {
      var state;
      state = this.socket.readyState;
      this.statusElmnt.removeClass();
      if (state === 0) {
        this.statusElmnt.addClass('connecting');
      }
      if (state === 1) {
        this.statusElmnt.addClass('online');
      }
      if (state === 2 || state === 3) {
        return this.statusElmnt.addClass('offline');
      }
    };

    return WSConnection;

  })();


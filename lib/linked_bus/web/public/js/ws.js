function WS(identity, port) {
  this.identity = identity;
  this.url = wsURLBuilder(identity, port)
}

function wsURLBuilder(identity, port){
  var host = window.location.hostname;
  var protocol = "ws://";
  var search = "?identity=" + identity;
  return protocol + host + ":" + (port || 8081) + search
}

WS.prototype.connect = function(callback) {
  var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
  this.connection = new Socket(this.url);
  callback(this.connection)
}
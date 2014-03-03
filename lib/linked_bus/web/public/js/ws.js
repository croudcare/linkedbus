function WS(identity) {
  this.identity = identity;
  this.url = "ws://localhost:8081?identity=" + identity;
}

WS.prototype.connect = function(callback) {
  var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
  this.connection = new Socket(this.url);
  callback(this.connection)
}
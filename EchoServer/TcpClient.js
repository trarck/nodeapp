var net = require('net');


function TcpClient(host,port){
    this.host=host;
    this.port=port
}

TcpClient.prototype.connect=function(connectCallback){
    var self=this;
    this.socket = net.createConnection(this.port,this.host, function(){
      console.log('connected to server!');
      if(connectCallback){
          connectCallback();
      }
    });
    
    this.socket.on('error', (e) => {
       console.log('have error',e);
    });
    
    this.socket.on('data', (data) => {
      console.log("recv server data ",data.toString());
      self.onData(data);
    });
    
    this.socket.on('end', () => {
      console.log('disconnected from server');
    });
}

TcpClient.prototype.send=function(data){
    if(this.socket){
        this.socket.write(data);
    }
}

TcpClient.prototype.onData=function(data){
    
}

module.exports = TcpClient;
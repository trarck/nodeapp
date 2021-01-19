var net = require('net');

function TcpEchoServer(port){
    this.port=port;
}

TcpEchoServer.prototype.start=function(){
    var self=this;
    this.server=net.createServer();
    this.server.on("listening",function(){
        console.log("listen on ",self.port);
    });
    
    this.server.on("connection",function(socket){
        self.accept(socket);
    });
    
    this.server.on("close",function(){
        console.log("server close");
    });
    
    this.server.on("error",function(e){
        console.log("server error:",e);
    });
    
    this.server.listen(this.port);
}

TcpEchoServer.prototype.accept=function(socket){
    console.log("have a new connection");
    var self=this;
    var client={
        socket:socket        
    };
    
    socket.on("error",function(e){
        console.log("connect error",e);            
    });
    
    socket.on("error",function(e){
        console.log("connect error",e);            
    });
    
    socket.on("close",function(){
        console.log("clinet close");
        if(self.onClientClose){
            self.onClientClose(client);
        }
    });
    
    socket.on("data",function(data){
        console.log("recv client data:",data.toString());
        socket.write(data);
    });
    
    if(this.onClientConnect){
        this.onClientConnect(client);
    }
}

TcpEchoServer.prototype.onClientConnect=function(){
    
}

module.exports = TcpEchoServer;
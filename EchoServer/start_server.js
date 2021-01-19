var TcpEchoServer=require("./TcpEchoServer.js");

var server=new TcpEchoServer(8012);
server.onClientConnect=function(client){
    var timer=setInterval(function(){
        if(client.socket){
            client.socket.write("hello");
        }
    },2000);
    client.timer=timer;
};

server.onClientClose=function(client){
    clearInterval(client.timer);
};

server.start();
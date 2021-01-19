var TcpEchoServer=require("./TcpEchoServer.js");

var server=new TcpEchoServer(8012);
server.start();
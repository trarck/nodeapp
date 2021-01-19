var TcpClient=require("./TcpClient.js");

var client=new TcpClient("127.0.0.1",8012);

client.onData=function(d){
    console.log("get",d.toString());
}

client.connect(function(){
    client.send("Hello world");
    console.log("end");
});


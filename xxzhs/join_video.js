var fs=require("fs");
var path=require("path");
var exec = require('child_process').exec;
var yhnode=require("yhnode");

var WorkPool=require("./lib/WorkPool").WorkPool;

var pathMP4Box="MP4Box";//D:/Program Files/GPAC/MP4Box.exe
var videoExt=".mp4";

function joinVideo (videoPath,cb){
    var files=fs.readdirSync(videoPath);
    files=formatFileName(files,videoPath);
    var outVideoFile=videoPath.charAt(videoPath.length-1)=="/"?videoPath.substr(0,videoPath.length-1):videoPath;
    joinChapter(files,outVideoFile+videoExt,function(error){
        if(!error){
            rmdir(videoPath);
        }
        cb && cb(error)
    });
}

function formatFileName (files,dirPath) {
    var ret=[];
    var file;
    dirPath+=dirPath.charAt(dirPath.length-1)!="/"?"/":"";

    for(var i=0,l=files.length;i<l;i++){
        file=files[i];
        if(file.charAt(0)!="." && file.indexOf(videoExt)>-1){
            ret.push(dirPath+file);
        }
    }
    return ret;
}

function joinChapter(chapters,outFile,cb){
    if(!chapters || chapters.length<2) {
        cb("chapters error ");
        return;
    }
    var cmd=pathMP4Box+" "
    //input
    cmd+=chapters[0];
    //cat
    for(var i=1;i<chapters.length;i++){
        cmd+=" -cat "+chapters[i];
    }
    //output
    cmd+=" -out "+outFile;
    console.log("join cmd:"+cmd);
    //exec concat cmd
    exec(cmd,function (error, stdout, stderr) {
        console.log("stdout:"+stdout);
        console.log("stderr:"+stderr);
        cb&& cb(error);
    });
}

function joinAllVideo (allDir) {
    var files=fs.readdirSync(allDir);
    var file;
    allDir+=allDir.charAt(allDir.length-1)!="/"?"/":"";

    var wp=new WorkPool(3);
    for(var i=0,l=files.length;i<l;i++){
        file = files[i];
        if(file.charAt(0)!="."){
            file=path.join(allDir, files[i]);
            var stat = fs.statSync(file);
            if(stat.isDirectory()){
                wp.add(handleJoin,null,file);
            }
        }
    }
}

function handleJoin (task,videoPath) {
    joinVideo(videoPath,function(){
        task.done();
    });
}

function rmdir(dir) {
    var list = fs.readdirSync(dir);
    for(var i = 0; i < list.length; i++) {
        var filename = path.join(dir, list[i]);
        var stat = fs.statSync(filename);
        if(filename == "." || filename == "..") {
            // pass these files
        } else if(stat.isDirectory()) {
        // rmdir recursively
            rmdir(filename);
        } else {
        // rm fiilename
            fs.unlinkSync(filename);
        }
    }
    fs.rmdirSync(dir);
}

var opts = [
    {
        full:'dir',
        abbr:"dir",
        description:"config file path.default is ./deploy"
    },
    {
        full:'mp4box',
        abbr:"mp4box",
        description:"config file path.default is ./deploy"
    }
];

var result = yhnode.base.ArgParser.parse(opts);
var options = result.options;
var cmds = result.cmds;

if(options.mp4box){
    pathMP4Box=options.mp4box;
}

switch(cmds[0]){
    case "help":
        showUsage();
        break;
    case "joinAll":
        joinAllVideo(options.dir);
        break;
     case "joinOne":
        joinVideo(options.dir);
        break;
}

function showUsage() {
    var out = "Usage:node join_video joinAll|joinOne [options] \n";
    console.log(out + "\n" + result.usage);
}

//joinVideo("./video/20120627");
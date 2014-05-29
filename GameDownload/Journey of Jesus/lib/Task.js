/**
 * User: trarck
 * Date: 12-7-21
 * Time: 上午11:33
 */
var Task=function(id,action,scope,args){
    this._id=id;
    this._action=action;
    scope && this.setScope(scope);
    args && this.setArgs(args);
};

Task.prototype.run=function(){
//    console.log("[Task] run "+this._id);
    this._action.apply(this._scope,this._args);
};
Task.prototype.done=function(){
    this._container.finishTask(this);
};

Task.prototype.setId=function(id){
    this._id=id;
};
Task.prototype.getId=function(){
    return this._id;
};

Task.prototype.setAction=function(action) {
    this._action = action;
    return this;
};
Task.prototype.getAction=function() {
    return this._action;
};

Task.prototype.setScope=function(scope) {
    this._scope = scope;
    return this;
};
Task.prototype.getScope=function() {
    return this._scope;
};

Task.prototype.setArgs=function(args) {
    this._args = args;
    return this;
};
Task.prototype.getArgs=function() {
    return this._args;
};

Task.prototype.setContainer=function(container){
    this._container=container;
};
Task.prototype.getContainer=function(){
    return this._container;
};



exports.Task=Task;
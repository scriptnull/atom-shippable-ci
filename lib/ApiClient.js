module.exports = (function(){

  var instance ;
  var API_URL = "https://api.shippable.com";

  var init = function () {
    //privates
    var superagent = require('superagent');
    var get = function (path , cb) {
      //console.log(API_URL + path);
      superagent
        .get(API_URL + path)
        .end(function(err, res){
          cb(err, res);
        });
    };

    //publics
    this.getProject = function (projectId, cb) {
      get('/projects/' + projectId, cb);
    };

    this.getLatestBuild = function (projectId, cb) {
      get('/projects/' + projectId + '/searchBuilds?limit=1' , cb);
    };
  };

  return {
    getInstance : function(){
      if(instance)
        return instance;
      else
        return new init();
    }
  };

})();

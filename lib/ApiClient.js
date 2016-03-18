module.exports = (function(){

  var instance ;
  var API_URL = "https://api.shippable.com";

  var init = function () {
    //privates
    var superagent = require('superagent');
    var get = function (path , cb) {

      //get API token from settings page or config file
      var apiToken = atom.config.get('shippable-ci.apiToken');

      //creates get request
      var getRequest = superagent.get(API_URL + path);

      //if api token is available send Authorization header in request
      if (apiToken)
        getRequest.set('Authorization', 'apiToken ' + apiToken);

      getRequest.end(function(err, res){
        cb(err, res);
      });

    };

    //publics
    this.getProject = function (projectId, cb) {
      get('/projects/' + projectId, cb);
    };

    this.getLatestBuild = function (projectId, cb) {
      get('/runs?projectIds=' + projectId + '&limit=1', cb);
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

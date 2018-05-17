var createServer = require("auto-sni");
var express = require("express");
var app = express();

app.get("/", function(req,res){
    var msg = "If you're reading this, the server is working!";
    res.status(200).send(msg);
    console.log(msg);
});

var serverConfig = {
    email: 'goncalo.ribeiro@fe.up.pt',
    agreeTos: true,
    debug: true,
    domains: ['localhost'],
    dir: "../res",
    ports: {
      http: 8081,
      https: 8082
    }
};

createServer(serverConfig, app);
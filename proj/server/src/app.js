var express = require("express")
var app = express()
var bodyParser = require('body-parser')
app.use(bodyParser.json())

var port = process.argv[2];
if(port === undefined)
port = process.env.PORT || 8080

var registrations = []
var secret = "XlTySew1rQZIAzM7sjyKQ4Putc16RUAO"

/* {wallet: ..., poll :...} */
app.post("/register", function(req, res){
    var wallet = req.body.wallet
    var poll = req.body.poll
    if(wallet === undefined || poll === undefined)
    return res.status(400).json({
        errors: ["Missing parameters!"]
    }).send()
    res.status(200).send()
    registrations.push({wallet, poll})
})

/* {secret: ...} */
app.post("/registrations", function(req, res){
    if(req.body.secret !== secret)
    return res.status(400).json({
        errors: ["Permission denied!"]
    }).send()  
    res.status(200).json(registrations).send()
    registrations = []
})

app.listen(port, function(){
    console.log("Listening to port " + port)
})

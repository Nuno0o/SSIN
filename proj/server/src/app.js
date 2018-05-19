var express = require("express")
var app = express()
var bodyParser = require('body-parser')
app.use(bodyParser.json())

var port = process.argv[2];
if(port === undefined)
port = process.env.PORT || 8080

var registrations = []
var secret = []

/* Create secret key for poll {poll: ..., secret: ...} */
app.post("/createsecret", function(req, res){
    if(req.body.secret === undefined || req.body.poll === undefined)
    return res.status(400).json({
        errors: ["Missing parameters!"]
    }).send()
    res.status(200).send()
    secret[req.body.poll] = req.body.secret
})

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
    if (req.body.poll === undefined || secret[req.body.poll] === undefined || req.body.secret !== secret[req.body.poll])
    return res.status(400).json({
        errors: ["Permission denied!"]
    }).send()
    var regist = []
    registration.forEach(elem => {
        if(elem.poll === req.body.poll){
            regist.push(elem)
            registrations.splice(registrations.indexOf(elem),1)
        }
    })
    res.status(200).json(regist).send()
})

app.listen(port, function(){
    console.log("Listening to port " + port)
})

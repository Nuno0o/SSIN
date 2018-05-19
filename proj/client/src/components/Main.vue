<template>
<div>
  <h1>Voting app SSIN</h1>
  <div>
    <b-alert dismissible :show="showWarn" variant="danger" @dismissed="showAlert=false">{{warnMessage}}</b-alert>
  </div>
  <div>
    <b-alert dismissible :show="showSuccess" variant="success" @dismissed="showSuccess=false">{{successMessage}}</b-alert>
  </div>

  <!-- -->
  <div v-if="contract == null">
    <b-container class="bv-example-row">
      <b-row>
        <b-col>
        <h3 id="choose_poll">Choose an ongoing poll</h3>
        <b-table responsive striped hover :items="listOfPolls">
          <template slot="address" slot-scope="data">
              <a @click="loadOnClick(data.value)">
                {{data.value}}
              </a>
          </template>
        </b-table>
        <div v-if="pollCreatedAdr != null && pollCreatedKey != null">
          <br>
          <br>
          The address of the created poll is : {{pollCreatedAdr}}
          <br>
          <br>
          <br>
          Save the following private key to decrypt the votes:<br><br> {{pollCreatedKey}}
        </div>
        </b-col>
        <b-col>
          <b-jumbotron header="" lead="Enter Poll Address manually" >
            <b-input-group prepend="Poll Address">
              <b-form-input v-model="address" type="text"></b-form-input>
              <b-input-group-append>
                <b-btn variant="info" @click="loadPoll">Load</b-btn>
              </b-input-group-append>
            </b-input-group>
          </b-jumbotron>
          
          
          <b-jumbotron header="" lead="Create new Poll" >
            <b-input-group prepend="Number of Options">
              <b-form-input v-model="noptions" type="number"></b-form-input>
              <b-input-group-append>
                <b-btn variant="info" @click="createPoll">Create</b-btn>
              </b-input-group-append>
            </b-input-group>
          </b-jumbotron>
          
          <br>
        </b-col>
      </b-row>
    </b-container>
    
  </div>
  <!-- Admin app -->
  <div v-if="contract != null && pollOwner === true">
    
      <b-jumbotron header="" lead="" >
        <h2>Poll owner</h2>
        <b-container>
          <b-row>
            <b-col>
              <h3>Give voting permission to address</h3>
              <b-input-group prepend="Voter Address">
                <b-form-input v-model="voterAddress" type="text"></b-form-input>
                <b-input-group-append>
                  <b-btn variant="info" @click="givePerm">Give permission</b-btn>
                </b-input-group-append>
              </b-input-group>
            </b-col>
            <b-col>
              <h3>Results</h3>
              <b-input-group prepend="Private Key">
                <b-form-input v-model="privateKey" type="text"></b-form-input>
                <b-input-group-append>
                  <b-btn variant="info" @click="seeResults">See Results</b-btn>
                </b-input-group-append>
              </b-input-group>              
              <br>
              <div v-if="results.length > 0">
                <h3>The results are the following</h3>
                <h4 v-for="(result,index) in results">Option {{index}}: {{result}}</h4>
              </div>
            </b-col>
          </b-row>
        </b-container>
        <b-btn variant="success" style="margin-top: 20px" @click="endVoting">End voting</b-btn>
      </b-jumbotron>
  </div>
  <!-- Voter app (also appears for admins) -->
  <div v-if="contract != null">
    <b-jumbotron>
    <h2>Voter</h2>
    <h3>Select your option</h3>
    <b-btn class="options" variant="outline-info" v-for="index in nvoteoptions" @click="vote(index-1)">Option {{index-1}}</b-btn>
    <br>
    <b-btn variant="info" style="margin-top: 20px" @click="status">Status</b-btn>
    <br>
    <b-btn variant="danger" id="close" @click="closeContract">Close</b-btn>
    </b-jumbotron>
  </div>

</div>
</template>

<script>
export default {
  name: 'Main',
  created:  function () {
    //lista de polls
    var abi = require('../contract/Contract.js').abi //interface
    var address = require('../contract/Contract.js').creator //endereço
    web3.eth.defaultAccount = web3.eth.accounts[0]
    var contract = web3.eth.contract(abi).at(address) //endereço de contrato
    contract.listOfPolls.call((error, success) => {
      if(!error){
        var abipoll = require('../contract/Contract.js').abi2 
        success.forEach(elem => { // percorrer lista de contratos
          var addresspoll = elem
          var contractpoll = web3.eth.contract(abipoll).at(addresspoll)
          contractpoll.getTimeStamp.call((error, success) => {
            if(!error){
              this.listOfPolls.push({'address': addresspoll, 'timestamp': new Date(parseInt(success)*1000).toLocaleString()}) //formato de uma poll
              this.$forceUpdate()
            }
          })
          
        })
      } else {
        alert('Error retrieving list of polls')
      }
    })
    //fim de lista de polls
  },
  data() {
    return {
      listOfPolls: [],
      noptions: null,
      pollOwner: null,
      address: '',
      contract: null,
      voterAddress: '',
      privateKey: '',
      nvoteoptions: 0,
      results: [],
      pollCreatedAdr: null,
      pollCreatedKey: null,

      warnMessage: null,
      showWarn: false,

      successMessage: null,
      showSuccess: false
    }
  },
  methods: {
    showWarnMessage (message) {
      this.warnMessage = message
      this.showWarn = true
    },
    showSuccessMessage (message) {
      this.successMessage = message
      this.showSuccess = true
    },
    createPoll () {
      if (this.noptions < 1){
        alert('Needs to have more than 0 options!')
        return
      }
      var abi = require('../contract/Contract.js').abi
      var address = require('../contract/Contract.js').creator
      web3.eth.defaultAccount = web3.eth.accounts[0]
      var contract = web3.eth.contract(abi).at(address)
      var NodeRSA = require('node-rsa')
      var key = new NodeRSA({b:512})
      var privatekey = key.exportKey('pkcs8-private-pem')
      var publickey = key.exportKey('pkcs8-public-pem')
      contract.createPoll.call(this.noptions, publickey, (error, result) => {
        if(!error){
          var pollAddress = result
          contract.createPoll(this.noptions, publickey, (error, result) => {
            if(!error){
              this.pollCreatedAdr = pollAddress
              this.pollCreatedKey = privatekey
              this.$forceUpdate()
            }
          })
        } else {
          alert('Couldn\'t create poll')
        }
      })
    },
    loadPoll () {
      var abi = require('../contract/Contract.js').abi2
      var address = this.address
      web3.eth.defaultAccount = web3.eth.accounts[0]
      this.contract = web3.eth.contract(abi).at(address)
      this.contract.getChairperson((error, result) => {
        if(!error){
          if(result != '0x'){
            if(result != web3.eth.accounts[0]){
              this.pollOwner = false
            } else {
              this.pollOwner = true
            }
            this.getPerm()
            this.getNOptions()
          } else {
            alert('Couldn\'t load poll')
            this.contract = null
          }
        } else {
          alert('Address is invalid')
          this.contract = null
        }
      })
    },
    loadOnClick (address) {
      this.address = address
      this.loadPoll()
    },
    getPerm () { // saber permissoes
      this.contract.getRightToVote.call((error, result) => {
        if(!error) {
          if(result === false) {
            this.showWarnMessage('You don\'t have permission to vote on this poll')
            this.contract = null
          }
        } else {
          alert('Error')
          this.contract = null
        }
      })
    },
    getNOptions () {
      this.contract.getNChoices.call((error, result) => {
        if(!error) {
          this.nvoteoptions = parseInt(result)
        } else {
          alert('Error')
          this.contract = null
        }
      })
    },
    vote (index) {
      this.contract.getKey.call((error, result) => {
        if(!error){
          var NodeRSA = require('node-rsa')
          var key = new NodeRSA(result)
          var enc = key.encrypt(String(index + '+' +Math.random().toString(36).substring(7)), 'base64', 'utf8')
          this.contract.castVote.call(enc,(error, result) => {
            if(result === true){
              this.contract.castVote(enc,(error, result) => {
                if(!error){
                  this.showSuccessMessage('Your vote was cast successfuly')
                } else {
                  this.showWarnMessage('There was a problem casting your vote')
                }
              })
            } else {
              this.showWarnMessage('The poll has already ended!')
            }
          })
        } else {
          alert('Error')
          this.contract = null
        }
      })
    },
    givePerm () {
      this.contract.givePermission.call(this.voterAddress,(error, result) => {
        if(!error && result === true){
          this.contract.givePermission(this.voterAddress,(error, result) => {
            if(!error) {
              this.showSuccessMessage('Success on granting permission')
            }
          })
        } else {
          this.showWarnMessage('Invalid address')
        }
      })
    },
    status () {
      this.contract.getEnded.call((error, result) => {
        if(!error){
          if(result === false){
            alert('Voting is ongoing')
          } else {
            alert('Voting has ended')
          }
        }
      })
    },
    seeResults () {
      this.results = new Array(this.nvoteoptions).fill(0)
      this.contract.getVoters.call((error, result) => {
        if(!error){
          var NodeRSA = require('node-rsa')
          var key
          try{
            key = new NodeRSA(this.privateKey)
          } catch(err) {
            this.showWarnMessage('Invalid RSA key')
            return
          }
          result.forEach(elem => {
            this.contract.getVote.call(elem, (error, result) => {
              var dec = key.decrypt(result, 'utf8')
              this.results[dec.split('+')[0]]++
              this.$forceUpdate()
            })
          })
        }
      })
    },
    endVoting () {
      this.contract.endVoting.call((error, result) => {
        if(!error && result === true){
          this.contract.endVoting((error, result) => {
            if(!error) {
              this.showSuccessMessage('Success ending poll')
            }
          })
        } else {
          this.showWarnMessage('Error ending poll')
        }
      })
    },
    closeContract () {
      this.contract = null
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1,
h2 {
  font-weight: normal;
}

h1:first-of-type{
  margin-top: 0px;
  margin-bottom: 50px;
  padding: 10px;
  background: #71b5d4;
  color: #fdfdfd;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}

#close {
  margin-top: 20px;
}

#choose_poll{
  margin-bottom: 30px;
}

.options{
  margin:10px;
}
</style>

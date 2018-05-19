<template>
<div>
  <div>
    <b-alert dismissible :show="showWarn" variant="danger" @dismissed="showAlert=false">{{warnMessage}}</b-alert>
  </div>
  <div>
    <b-alert dismissible :show="showSuccess" variant="success" @dismissed="showSuccess=false">{{successMessage}}</b-alert>
  </div>
  <h1>Voting app SSIN</h1>
  <!-- -->
  <div v-if="contract == null">
    <b-container class="bv-example-row">
      <b-row>
        <b-col>
        <h2>Choose an ongoing poll:</h2>
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
          <h2>Or enter Poll Address manually:</h2>
          <input v-model="address" placeholder="Poll address">
          <button @click="loadPoll">Load</button>
          <h2>Or create a new Poll:</h2>
          <input type="number" v-model="noptions" placeholder="Number of options">
          <button @click="createPoll">Create</button>
          <br>
        </b-col>
      </b-row>
    </b-container>
    
  </div>
  <!-- Admin app -->
  <div v-if="contract != null && pollOwner === true">
    <h1>Poll owner Menu</h1>
    <h2>Give voting permission to following address:</h2>
    <input v-model="voterAddress" placeholder="Voter address">
    <button @click="givePerm">Give permission</button>
    <br>
    <input v-model="privateKey" placeholder="Private key">
    <button style="margin-top: 20px" @click="seeResults">See Results</button>
    <br>
    <div v-if="results.length > 0">
      <h3>The results are the following</h3>
      <h4 v-for="(result,index) in results">{{index}}: {{result}}</h4>
    </div>
    <br>
    <button style="margin-top: 20px" @click="endVoting">End voting</button>
    <br>
  </div>
  <!-- Voter app (also appears for admins) -->
  <div v-if="contract != null">
    <h1>Voter Menu</h1>
    <h2>Select your option</h2>
    <button v-for="index in nvoteoptions" @click="vote(index-1)">Option {{index-1}}</Button>
    <br>
    <button style="margin-top: 20px" @click="status">Status</button>
    <br>
    <button id="close" @click="closeContract">Close</button>
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
              this.listOfPolls.push({'address': addresspoll, 'timestamp': parseInt(success)}) //formato de uma poll
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
              /*axios.post('http://localhost:8000/createsecret',{'poll': this.address, 'secret': })
              setInterval(function () {

                axios.post('http://localhost:8000',)
              })*/
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
                  alert('Your vote was cast successfuly')
                } else {
                  alert('There was a problem casting your vote')
                }
              })
            } else {
              alert('Error casting vote, maybe the voting has already ended')
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
              alert('Success!')
            }
          })
        } else {
          alert('Invalid address')
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
            alert('Invalid RSA key')
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
          this.contract.endVoting(this.voterAddress,(error, result) => {
            if(!error) {
              alert('Success!')
            }
          })
        } else {
          alert('Error')
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
</style>

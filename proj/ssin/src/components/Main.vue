<template>
<div>
  <h1>Voting app</h1>
  <h2>Enter Ballot Address:</h2>
  <div v-if="contract == null">
    <input v-model="address" placeholder="Contract address">
    <button @click="loadBallot">Load</button>
  </div>
  <div v-if="contract != null">
    <button v-for="index in nOptions" @click="vote(index-1)">Option {{index-1}}</Button>
    <br>
    <button id="close" @click="closeContract">Close</button>
  </div>

</div>
</template>

<script>
export default {
  name: 'Main',
  created:  function () {
    /* var NodeRSA = require('node-rsa');
    var key = new NodeRSA({b:512})
    var a = 1
    console.log(key.exportKey('pkcs8-private-pem'))
    console.log(key.exportKey('pkcs8-public-pem'))
    var enc = key.encrypt(':^)+' + Math.random().toString(36).substring(16),'base64')
    console.log(enc)
    var dec = key.decrypt(enc,'utf8')
    console.log(dec) */
    /*var abi = require('../contract/Contract.js').abi3
    var address = '0xa8fcfcc75fc11459705c06ed80f8cb90848b38ac'
    web3.eth.defaultAccount = web3.eth.accounts[0]
    var contract = web3.eth.contract(abi).at(address)
    contract.createBallot.call(8,(error, result) => {
      console.log(result)
    })
    /*contract.createBallot(8,(error, result) => {
      console.log(result)
    })*/
  },
  data() {
    return {
      address: '',
      contract: null,
      voterAddress: '',
      nOptions: 0
    }
  },
  methods: {
    loadBallot () {
      var abi = require('../contract/Contract.js').abi2
      var address = this.address
      web3.eth.defaultAccount = web3.eth.accounts[0]
      this.contract = web3.eth.contract(abi).at(address)
      this.contract.getChairperson((error, result) => {
        if(!error){
          if(result != '0x'){
            if(result != web3.eth.accounts[0]){
              alert('You are not the chairman!')
              this.contract = null
              return
            }
          } else {
            alert('Couldn\'t load ballot')
          }
        } else {
          alert('Address is invalid')
        }
      })
    },
    getVotes() {
      this.contract.getNProposals((error, result) => {
        if(!error){
          this.nOptions = parseInt(result)
        } else {
        }
      })
    },
    vote (index) {
      this.contract.vote(index,(error, result) => {
        if(!error){
          //alert(result)
        } else {

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

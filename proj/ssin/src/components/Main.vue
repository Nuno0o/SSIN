<template>
<div>
  <h1>Voting app</h1>
  <h2>0x2ac7d296d27a3cf887239bd015ea69fda43f209d</h2>
  <div v-if="!loadedContract">
    <input v-model="address" placeholder="Contract address">
    <button @click="instContract">Load</button>
  </div>
  <div v-if="loadedContract">
    <button v-for="index in nOptions" @click="vote(index-1)">Option {{index-1}}</Button>
    <br>
    <button v-if="loadedContract" id="close" @click="closeContract">Close</button>
  </div>

</div>
</template>

<script>
export default {
  name: 'Main',
  created:  function () {

  },
  data() {
    return {
      address: '',
      contract: null,
      loadedContract: false,
      voterAddress: '',
      nOptions: 0
    }
  },
  methods: {
    instContract () {
      var abi = require('../contract/Contract.js').abi
      var address = this.address
      web3.eth.defaultAccount = web3.eth.accounts[0]
      this.contract = web3.eth.contract(abi).at(address)
      this.contract.getChairperson((error, result) => {
        if(!error){
          if(result != '0x'){
            this.contract.getRightToVote((error, result) => {
              if(result == false){
                this.loadedContract = false
                this.contract = null
                alert('You can\'t vote because either you already voted or the chairman hasn\'t given permission to you yet')
              } else if(!error) {
                this.loadedContract = true
                this.getVotes()
              }
            })
          } else {
            alert('Couldn\'t load contract')
          }
        } else {
          alert('Invalid id')
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
      this.loadedContract = null
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

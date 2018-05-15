<template>
<div>
  <h1>Voting app (Admin)</h1>
  <h2>0x15ae708a1ecdb2553e00a5788bdad809d6bc04b6</h2>
  <div v-if="!loadedContract">
    <input v-model="address" placeholder="Contract address">
    <button @click="instContract">Load</button>
  </div>
  <div v-if="loadedContract">
    <h3>Number of votes</h3>
    <h4 v-for="(item,index) in votes">{{index}}: {{item}}</h4>
    <br>
    <input v-model="voterAddress" placeholder="Voter address">
    <button @click="givePerm">Give permission</button>
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
      votes: []
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
            if(result != web3.eth.accounts[0]){
              alert('You are not the chairman!')
              this.contract = null
              return
            }
            this.loadedContract = true
            this.getVotes()
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
          var nvotes = result
          this.votes = []
          for(var i = 0; i < nvotes; i++){
            this.contract.getNVotes(i,(error, result) => {
              if(!error){
                this.votes.push(result)
              } else {

              }
            })
          }
        } else {
        }
      })
    },
    givePerm () {
      this.contract.giveRightToVote(this.voterAddress,(error, result) => {
        if(!error){
          console.log(result)
        } else {
          alert('Invalid id')
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

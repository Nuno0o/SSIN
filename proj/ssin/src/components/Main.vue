<template>
<div>
  <h1>Voting app</h1>
  <input v-model="address" placeholder="Contract address">
  <button @click="instContract">Load</button>
</div>
</template>

<script>
export default {
  name: 'Main',
  data() {
    return {
      address: '',
      contract: null
    }
  },
  methods: {
    instContract() {
      var abi = [{
        "constant": true,
        "inputs": [],
        "name": "renderHelloWorld",
        "outputs": [{
          "name": "",
          "type": "string"
        }],
        "payable": false,
        "stateMutability": "pure",
        "type": "function"
      }]
      var address = '0xc4269c1037585759cf16266576080ce5a985de7a'
      web3.eth.defaultAccount = web3.eth.accounts[0]
      this.contract = web3.eth.contract(abi).at(address)
      this.contract.renderHelloWorld((error, result) => {
        if(!error){
          alert(result)
        } else {

        }
      })
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
</style>

<template>
<div>
  <h1>Deploy vote</h1>
  <button @click="deployContract">Deploy</button>
</div>
</template>

<script>
export default {
  created: function() {
    console.log(require('../contract/Contract.js').a)
  },
  name: 'Admin',
  data() {
    return {
      address: '',
      contract: null
    }
  },
  methods: {
    deployContract () {

      /*var source = "contract helloWorld {"+
        "function renderHelloWorld () public pure returns (string) {"+
        "return 'helloWorld';"+
        "}}"
      var compiled = web3.eth.compile.solidity(source,
        function(err, res) { //necessary callback function
          console.log(JSON.stringify(err));
        });*/
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

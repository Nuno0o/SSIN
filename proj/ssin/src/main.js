// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import VueLocalStorage from 'vue-localstorage'

Vue.config.productionTip = false

Vue.use(VueLocalStorage)

window.Vue = Vue

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use MetaMask's provider
    //web3js = new Web3(web3.currentProvider);
  } else {
    console.log('Web3 not detected!')
    alert('Web3 not detected!')
  }
  // Now you can start your app & access web3 freely:
  startApp()
})

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})

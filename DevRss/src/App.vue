<script>
  import Vue from 'vue'

  var application = Vue.extend({
    el() {
      return '.keyWindow'
    },
    data() {
      return {
        transition: 'push'
      }
    }
  })
  export default application
</script>

<template>
  <div class="keyWindow">
    <router-view class="view" :transition="transition" transition-mode="in-out"></router-view>
  </div>
</template>

<style scoped>
  .view {
    transition: all .25s ease;
  }
  .push-enter, .push-leave {
    /*opacity: 0;*/
    -webkit-transform:translate(100%,0);
    -moz-transform:translate(100%,0);
  }
  .pop-enter, .pop-leave {
    /*opacity: 0;*/
    -webkit-transform:translate(-100%,0);
    -moz-transform:translate(-100%,0);
  }
  [v-cloak] {
    display: none;
  }
</style>
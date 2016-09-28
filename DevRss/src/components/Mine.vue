<script>
  import Vue from 'vue'
  import drnavigationBar from 'components/NavigationBar'

  var Mine = Vue.extend({
    el() {
      return '.Mine'
    },
    data() {
      return {
          nav_title: "我的",
          nav_bar_tint: "#FFFFFF",
          nav_tint: "rgb(64, 64, 64)"
      }
    },
    methods: {

    },
    computed: {
      
    },
    components: {
      'drnavigationBar': drnavigationBar
    }
  })
  export default Mine
</script>

<template>
  <div class="Mine">
    <drnavigation-bar :title="nav_title" :bar-tint-color="nav_bar_tint" :tint-color="nav_tint" keep-alive></drnavigation-bar>
  </div>
</template>

<style scoped>

</style>
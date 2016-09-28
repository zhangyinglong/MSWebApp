<script>
  import Vue from 'vue'
  import drnavigationBar from 'components/NavigationBar'

  var Collection = Vue.extend({
    el() {
      return '.Collection'
    },
    data() {
      return {
          nav_title: "收藏",
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
  export default Collection
</script>

<template>
  <div class="Collection">
    <drnavigation-bar :title="nav_title" :bar-tint-color="nav_bar_tint" :tint-color="nav_tint" keep-alive></drnavigation-bar>
  </div>
</template>

<style scoped>

</style>
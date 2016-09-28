<script>
  import Vue from 'vue'
  import drtabbar from 'components/TabBar'

  var root = Vue.extend({
    el() {
      return '.root'
    },
    data() {
      return {
        tab_items: [
          {
            title: '主页',
            image: 'static/imgs/tab_1.png',
            image_select: 'static/imgs/tab_1_s.png',
            size: 26,
            title_select: '#34A3FF',
            path: '/root/Enter?push=0'
          }, 
          {
            title: '收藏',
            image: 'static/imgs/tab_2.png',
            image_select: 'static/imgs/tab_2_s.png',
            size: 26,
            title_select: '#34A3FF',
            path: '/root/Collection?push=0'
          },
          {
            title: '我的',
            image: 'static/imgs/tab_3.png',
            image_select: 'static/imgs/tab_3_s.png',
            size: 26,
            title_select: '#34A3FF',
            path: '/root/Mine?push=0'
          }
          ],
          tab_bar_tint: "#FFFFFF",
          tab_tint: "rgb(64, 64, 64)"
      }
    },
    components: {
      'drtabbar': drtabbar
    }
  })
  export default root
</script>

<template>
  <div class="root">
    <router-view class="view" transition="test" transition-mode="in-out"></router-view>
    <drtabbar :itemdatas="tab_items" :bar-tint-color="tab_bar_tint" :tint-color="tab_tint" keep-alive></drtabbar>
  </div>
</template>

<style scoped>
  .view {
    transition: all .0s ease;
  }
  .test-enter, .test-leave {
    opacity: 0;
    transform: translate3d(20px, 0, 0);
  }
  [v-cloak] {
    display: none;
  }
</style>
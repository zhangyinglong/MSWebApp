<style>
.view {
  transition: all .5s ease;
}
.test-enter, .test-leave {
  opacity: 0;
  transform: translate3d(20px, 0, 0);
}
[v-cloak] {
  display: none;
}
</style>

<template>
  <!-- 添加Router的过渡 -->
  <router-view class="view" transition="test" transition-mode="out-in" keep-alive></router-view>
</template>

<script>

export default {
    components: {
      
    }
}

</script>

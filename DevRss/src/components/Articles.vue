<script>
    import Vue from 'vue'
    import drnavigationBar from 'components/NavigationBar'

    var article = Vue.extend({
        el() {
            return '.article'
        },
        data() {
            return {
                nav_title: "文章内容",
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
    export default article
</script>

<template>
  <div class="article">
    <drnavigation-bar :title="nav_title" :bar-tint-color="nav_bar_tint" :tint-color="nav_tint" keep-alive></drnavigation-bar>
    <div class="article-content">
        <p>Hello world!!!</p>
    </div>
  </div>
</template>

<style scoped>
    .article {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        z-index: 2;
        background-color: #FFF;
    }
</style>
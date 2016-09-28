<script>
    import Vue from 'vue'
    import drnavigationBar from 'components/NavigationBar'
    import $ from 'n-zepto'
    import slide from '../../static/js/pullRefresh.js'

    var enter = Vue.extend({
        el() {
            return '.enter'
        },
        data() {
            return {
                nav_title: "开发者头条",
                nav_bar_tint: "#FFFFFF",
                nav_tint: "rgb(64, 64, 64)",
                items: [
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                ]
            }
        },
        methods: {

        },
        computed: {
            getPath: function() {
                return this.$route.path;
            }
        },
        components: {
            'drnavigationBar': drnavigationBar
        },
        ready() {
            slide($('.scrollWrap'), 44, function(e) {
                var that = this;
                console.log('refresh trig!')
                setTimeout(function() {
                    that.back.call();
                }, 2000);
            });
        }
    })
    export default enter
</script>

<template>
  <div class="enter">
    <drnavigation-bar :title="nav_title" :bar-tint-color="nav_bar_tint" :tint-color="nav_tint" keep-alive></drnavigation-bar>
    <div class="scrollWrap">
      <div class="rec-refresh">
        <img src="../../static/imgs/spinner.png"/>
      </div>
      <!--list-->
      <div class="rlist">
        <div class="rec-item" v-for="item in items" track-by="$index">
          {{ item }}
          <br>
        </div>
      </div>
      <!--Fix tab height-->
      <div class="fix-tab">
      </div>

    </div>
  </div>
</template>

<style scoped>
    .rec-item {
        margin-top: 5px;
        width: 100%;
    }
    
    .fix-tab {
        width: 100%;
        height: 49px;
    }
    
    .rec-refresh {
        height: 49px;
        line-height: 49px;
        width: 100%;
        text-align: center;
    }
    
    .rec-refresh img {
        width: 20px;
        height: 20px;
        margin-top: 15px;
        -webkit-animation: gogogo .5s infinite linear;
    }
    
    .scrollWrap {
        transform: translate(0, -49px);
        -webkit-transform: translate(0, -49px);
        width: 100%;
    }
    
    @-webkit-keyframes gogogo {
        0% {
            -webkit-transform: rotate(0deg);
            transform: rotate(0deg);
        }
        50% {
            -webkit-transform: rotate(180deg);
            transform: rotate(180deg);
        }
        100% {
            -webkit-transform: rotate(360deg);
            transform: rotate(360deg);
        }
    }
</style>
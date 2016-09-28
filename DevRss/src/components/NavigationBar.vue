<script>
    import Vue from 'vue'
    var drnavigationBar = Vue.extend({
        el() {
            return '.drnavigationBar'
        },
        data() {
            return {

            }
        },
        props: ['title', 'barTintColor', 'tintColor'],
        computed: {
            showbackButton: function() {
                return this.$route.query.push == 1 ? true: false;
            },
            originPath: function() {
                var oPath = this.$route.query.coming;
                return oPath ? oPath : this.$route.root;
            }
        },
        methods: {
        }
    })
    export default drnavigationBar
</script>

<template>
    <div class="nav-placeHolder">
    </div>
    <div class="drnavigationBar" :style="{ 'background-color': barTintColor }">
        <ul class="nav-item">
            <li id="left-bar-item">
                <div id="bar-left-content" :style="{ color: tintColor }" v-if="showbackButton" v-link="{ path: originPath }">
                    <img src="../../static/imgs/back_black.png" width="25px" height="25px"/>    
                </div>
            </li>
            <li id="bar-title-view">
                <div id="bar-title-content" :style="{ color: tintColor }">
                    {{title}}
                </div>
            </li>
            <li id="right-bar-item">
                <div id="bar-right-content" :style="{ color: tintColor }">
                    
                </div>
            </li>
        </ul>
        <div class="nav-line">
        </div>   
    </div>
</template>

<style scoped>
    .nav-placeHolder {
        height: 64px;
        width: 100%;
    }
    .drnavigationBar {
        width: 100%;
        height: 64px;
        position: fixed;
        top: 0;
        z-index: 1;
    }
    .nav-item {
        margin-top: 20px;
        width: 100%;
        height: 44px;
    }
    #left-bar-item {
        float: left;
        width: 22%;
        height: 100%;
        display: table;
        margin-left: 3%;
    }
    #bar-title-view {
        float: left;
        width: 50%;
        height: 100%;
        display: table;
        margin-top: -3px;
    }
    #right-bar-item {
        float: left;
        width: 22%;
        height: 100%;
        display: table;
        margin-right: 3%;
    }
    .nav-line {
        background-color: #E6E6E6;
        width: 100%;
        height: 1px;
        position: absolute;
        bottom: 0;
    }
    /**
    内容设置
    */
    #bar-title-content {
        display: table-cell;
        vertical-align: middle;
        text-align: center;
        font-family: sans-serif, "Hiragino Sans GB W3", "Helvetica Neue", "Segoe UI", Tahoma, Arial, "Microsoft Yahei", "STHeiti";
        font-size: 20px;
        color: #FFFFFF;
        font-weight: 100;
    }
    #bar-left-content {
        display: table-cell;
        vertical-align: middle;
        text-align: left;
        margin-top: 20px;
    }
    #bar-right-content {
        display: table-cell;
        vertical-align: middle;
        text-align: right;
    }
</style>
<script>
    import Vue from 'vue'
    var drtabbar = Vue.extend({
        el() {
            return '.drtabbar'
        },
        data() {
            return {
                
            }
        },
        props: ['itemdatas', 'barTintColor', 'tintColor'],
        methods: {
            selectTabBar: function(index) {
                var emphasisImage = document.querySelectorAll("img")
                var emphasisText = document.querySelectorAll("p")

                for( var i = 0; i < emphasisText.length; i++ ){
                    var tab_data = this.itemdatas[i]
                    if ( i == index ) {
                        emphasisImage[i].src = tab_data.image_select
                        emphasisText[i].style.color = tab_data.title_select
                    } else {
                        emphasisImage[i].src = tab_data.image
                        emphasisText[i].style.color = this.tintColor
                    }
                }
            }
        },
        activate: function(done) {
            done()
        }
    })
    export default drtabbar
</script>

<template>
    <div class="drtabbar" :style="{ 'background-color': barTintColor }">
        <div class="nav-line">
        </div>
        <ul id="example-1">
            <li v-for="item in itemdatas" :style="{ width: 100 / itemdatas.length + '%' }">
                <div v-if="$index == 0" id="tab-item" :style="{ color: tintColor }" @click="selectTabBar($index)" v-link="item.path">
                    <img :src="item.image_select" :width="item.size" :height="item.size" index="$index"/>
                    <p index="$index" :style="{ color:item.title_select }">{{ item.title }}</p>
                </div>
                <div v-else id="tab-item" :style="{ color: tintColor }" @click="selectTabBar($index)" v-link="item.path">
                    <img :src="item.image" :width="item.size" :height="item.size" index="$index"/>
                    <p index="$index">{{ item.title }}</p>
                </div>
            </li>
        </ul>
    </div>
</template>

<style scoped>
    .drtabbar {
        width: 100%;
        height: 49px;
        position: fixed;
        bottom: 0;
    }
    .nav-line {
        background-color: #E6E6E6;
        width: 100%;
        height: 1px;
        position: absolute;
        top: 0;
    }
    ul {
        height: 100%;
        width: 100%;
    }
    ul li {
        float: left;
        height: 100%;
        display: table;
        -webkit-tap-highlight-color:transparent;
    }
    #tab-item {
        display: table-cell;
        vertical-align: middle;
        text-align: center;
        font-family: sans-serif, "Hiragino Sans GB W3", "Helvetica Neue", "Segoe UI", Tahoma, Arial, "Microsoft Yahei", "STHeiti";
        font-size: 12px;
        color: #FFFFFF;
        font-weight: 100;
        -webkit-tap-highlight-color:transparent;
    }
    #tab-item img {
        margin-top: 3px;
        -webkit-tap-highlight-color:transparent;
    }
    #tab-item p {
        margin-top: -3px;
        -webkit-tap-highlight-color:transparent;
    }
</style>
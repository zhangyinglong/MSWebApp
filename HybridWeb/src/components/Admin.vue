<style>
.fade-transition {
    transition: opacity .3s ease;
}

.fade-enter,
.fade-leave {
    opacity: 0;
}
</style>

<template>

<div class="admin-content">
    <div class="slds-grid slds-grid--vertical admin-content-menu slds-has-icon--left">
        <!-- 选择器 -->
        <div class="slds-dropdown-trigger slds-dropdown-trigger--click" id="admin-content-menu" aria-expanded="true" open='0'>
            <button class="slds-button slds-button--neutral slds-picklist__label" aria-haspopup="true" aria-activedescendant="" v-on:click="toggle">
                <span class="slds-truncate">{{ selectAppName }}</span>
                <svg aria-hidden="true" class="slds-icon">
                    <use xlink:href="../../static/icons/utility-sprite/svg/symbols.svg#down"></use>
                </svg>
            </button>
            <div class="slds-dropdown slds-dropdown--left slds-dropdown--small">
                <ul class="dropdown__list slds-dropdown--length-5" role="menu">
                    <li class="slds-dropdown__item">
                        <a href="javascript:void(0);" role="menuitem" v-on:click="menuClick('Leaf Student')">
                            <p class="slds-truncate">Leaf Student</p>
                        </a>
                    </li>
                    <li class="slds-dropdown__item">
                        <a href="javascript:void(0);" role="menuitem" v-on:click="menuClick('Meishizhaoshi')">
                            <p class="slds-truncate">Meishizhaoshi</p>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!-- Menu -->
        <div class="admin-content-left">
            <h2 class="slds-p-around--small admin-content-h2" id="entity-header">Dynamic App</h2>
            <ul class="slds-navigation-list--vertical slds-has-block-links--space">
                <li class="slds-dropdown__item">
                    <a href="javascript:void(0);" role="menuitem" v-on:click="selectMenu('WebAppConfig')">
                        <p class="slds-truncate">
                            <svg aria-hidden="true" class="slds-icon slds-icon--small">
                                <use xlink:href="../../static/icons/standard-sprite/svg/symbols.svg#custom"></use>
                            </svg>
                            WebApp配置
                        </p>
                    </a>
                </li>
                <li class="slds-dropdown__item">
                    <a href="javascript:void(0);" role="menuitem" v-on:click="selectMenu('Service')">
                        <p class="slds-truncate">
                            <svg aria-hidden="true" class="slds-icon slds-icon--small">
                                <use xlink:href="../../static/icons/standard-sprite/svg/symbols.svg#flow"></use>
                            </svg>
                            添加业务模块
                        </p>
                    </a>
                </li>
            </ul>
            <h2 class="slds-p-around--small admin-content-h2" id="folder-header">Data Statistics</h2>
            <ul class="slds-navigation-list--vertical slds-has-block-links--space">
                <li class="slds-dropdown__item">
                    <a href="javascript:void(0);" role="menuitem" v-on:click="selectMenu(2)">
                        <p class="slds-truncate">
                            <svg aria-hidden="true" class="slds-icon slds-icon--small">
                                <use xlink:href="../../static/icons/standard-sprite/svg/symbols.svg#marketing_actions"></use>
                            </svg>
                            应用统计
                        </p>
                    </a>
                </li>
                <li class="slds-dropdown__item">
                    <a href="javascript:void(0);" role="menuitem" v-on:click="selectMenu(3)">
                        <p class="slds-truncate">
                            <svg aria-hidden="true" class="slds-icon slds-icon--small">
                                <use xlink:href="../../static/icons/standard-sprite/svg/symbols.svg#social"></use>
                            </svg>
                            数据统计
                        </p>
                    </a>
                </li>
                <li class="slds-dropdown__item">
                    <a href="javascript:void(0);" role="menuitem" v-on:click="selectMenu(4)">
                        <p class="slds-truncate">
                            <svg aria-hidden="true" class="slds-icon slds-icon--small">
                                <use xlink:href="../../static/icons/standard-sprite/svg/symbols.svg#task"></use>
                            </svg>
                            事件统计
                        </p>
                    </a>
                </li>
            </ul>
            <h2 class="slds-p-around--small admin-content-h2" id="folder-header">Others</h2>
            <ul class="slds-navigation-list--vertical slds-has-block-links--space">
                <li class="slds-dropdown__item">
                    <a href="javascript:void(0);" role="menuitem" v-on:click="selectMenu(5)">
                        <p class="slds-truncate">
                            <svg aria-hidden="true" class="slds-icon slds-icon--small">
                                <use xlink:href="../../static/icons/standard-sprite/svg/symbols.svg#process"></use>
                            </svg>
                            开始使用
                        </p>
                    </a>
                </li>
                <li class="slds-dropdown__item">
                    <a href="javascript:void(0);" role="menuitem" v-on:click="selectMenu(6)">
                        <p class="slds-truncate">
                            <svg aria-hidden="true" class="slds-icon slds-icon--small">
                                <use xlink:href="../../static/icons/standard-sprite/svg/symbols.svg#topic"></use>
                            </svg>
                            开发文档
                        </p>
                    </a>
                </li>
                <li class="slds-dropdown__item">
                    <a href="javascript:void(0);" role="menuitem" v-on:click="selectMenu(7)">
                        <p class="slds-truncate">
                            <svg aria-hidden="true" class="slds-icon slds-icon--small">
                                <use xlink:href="../../static/icons/standard-sprite/svg/symbols.svg#case"></use>
                            </svg>
                            SDK下载
                        </p>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <div class="admin-content-body">
      <nav role="navigation" aria-label="Breadcrumbs" class="admin-navigtion">
          <ol class="slds-breadcrumb slds-list--horizontal">
              <li class="slds-breadcrumb__item slds-text-heading--label">
                <a href="javascript:void(0);">{{Administrator}}</a>
              </li>
              <li class="slds-breadcrumb__item slds-text-heading--label">
                <a href="javascript:void(0);">{{currentName}}</a>
              </li>
          </ol>
      </nav>
      <div class="admin-content-child">
        <!-- 如果不需要重新渲染, 添加keep-alive -->
        <component :is="currentView" transition="fade" transition-mode="out-in" keep-alive></component>
      </div>
    </div>
</div>

</template>

<script>

import Vue from 'vue'
import AV from 'leancloud-storage'
import appAdminStyle from '../../static/styles/Admin.css'
// 引入子模块
import WebAppConfig from 'components/WebAppConfig'
import Service from 'components/Service'

var Admin = Vue.extend({
    data() {
            return {
                selectAppName: 'Select An App Name',
                currentName: '',
                tagArray: ['Web App Config',
                'Module Management',
                'Services',
                'App Statistics',
                'Data Analysis',
                'Events',
                'Getting start',
                'Documents',
                'SDKs'],
                Administrator: '',
                currentView: 'WebAppConfig'
            }
        },
        methods: {
            toggle: function() {
                // 菜单的显示与隐藏
                var div = document.getElementById('admin-content-menu')
                if (div.getAttribute('open') == '1') {
                    div.setAttribute("open", '0')
                    div.className = 'slds-dropdown-trigger slds-dropdown-trigger--click'
                } else {
                    div.setAttribute("open", '1')
                    div.className = 'slds-is-open slds-dropdown-trigger slds-dropdown-trigger--click'
                }
            },
            menuClick: function(selectName) {
                // 菜单点击事件
                this.selectAppName = selectName
                this.toggle()
            },
            selectMenu: function(componentName) {
                // 菜单选择事件
                this.currentName = componentName
                var currentUser = AV.User.current()
                if ( currentUser ) {
                  this.Administrator = currentUser.attributes.mobilePhoneNumber
                }
                // 切换组件
                this.currentView = componentName
            }
        },
        activate: function (done) {
          done()
          var containerWidth = $('.admin-content').width();
          var leftWidth = $('.slds-grid').width();
          $('.admin-content-body').width(containerWidth-leftWidth - 60);
        },
        components: {
           'WebAppConfig': WebAppConfig,
           'Service': Service
        }
})
export default Admin

</script>

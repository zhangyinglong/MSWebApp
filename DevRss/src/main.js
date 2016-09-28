import Vue from 'vue'
// 组件
import App from './App'
import Enter from './components/Enter'
import Mine from './components/Mine'
import Collection from './components/Collection'
import Root from './components/Root'
import Articles from './components/Articles'

// 中间件
import Router from 'vue-router'
// 设置使用中间路由
Vue.use(Router)

// 工具中间件
import vue_scroll from 'vue_scroll'
Vue.use(vue_scroll)

// 创建外层路由
var route = new Router()
// 创建外层映射
route.map({
    '/root': {
        component: Root,
        subRoutes: {
            '/Enter': {
                component: Enter,
                root: '/root/Enter'
            },
            '/Mine': {
                component: Mine,
                root: '/root/Mine'
            },
            'Collection': {
                component: Collection,
                root: '/root/Collection'
            }
        },
        root: '/root/Enter'
    },
    '/Articles': {
        component: Articles,
        root: '/root/Enter'
    }
})
// 打开默认窗口
route.go('/root/Enter')
// 启动路由
route.start(App, 'app')
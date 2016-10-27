import Vue from 'vue'
import App from './App'
import VueRouter from 'vue-router'
import AV from 'leancloud-storage'

// components for the application
import Enter from './components/Enter'
import Login from './components/Login'
import Admin from './components/Admin'

// Initialize leancloud-storage
var APP_ID = 'XRMJLrfgrShFuDQ0KzP4hjVh-gzGzoHsz';
var APP_KEY = 'Hpr031Dy6xm7eThgvGv3RUQY';

AV.init({
  appId: APP_ID,
  appKey: APP_KEY,
});

// Set use router mid-ware
Vue.use(VueRouter)

// Initialize route
var router = new VueRouter()

// Map the compents
router.map({
    '/Enter': {
        component: Enter
    },
    '/Login': {
        component: Login
    },
    '/Admin': {
        component: Admin
    }
})

// Open the dafault page.
router.go('/Enter')

// Start router
router.start(App, 'app')

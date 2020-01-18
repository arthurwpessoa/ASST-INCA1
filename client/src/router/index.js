import Vue from 'vue'
import Router from 'vue-router'
import Login from '@/components/Login'
import Home from '@/components/Home'
import Register from '@/components/Register'
import Menu from '@/components/Menu'
import Points from '@/components/Points'
import Admin from '@/components/Admin'
Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Login',
      component: Login
    },
    {
      path: '/home',
      name: 'Home',
      component: Home
    },
    {
      path: '/register',
      name: 'Register',
      component: Register
    },
    {
      path: '/menu',
      name: 'Register Menu',
      component: Menu
    },
    {
      path: '/admin',
      name: 'Admin',
      component: Admin
    },
    {
      path: '/points',
      name: 'Points',
      component: Points
    }
  ]
})

<style scoped>
</style>

<template>
    <div class="slds-form--stacked">
      <!-- 手机号码以及密码输入框 -->
      <p class="login-p">登录</p><br>
      <div class="slds-form-element">
        <label class="slds-form-element__label" for="inputSample2">手机号码</label>
        <div class="slds-form-element__control">
          <input id="inputSample2" class="slds-input" type="text" placeholder="" v-model="username" />
        </div>
      </div>
      <div class="slds-form-element">
        <label class="slds-form-element__label" for="inputSample2">短信验证码</label>
        <div class="slds-form-element__control">
          <input id="inputSample2" class="slds-input" type="password" placeholder="" v-model="password" style="width: 60%;"/>
          <button v-bind:disabled="checkDisable" class="slds-button slds-button--brand login-button" type="button" v-on:click="smsAction" style="width: 37%; margin-top:-1px; margin-left: 2%;" >发送短信验证码</button>
        </div>
      </div>
      <!-- 记住密码以及登录等按钮操作 -->
      <br>
      <div class="slds-form-element">
        <div class="slds-form-element__control">
          <label class="slds-checkbox" for="agree">
            <input name="default" type="checkbox" checked="checked" id="agree" />
            <span class="slds-checkbox--faux"></span>
            <span class="slds-form-element__label">在这台电脑上记录我的登录信息</span>
          </label>
        </div>
      </div>
      <div class="slds-form-element">
        <button class="slds-button slds-button--brand login-button" type="button" v-on:click="loginAction">登录</button>
      </div>
    </div>
</template>

<script>

import Vue from 'vue'
import AV from 'leancloud-storage'
import appMainStyle from '../../static/styles/login.css'

var Login = Vue.extend({
  data() {
    return {
      username: '',
      password: '',
      check: true,
      checkDisable: false,
      login: false
    }
  },
  methods: {
    loginAction: function() {

      if ( !this.username ) {
        alert('请输入手机号码')
        return;
      }
      if ( !this.password ) {
        alert('请输入验证码！')
        return;
      }

      AV.User.signUpOrlogInWithMobilePhone(this.username, this.password).then(function (success) {
        // 成功
        if ( success ) {
          alert('登录成功')
          window.location.href = '/#!/Admin'
        } else {
          alert('登录碰到了问题, 请检查验证码是否正确, 并刷新界面重试')
        }
      }, function (error) {
        // 失败
        alert(error)
      });
    },
    smsAction: function() {
      if ( !this.username ) {
        alert('请输入手机号码')
        return
      }
      this.checkDisable = true
      AV.Cloud.requestSmsCode(this.username).then(function (success) {
        if ( success ) {
          alert('验证码发送成功！')
        } else {
          alert('验证码发送失败, 请刷新当前界面重试！')
        }
      }, function (error) {
        alert(error)
      });
    },
    goAdmin: function(transition) {
      var currentUser = AV.User.current();
      if (currentUser) {
        // 跳转到Admin
        window.location.href = '/#!/Admin'
      } else {
        // 打开登录
        transition.next()
      }
    }
  },
  route: {
    activate: function (transition) {
      this.goAdmin(transition)
    },
    deactivate: function (transition) {
      this.goAdmin(transition)
    }
  }
})

export default Login

</script>

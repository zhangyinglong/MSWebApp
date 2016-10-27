<style scoped>

</style>

<template>

<div class="srv-content">
  <p>添加业务模块</p>
  <div class="slds-form-element srv-content-form-ele">
    <label class="slds-form-element__label srv-content-tip" for="inputSample2">模块名称</label>
    <div class="slds-form-element__control">
      <input id="inputSample2" class="slds-input" type="text" placeholder="" />
    </div>
  </div>
  <div class="slds-form-element srv-content-form-ele">
    <label class="slds-form-element__label srv-content-tip" for="inputSample2">模块ID</label>
    <div class="slds-form-element__control">
      <input id="inputSample2" class="slds-input" type="text" placeholder="" />
    </div>
  </div>
  <div class="slds-form-element srv-content-form-ele">
    <label class="slds-form-element__label srv-content-tip" for="inputSample2">模块仓库地址</label>
    <div class="slds-form-element__control">
      <input id="inputSample2" class="slds-input" type="text" placeholder="" />
    </div>
  </div>
  <fieldset class="slds-form-element srv-content-form-ele">
    <legend class="slds-form-element__legend slds-form-element__label srv-content-tip">是否初始下载</legend>
    <div class="slds-form-element__control">
      <label class="slds-radio" for="lead">
        <input type="radio" name="options" id="lead" />
        <span class="slds-radio--faux"></span>
        <span class="slds-form-element__label srv-content-tip">初始下载(在App启动时预下载模块)</span>
      </label>
      <label class="slds-radio" for="education">
        <input type="radio" name="options" id="education" />
        <span class="slds-radio--faux"></span>
        <span class="slds-form-element__label srv-content-tip">临时加载(在App内使用前, 下载并加载模块)</span>
      </label>
    </div>
  </fieldset>
  <div class="slds-form-element srv-content-form-ele">
    <div class="slds-form-element__control">
      <label class="slds-checkbox" for="agree">
        <input name="default" type="checkbox" id="agree" />
        <span class="slds-checkbox--faux"></span>
        <span class="slds-form-element__label srv-content-tip">模块不可用(选中即为不可使用模块, 但存在于本地)</span>
      </label>
    </div>
  </div>
  <div class="slds-form-element srv-content-form-ele">
    <label class="slds-form-element__label srv-content-tip" for="textareaSample2">URL规则(Key:Value)</label>
    <div class="slds-form-element__control">
      <textarea id="textareaSample2" class="slds-textarea"></textarea>
    </div>
  </div>
  <div class="slds-form-element srv-content-form-ele">
    <label class="slds-form-element__label srv-content-tip" for="textareaSample2">额外配置参数(key: value)</label>
    <div class="slds-form-element__control">
      <textarea id="textareaSample2" class="slds-textarea"></textarea>
    </div>
  </div>
  <a href="#">保存并发布</a>
</div>

</template>

<script>

import Vue from 'vue'
import appAdminStyle from '../../static/styles/Service.css'

var s = Vue.extend({

})

export default s

</script>

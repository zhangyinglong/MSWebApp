<style scoped>

</style>

<template>

<!-- 入口以及内容 -->
<div class="wac-content">
    <table class="slds-table slds-table--bordered slds-table--cell-buffer wac-content-table">
        <thead>
            <tr>
                <th class="slds-is-resizable slds-cell-shrink">
                    <div class="slds-truncate wac-content-table-head">模块ID</div>
                </th>
                <th class="slds-is-resizable slds-cell-shrink">
                    <div class="slds-truncate wac-content-table-head">模块名称</div>
                </th>
                <th class="slds-is-resizable slds-cell-shrink">
                    <div class="slds-truncate wac-content-table-head">当前版本</div>
                </th>
                <th class="slds-is-resizable slds-cell-shrink">
                    <div class="slds-truncate wac-content-table-head">添加时间</div>
                </th>
                <th class="slds-is-resizable slds-cell-shrink">
                    <div class="slds-truncate wac-content-table-head">最后编辑</div>
                </th>
                <th class="slds-is-resizable slds-cell-shrink">
                    <div class="slds-truncate wac-content-table-head">模块操作</div>
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th>
                    <div class="slds-truncate wac-content-table-cell">ResumeDetail</div>
                </th>
                <td>
                    <div class="slds-truncate wac-content-table-cell">简历详情</div>
                </td>
                <td>
                    <div class="slds-truncate wac-content-table-cell">4a3efv</div>
                </td>
                <td>
                    <div class="slds-truncate wac-content-table-cell">07/15/2016</div>
                </td>
                <td>
                    <div class="slds-truncate wac-content-table-cell">08/01/2016</div>
                </td>
                <td>
                    <div class="slds-truncate slds-button-group" role="group">
                      <button class="slds-button slds-button--neutral wac-content-button">删除</button>
                      <button class="slds-button slds-button--neutral wac-content-button">编辑</button>
                      <button class="slds-button slds-button--neutral wac-content-button">日志</button>
                    </div>
                </td>
            </tr>
            <tr>
                <th>
                    <div class="slds-truncate wac-content-table-cell">MerchantDetail</div>
                </th>
                <td>
                    <div class="slds-truncate wac-content-table-cell">商户主页</div>
                </td>
                <td>
                    <div class="slds-truncate wac-content-table-cell">fb9ecd</div>
                </td>
                <td>
                    <div class="slds-truncate wac-content-table-cell">4/14/2015</div>
                </td>
                <td>
                    <div class="slds-truncate wac-content-table-cell">7/22/2015</div>
                </td>
                <td>
                    <div class="slds-truncate slds-button-group" role="group">
                      <button class="slds-button slds-button--neutral wac-content-button">删除</button>
                      <button class="slds-button slds-button--neutral wac-content-button">编辑</button>
                      <button class="slds-button slds-button--neutral wac-content-button">日志</button>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
</div>

</template>

<script>

import Vue from 'vue'
import appMainStyle from '../../static/styles/WebAppConfig.css'

var WAC = Vue.extend({

})

export default WAC

</script>

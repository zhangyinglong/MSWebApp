# MSWebApp

[![CI Status](https://travis-ci.org/WildDylan/MSWebApp.svg?branch=master)](https://travis-ci.org/WildDylan/MSWebApp)
[![Version](https://img.shields.io/cocoapods/v/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)
[![License](https://img.shields.io/cocoapods/l/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)
[![Platform](https://img.shields.io/cocoapods/p/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)

## How to use 如何使用

Config the WebApp for use: 配置WebApp:

step1. 步骤1

```objective-c
#import <MSWebApp/MSWebApp.h>
```

step2: 步骤2

Set the full url for where can get a config json. webApp will fetch modules in this config.

设置WebApp进行POST网络请求的地址

Request like:

请求的方式类似于：

`curl [MSWebApp webApp].fullURL -F app=(type) -F version=(local app version)`

`local app version` will auto send.
`type` means app type. keep reading.

请求参数： app ： 当前的类型，用于区分业务，但是每个App只允许有一种app type，是初始化webApp时候的type。

请求参数：version： 当前本地的version版本号码，自动的添加，如果第一次使用，为空串。

```objc
[MSWebApp webApp].fullURL = @"http://192.168.199.173:8080/webapp.json";
```

Start WebApp, the type will be transported in `fullURL` with `POST` method, sometimes, you need this param.

打开WebApp进行配置文件的获取以及模块的加载，一定要先设置请求的地址，然后进行start操作。

```objc
[MSWebApp startWithType:@"MEC"];
```

Config request result must like this: !!! 服务端返回的参数类似以下，只允许这种返回样式

模块的信息分别为：

模块ID、模块Zip下载地址、urls映射关系、版本号

```
{
    app =     {
        module =         (
                            {
                                mid = LeafModules;
                                packageurl = "http://um.devdylan.cn/LeafModules.zip";
                                urls =                 {
                                    "classPayment.tpl" = "classPayment.html";
                                    "detail.tpl" = "detail/detail.html";
                                    "enter.tpl" = "index.html";
                                };
                                version = ib42;
                                sync = "n"
                            },
                            {
                                mid = bootstrap;
                                packageurl = "http://um.devdylan.cn/bootstrap.zip";
                                urls =                 {
                                };
                                version = ib43;
                                sync = "n"
                            },
                            {
                                mid = vueModule;
                                packageurl = "http://um.devdylan.cn/vueModule.zip";
                                urls =                 {
                                    "enter.tpl" = "index.html";
                                };
                                version = "3.4.6";
                                sync = "n"
                            }
                        );
        version = "3.3.4";
    };
}
```

You can observe the module processed. obs `MSWebModuleFetchOk` String.

你可以监听模块处理的状态，是否加载成功。

```objc
[[NSNotificationCenter defaultCenter]
    addObserver:_tableView
    selector:@selector(reloadData)
    name:@"MSWebModuleFetchOk"
    object:nil];
```

step3. Open webView, Use the `instanceWithTplURL` medthod in `MSWebApp`, with URL, you can get an instance of `MSWebViewController`.

步骤3：使用MSWebApp instanceWithTplURL获得WebView实例，URL必须按照下边的规则（step4会说）。

```objc
if ( usePresentWebApp ) {
    UIViewController * viewController = [MSWebApp instanceWithTplURL:_urlField.text];
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
} else {
    UIViewController * viewController = [MSWebApp instanceWithTplURL:_urlField.text];
    [self.navigationController pushViewController:viewController animated:YES];
}
```

`MSWebViewController` have inner js bridge, use `WebViewJavaScriptBridge`, you can subClass of it and registe it for use.

默认的WebView中有JS桥，可以直接使用。 可以通过方法调用来进行方法的注册。推荐使用子类继承

SubClass:

继承：设置子类的Class

```objc
[MSWebApp webApp].registedClass = [SubClass class];
```

step4. Use it.

步骤4：使用

you can use: [MSWebApp instanceWithTplURL:(URL)];

explain the `URL`: 

解释一下URL：

http://{[MSWebApp webApp].fullURL.host}/{ModuleId}/{URLsKey}?{query}

`[MSWebApp webApp].fullURL.host`is the host you set.

首先会判断输入的URL的HOST 是否等于 你所获取配置文件的HOST，这里为了保持一致，所以采用这种规则。

`ModuleId` is module mid, identifier.

模块ID，用来查询指定模块。

`URLsKey` is the key in urls map, like:

URLsKey，映射关系，方便的通过xxx.tpl映射到多级绝对路径地址

```
{
                                mid = vueModule;
                                packageurl = "http://um.devdylan.cn/vueModule.zip";
                                urls =                 {
                                    "enter.tpl" = "index.html";
                                };
                                version = "3.4.6";
                                sync = "n"
}
```

if you want visit `index.html`,

the URL must be : `http://fullURL.host/vueModule/enter.tpl?a=b`

step5. Enjoy it !

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

MSWebApp is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MSWebApp"
```

现在可用的版本是0.2.0，还在继续更新，并处理问题。

所依赖的库：

```ruby
dependency 'AFNetworking' #网络请求
dependency 'WebViewJavascriptBridge' #JS桥
dependency 'LKDBHelper' #数据存储 Model2DB
dependency 'WPZipArchive' #Zip 处理
```

## Author

Dylan, dylan@china.com

## License

MSWebApp is available under the MIT license. See the LICENSE file for more info.

## 补充信息

## MSWeb App

#### 协议规则


http://tpl.zhaogeshi.me/{moduleName}/{tplid}.tpl?{param}

| 变量           | 说明                 |
| ------------ | ------------------ |
| {moduleName} | 模块名称               |
| {tplid}      | 模板ID（模块下的urls.key） |
| {param}      | 数据参数               |

遇到以上规则的地址调用MSWeb App, 问号后面的参数作为业务参数, 需通过JS桥传给web。

**动态注入参数直接使用 JS端提供的方法来注入。不需要手动添加script对象, 如果任然需要手动, 注意在界面 onload() 延时 200毫秒后调用注入的对象, 稍有延时。**

------

### 总控制配置文件

#### - 配置加载 webapp.json

接口名：webapp.json

参数列表

|  参数名称   |  请求类型  |      | 是否必须 |             说明             |
| :-----: | :----: | :--: | :--: | :------------------------: |
|   app   | String |      |  是   | 区别产品类别(商户 MEC、学生STU、保险INS) |
| version | String |      |  是   |     本地Hybrid总控配置文件的版本号     |

>  如果version、moduleVersion任意一项为空, 默认只会生成全新包
>
>  客户端本地做模块的差异对比

数据请求示例, Content-Type: application/json

```
app: "MEC",
version: "a4fc6"
```

#### 返回值

```
{
    "version": "WebApp 配置文件版本号",
    "module": [
        {
            "mid": "子模块名称/ID/唯一标识",
            "version": "子模块版本号字串, 一般为Git短版本号",
            "packageurl": "http://um.devdylan.cn/bootstrap.zip", # 子模块下载地址
            "urls": {}, # 子模块URL映射表: `TPL标识：真实路径`
            "sync": "y" # 是否同步加载
        },
        {
            "mid": "LeafModules",
            "version": "ib42",
            "packageurl": "http://um.devdylan.cn/LeafModules.zip",
            "urls": {
                "enter.tpl": "index.html",
                "classPayment.tpl": "classPayment.html",
                "detail.tpl": "detail/detail.html"
            },
            "sync": "y"
        }
    ]
}
```
> 可选：主动做文件CRC校验, 请勿使用MD5校验, 计算文件md5耗费大量时间。

注： 

- 生成配置文件流程：客户端携带当前配置文件版本以及子模块版本号->发起请求->服务端处理请求：

## html5 前端文件加载

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Document test</title>
    <!-- 加载公共资源css, 相对路径读取, 客户端会把所有的子模块解压到同一级文件夹下 -->
    <link rel="stylesheet" type="text/css" href="../../bootstrap/css/bootstrap.css">
</head>
<body>
	<form class="form-search">
	  	<input type="text" class="input-medium search-query">
  		<button type="submit" class="btn btn-info">Search</button>
	</form>
	
	<button class="btn btn-large btn-block btn-primary" type="button">Block level button</button>
	<button class="btn btn-large btn-block" type="button">Block level button</button>
	
</body>
</html>
```

#### 注：

- 所有的子模块解压到`统一级别目录下`，模块间调用使用相对路径。
- 打开新窗口可使用.tpl访问本地模块，如果本地模块不存在则访问线上模块。
- 保险类WebApp中web容器均需为全屏容器，并提供open方法以打开新的全屏容器。



#### 后台管理系统

###### 更新模块

接口名称：updateModule *提供新版本的模块版本号即可*

参数表单：param

| 参数名称       | 参数类型   | 参数描述      |
| ---------- | ------ | --------- |
| mid        | String | 模块ID      |
| version    | String | 新的Git短版本号 |
| packageurl | String | 模块下载地址    |
| urls       | Object | 对应规则      |
| sync       | String | 是否同步加载 y/n |

返回值：

```
{
  "message": "更新成功!",
  "status" : "successful",
}
```

###### 增加模块

接口名称：createModule *增加完整的模块配置*

参数表单：param

| 参数名称       | 参数类型   | 参数描述    |
| ---------- | ------ | ------- |
| mid        | String | 子模块唯一标识 |
| version    | String | 子模块版本   |
|            |        |         |
| packageurl | String | 子模块下载地址 |
| urls       | Object | 映射表     |
| sync       | String | 是否同步加载 y/n |

返回值：

```
{
  "message": "创建成功!",
  "status" : "successful",
  "data"   : {
            "mid": "子模块名称/ID/唯一标识",
            "version": "子模块版本号字串, 一般为Git短版本号",
            "packageurl": "http://um.devdylan.cn/bootstrap.zip", # 子模块下载地址
            "urls": {}, # 子模块URL映射表: `TPL标识：真实路径`
            "sync": "y"
  }
}
```



$更新时间: 2016-8-25 

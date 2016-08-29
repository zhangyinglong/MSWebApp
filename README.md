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
                            },
                            {
                                mid = bootstrap;
                                packageurl = "http://um.devdylan.cn/bootstrap.zip";
                                urls =                 {
                                };
                                version = ib43;
                            },
                            {
                                mid = vueModule;
                                packageurl = "http://um.devdylan.cn/vueModule.zip";
                                urls =                 {
                                    "enter.tpl" = "index.html";
                                };
                                version = "3.4.6";
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

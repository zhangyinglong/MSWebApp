# MSWebApp

[![CI Status](https://travis-ci.org/WildDylan/MSWebApp.svg?branch=master)](https://travis-ci.org/WildDylan/MSWebApp)
[![Version](https://img.shields.io/cocoapods/v/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)
[![License](https://img.shields.io/cocoapods/l/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)
[![Platform](https://img.shields.io/cocoapods/p/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)

What's `MSWebApp`: More and more html pages and frameworks has been used. React-native, weex, phone-gap ..., Learning that will spent a lot of time. But we only need some html page for a part of app. `MSWebApp`, dynamic manage and mount modules. 

Functions And features:

- [x] UIWebView support (Why not WKWebView? Can't hook with `URLProtocol`).
- [x] WebView-JavaScript bridge.
- [x] Check and download modules in diff.
- [x] Custom browser.
- [x] Convert URL to local file URL.
- [x] Module mount progress and do or not download when init, use sync download or not.
- [x] Auto reDownload when in used but file lose.
- [x] Provide a fileBrowser.
- [x] URLProtocol for resource check. Css, js, less, sass can be hooked.
- [x] Cache control, Disk cache, InMemory resource cache ( in master branch, in test!).

## How to use

```ruby
pod "MSWebApp", "~> 1.0.1"

#import <MSWebApp/MSWebApp.h>
```

Info that `MSWebApp` needed:

```objective-c
// FullURL: Server API path, for get the full config.
[MSWebApp webApp].fullURL = @"http://192.168.199.173:8080/webapp.json";

// Type: Seperate the difference app.
// If you have: 'Student client', 'Teacher client', you should need it.
[MSWebApp startWithType:@"MEC"];
```

Demo response for `[MSWebApp webApp].fullURL`, `MSWebApp Framework` use POST method, server response shuold like this:

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
sync = "n",
initdown = "y",
files: {
"/js/mui.js": "http://um.devdylan.cn/LeafModules/js/mui.js"
}
},
{
mid = bootstrap;
packageurl = "http://um.devdylan.cn/bootstrap.zip";
urls =                 {
};
version = ib43;
sync = "n",
initdown = "y",
files: {
"/js/mui.js": "http://um.devdylan.cn/LeafModules/js/mui.js"
}
},
{
mid = vueModule;
packageurl = "http://um.devdylan.cn/vueModule.zip";
urls =                 {
"enter.tpl" = "index.html";
};
version = "3.4.6";
sync = "y",
"initdown" = "n",
files: {}
}
);
version = "3.3.4";
};
}
```

Use KVO:

```objc
[[NSNotificationCenter defaultCenter]
addObserver:self
selector:@selector(reloadData:)
name:MSWebModuleFetchOk
object:nil];
```

States:


```objective-c
/** POST on config get success, notification.object is `MSWebAppOp`*/
FOUNDATION_EXTERN NSString MS_CONST MSWebAppGetOptionSuccess;
/** POST on config get with error, notification.object is `NSError` or nil*/
FOUNDATION_EXTERN NSString MS_CONST MSWebAppGetOptionFailure;
/** POST on module start download, notification.object is `MSWebAppModule`*/
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchBegin;
/** POST on module downloaded or ziped with error, notification.object is `MSWebAppModule`*/
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchErr;
/** POST on module handler OK, notification.object is `MSWebAppModule`*/
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchOk; 
/** POST on module mount progress changed*/
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchProgress;
```

Get browser instance:

```objective-c
UIViewController * viewController = [MSWebApp instanceWithTplURL:_urlField.text];
```

Also, you can custom it by subClass of `MSWebViewController`. Must registe it before you get instance.

```objective-c
[MSWebApp webApp].registedClass = [SubClass class];
```

URL rules:

http://{[MSWebApp webApp].fullURL.host}/{ModuleId}/{URLsKey}?{query}

URLsKey，it's a map in config response，get absolute path with something like `id`.
>Notice: URLs Map key, should have suffix `.tpl`!

```
{
mid = vueModule;
packageurl = "http://um.devdylan.cn/vueModule.zip";
urls =                 {
"enter.tpl" = "index.html";
};
version = "3.4.6";
sync = "n",
initdown = "y",
files: {}
}
```

Visit  `index.html` in this module: 

Shoule use: `http://[MSWebApp webApp].fullURL.host/vueModule/enter.tpl?a=b`
Why the URL's host same as [MSWebApp webApp].fullURL.host: Suggest use Independent server to do this.

## Example project

`cd Example`And run `pod install`。

## WebApp version info

Version: 1.0.1 can used for product.
Version: 1.0.2 include URLProtocol, beta version, don't used for production.

Denpendences：

```ruby
dependency 'AFNetworking' # API Requets
dependency 'WebViewJavascriptBridge' # JS bridge
dependency 'LKDBHelper' # Model 2 DB
dependency 'WPZipArchive' # Zip, unZip
```

## Licences

MIT.

## Annex

#### URL

http:/{host}/{moduleName}/{tplid}.tpl?{param}

| Param        | Desc                                 |
| ------------ | ------------------------------------ |
| {moduleName} | mid                                  |
| {tplid}      | TID（urls.key in module config json）|
| {param}      | query                                |
| {host}       | host same as config request API.host |

### APIs

#### webapp.json (get config)

API path：webapp.json

param list: 

|  Param  |  Type  |      | Must |                  Desc                   |
| :-----: | :----: | :--: | :--: | :-------------------------------------: |
|   app   | String |      |  Y   |            seperate product             |
| version | String |      |  Y   | local webApp version, will auto append. |

>  If version param empty, server shoule response the latest config.
>  The latest config have all active modules, MSWebApp framework will check it. Update, cover or delete.

Request like:

```
// Content-Type: application/json
app: "MEC",
version: "a4fc6"
```

## html

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Document test</title>
<!-- loaded public css, use relative path, All modules will in same level directory. -->
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

>If Module download failure or lose file, will request from server.

#### CMS

###### update module

API path：updateModule

param list: 

| param      | type   | desc                                     |
| ---------- | ------ | ---------------------------------------- |
| mid        | String | module ID                                |
| version    | String | version, sometimes, shoule be git short version |
| packageurl | String | module zip download url                  |
| urls       | Object | key:value id:absolute path               |
| sync       | String | sync load y/n                            |
| initdown   | String | y: download when get config success. n: not download it. |

response：

```
{
"message": "update success!",
"status" : "successful",
}
```

## Questions

Q：I want enter App when modules mounted.
A：Observe `MSWebModuleFetchOk` And `MSWebAppGetOptionSuccess`, you will get `MSWebAppGetOptionSuccess` first, wait `FetchOK`, when you get this notification, build a temp array and add it, while temp array count same as [MSWebApp webapp].op.modules count, all modules loaded success. but you should care, if module loaded failure, you should do somthing.

Q：If config loaded with error？
A：Observe `MSWebAppGetOptionFailure`, do `startWithType:`.

# MSWebApp

[![CI Status](https://travis-ci.org/WildDylan/MSWebApp.svg?branch=master)](https://travis-ci.org/WildDylan/MSWebApp)
[![Version](https://img.shields.io/cocoapods/v/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)
[![License](https://img.shields.io/cocoapods/l/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)
[![Platform](https://img.shields.io/cocoapods/p/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)

What's `MSWebApp`: More and more html/html5 show in native apps, learn react-native, weex, and other web app framework will waste a lot of times, also, we only need some dynamic pages use html for show. `MSWebApp`is used for this!

MSWebApp provide an webViewController with JavaScript bridge, auto check server modules and download it, match local file URL with origin URL, custom your webView with basic web container. But it's not enough, i will do something better, like: LRU with resources, auto checkout image resources with URLProtocol, in memory caches.

Functions And futures:

- [x] WKWebView/UIWebView support.
- [x] WebView-JavaScript bridge support.
- [x] Auto check and download modules.
- [x] Custom webViewController. (subClass it).
- [x] Auto check URL, load from local or server.
- [ ] LRU, resources in memory cached control
- [ ] URLProtocol
- [ ] Cache control, Disk cache -> inMemory cache -> webView cache.

## How to use

```ruby
pod "MSWebApp", "~> 0.9.0"

#import <MSWebApp/MSWebApp.h>
```

And then, in your appDelegate or where you want to load it:

```objective-c
// FullURL, is the server API path, where you can get the full config json object.
[MSWebApp webApp].fullURL = @"http://192.168.199.173:8080/webapp.json";
// Type, is for you to seperate the difference business demand.
// e.g, your company have: 'Student client', 'Teacher client', you may need it.
[MSWebApp startWithType:@"MEC"];
```

This is the demo response object for `[MSWebApp webApp].fullURL`, `MSWebApp Framework`will POST to this URL, so your server response shuold like this. This response object only for `Version <= 1.0`, future, will add properties to every module.

server API response:

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

Also, after start webApp, you can use KVO to observe the config and module loading state.

```objc
[[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(reloadData:)
    name:MSWebModuleFetchOk
    object:nil];
```

The state you can get: 

```objective-c
FOUNDATION_EXTERN NSString MS_CONST MSWebAppGetOptionSuccess; // Get config and handler success.
FOUNDATION_EXTERN NSString MS_CONST MSWebAppGetOptionFailure; // Get config wiht failure.
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchBegin;	  // Start fetch Module.
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchErr;	  // Module download or unzip with error.
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchOk;		  // Module downloaded and unziped. 
```

Now, hypothesis the module loaded complete. Open webView.

```objective-c
UIViewController * viewController = [MSWebApp instanceWithTplURL:_urlField.text];
```

Yep, it's simple.also, you can get your own custom webView subClass of `MSWebViewController`. but you must set it before you get webViewController instance.

```objective-c
[MSWebApp webApp].registedClass = [SubClass class];
```

explain the URL for get webView Controller instance：

http://{[MSWebApp webApp].fullURL.host}/{ModuleId}/{URLsKey}?{query}

URLsKey，it's a map in config response，get absolute path with something lik `id`.

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

e.g: you want visit  `index.html` in this module,

URL shoule be: `http://[MSWebApp webApp].fullURL.host/vueModule/enter.tpl?a=b`

Why the host of URL shoule same as [MSWebApp webApp].fullURL.host, because i suggest use the Independent server to do this, it's the rule, you must comply with it.

## Example project

`cd Example`And run `pod install`。

## WebApp version info

Now, the 0.9.0 version can be used normally.

MSWebApp denpendences：

```ruby
dependency 'AFNetworking' # For API Requets
dependency 'WebViewJavascriptBridge' # JS bridge
dependency 'LKDBHelper' # Model2DB
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
| {tplid}      | TID（urls.key in module config json）  |
| {param}      | query                                |
| {host}       | host same as config request API.host |

### APIs

#### webapp.json (get full config)

API path：webapp.json

param list: 

|  Param  |  Type  |      | Must |                  Desc                   |
| :-----: | :----: | :--: | :--: | :-------------------------------------: |
|   app   | String |      |  Y   |            seperate product             |
| version | String |      |  Y   | local webApp version, will auto append. |

>  if version is empty, server shoule response latest config.
>
>  The latest config have all active modules, MSWebApp framework will auto checkout it. update, cover or delete local modules.

Request like: Content-Type: application/json

```
app: "MEC",
version: "a4fc6"
```

Future:

- [ ] Check CRC for every file, Add file list to config.

## html5 coding

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

> Tip: Html shoule distinguish in app or pc, when loaded it in `MSWebApp`, if Module download failure, will request server.


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

response：

```
{
  "message": "update success!",
  "status" : "successful",
}
```

## Questions

Q：I want open my root App when loaded modules complete.
A：observe `MSWebModuleFetchOk`And`MSWebAppGetOptionSuccess`, you will get`MSWebAppGetOptionSuccess` first, wait `FetchOK`, when you get this notification, build a temp array and add it, while temp array count same as [MSWebApp webapp].op.modules count, all modules loaded success. but you should care, if module loaded failure, you should do somthing.

Q：If config loaded failure？
A：observe `MSWebAppGetOptionFailure`, do  `startWithType:`.

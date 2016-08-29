# MSWebApp

[![CI Status](http://img.shields.io/travis/Dylan/MSWebApp.svg?style=flat)](https://travis-ci.org/Dylan/MSWebApp)
[![Version](https://img.shields.io/cocoapods/v/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)
[![License](https://img.shields.io/cocoapods/l/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)
[![Platform](https://img.shields.io/cocoapods/p/MSWebApp.svg?style=flat)](http://cocoapods.org/pods/MSWebApp)

## How to use

Config the WebApp for use:

step1. 

```objective-c
#import <MSWebApp/MSWebApp.h>
```

step2: 

Set the full url for where can get a config json. webApp will fetch modules in this config.

Request like:

`curl [MSWebApp webApp].fullURL -F app=(type) -F version=(local app version)`

`local app version` will auto send.
`type` means app type. keep reading.

```objc
[MSWebApp webApp].fullURL = @"http://192.168.199.173:8080/webapp.json";
```

Start WebApp, the type will be transported in `fullURL` with `POST` method, sometimes, you need this param.

```objc
[MSWebApp startWithType:@"MEC"];
```

Config request result must like this: !!!

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

```objc
[[NSNotificationCenter defaultCenter]
    addObserver:_tableView
    selector:@selector(reloadData)
    name:@"MSWebModuleFetchOk"
    object:nil];
```

step3. Open webView, Use the `instanceWithTplURL` medthod in `MSWebApp`, with URL, you can get an instance of `MSWebViewController`.

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

SubClass:

```objc
[MSWebApp webApp].registedClass = [SubClass class];
```

step4. Use it.

you can use: [MSWebApp instanceWithTplURL:(URL)];

explain the `URL`: 

http://{[MSWebApp webApp].fullURL.host}/{ModuleId}/{URLsKey}?{query}

`[MSWebApp webApp].fullURL.host`is the host you set.

`ModuleId` is module mid, identifier.

`URLsKey` is the key in urls map, like:

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

## Author

Dylan, dylan@china.com

## License

MSWebApp is available under the MIT license. See the LICENSE file for more info.

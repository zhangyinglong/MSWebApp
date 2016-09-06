//
//  MViewController.m
//  MSWebApp
//
//  Created by Dylan on 08/25/2016.
//  Copyright (c) 2016 Dylan. All rights reserved.
//

#import "MViewController.h"
#import "MMTableViewCell.h"
#import "MSubWebViewController.h"

#import <MSWebApp/MSWebApp.h>

@interface MViewController () <UITableViewDelegate, UITableViewDataSource> {
    BOOL usePresentWebApp;
}

@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property ( nonatomic, strong ) NSMutableDictionary *dataDict;

@end

@implementation MViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    usePresentWebApp = NO;
    _dataDict       = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(newModuleProcressed:)
     name:MSWebModuleFetchOk
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(newModuleProcressed:)
     name:MSWebModuleFetchErr
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(newModuleProcressed:)
     name:MSWebModuleFetchBegin
     object:nil];
    
    [MSWebApp webApp].fullURL = @"http://192.168.199.173:8080/webapp.json";
    [MSWebApp startWithType:@"MEC"];
    
    [MSWebApp webApp].registedClass = [MSubWebViewController class];
}

- (void) newModuleProcressed: (NSNotification *) notification {
    MSWebAppModule * module = notification.object;
    [_dataDict setObject:module forKey:module.mid];
    if ( [notification.name isEqualToString:MSWebModuleFetchOk] ) {
        // 模块加载成功
        module.desc = @"加载成功";
    } else if ( [notification.name isEqualToString:MSWebModuleFetchErr] ) {
        // 模块加载失败
        module.desc = @"加载失败";
    } else {
        // 模块开始加载
        module.desc = @"加载中...";
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleCell"];
    
    MSWebAppModule * module = _dataDict[_dataDict.allKeys[indexPath.row]];
    cell.mLabel.text = module.mid;
    cell.vLabel.text = module.desc;
    
    return cell;
}

- (IBAction) openWebApp: (UIButton *) sender {
    if ( usePresentWebApp ) {
        UIViewController * viewController = [MSWebApp instanceWithTplURL:_urlField.text];
        [self.navigationController presentViewController:viewController animated:YES completion:nil];
    } else {
        UIViewController * viewController = [MSWebApp instanceWithTplURL:_urlField.text];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction) popTypeDidChanged: (UISegmentedControl *) sender {
    if ( sender.selectedSegmentIndex ) {
        usePresentWebApp = YES;
    } else {
        usePresentWebApp = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
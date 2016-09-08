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
#import <MSFileBrowserTableViewController.h>
#import <MSWebAppUtil.h>

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
    
    [MSWebApp enableLogging];
    
    usePresentWebApp = NO;
    _dataDict       = [NSMutableDictionary dictionaryWithCapacity:1];
    
    /**
     Add observer to self.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newModuleProcressed:) name:MSWebModuleFetchOk object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newModuleProcressed:) name:MSWebModuleFetchErr object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newModuleProcressed:) name:MSWebModuleFetchBegin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressChanged:) name:MSWebModuleFetchProgress object:nil];
    /**
     Set config request URL.
     */
    [MSWebApp webApp].fullURL = @"http://192.168.199.173:8080/webapp.json";
    
    /**
     Start MSWebApp, start request config API, download, zip modules.
     */
    [MSWebApp startWithType:@"MEC"];
    
    /**
     Set custom WebViewController, MSubWebViewController is subClass of MSWebViewController.
     */
    [MSWebApp webApp].registedClass = [MSubWebViewController class];
}

- (void) newModuleProcressed: (NSNotification *) notification {
    // Get current moduel from notification.objecy
    MSWebAppModule * module = notification.object;
    [_dataDict setObject:module forKey:module.mid];
    if ( [notification.name isEqualToString:MSWebModuleFetchOk] ) {
        module.desc = @"success";
    } else if ( [notification.name isEqualToString:MSWebModuleFetchErr] ) {
        module.desc = @"failure";
    } else {
        module.desc = @"loading";
    }
    [_tableView reloadData];
}

- (void) progressChanged: (NSNotification *) notification {
    // Handler
    MSWebAppModule * module = notification.object;
    [_dataDict setObject:module forKey:module.mid];
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
    cell.progressBar.progress = module.mountProgress;
    cell.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", module.mountProgress * 100];
    
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

- (IBAction)openFileBrowser:(UIBarButtonItem *)sender {
    MSFileBrowserTableViewController * browser = [[MSFileBrowserTableViewController alloc] initWithFolderPath:[MSWebAppUtil getLocalCachePath]];
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

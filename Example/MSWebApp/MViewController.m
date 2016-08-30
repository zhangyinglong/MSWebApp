//
//  MViewController.m
//  MSWebApp
//
//  Created by Dylan on 08/25/2016.
//  Copyright (c) 2016 Dylan. All rights reserved.
//

#import "MViewController.h"
#import "MMTableViewCell.h"
#import <MSWebApp/MSWebApp.h>

@interface MViewController () <UITableViewDelegate, UITableViewDataSource> {
    BOOL usePresentWebApp;
}

@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    usePresentWebApp = NO;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:_tableView
     selector:@selector(reloadData)
     name:@"MSWebModuleFetchOk"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:_tableView
     selector:@selector(reloadData)
     name:@"MSWebModuleFetchErr"
     object:nil];
    
    [MSWebApp webApp].fullURL = @"http://192.168.199.173:8080/webapp.json";
    [MSWebApp startWithType:@"MEC"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MSWebApp webApp].op.module.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleCell"];
    cell.mLabel.text = [MSWebApp webApp].op.module[indexPath.row].mid;
    cell.vLabel.text = [MSWebApp webApp].op.module[indexPath.row].version;
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
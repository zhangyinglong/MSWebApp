//
//  MSubWebViewController.m
//  MSWebApp
//
//  Created by Dylan on 2016/9/6.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MSubWebViewController.h"

@interface MSubWebViewController ()

@end

@implementation MSubWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void) backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) load404: (id) content {
    NSURL * u = [[NSBundle mainBundle] URLForResource:@"MSWeb_404" withExtension:@"htm"];
    [self.browser loadRequest:[NSURLRequest requestWithURL:u]];
}

- (void) startLoad {
    NSLog(@"开始加载");
}

- (void) finishLoad {
    NSLog(@"加载结束");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ViewController.m
//  WebComponent
//
//  Created by Dylan on 2016/9/1.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate> {
    BOOL _debugger;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *moveDebugger;
@property (weak, nonatomic) IBOutlet UIButton *debugButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *httpLocation = @"http://10.0.0.125:8080";
    NSURL *url = [NSURL URLWithString:httpLocation];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    _webView.scrollView.bounces = YES;
    _webView.scrollView.delegate = self;
    _moveDebugger.delegate = self;
    _debugger = NO;
}

- (IBAction)reload:(UIButton *)sender {
    CGPoint origin = sender.frame.origin;
    
    void (^animated)();
    void (^finished)(BOOL f);
    
    if ( NO == _debugger ) {
        animated = ^() {
            sender.frame = CGRectMake(20, origin.y, self.view.bounds.size.width - 40, 50);
            [sender setTitle:@"" forState:UIControlStateNormal];
            [self buildDebuggerAction:sender];
        };
        finished = ^(BOOL f) {
            _debugger = YES;
        };
    } else {
        animated = ^() {
            sender.frame = CGRectMake(origin.x, origin.y, 50, 50);
            [sender setTitle:@"D" forState:UIControlStateNormal];
            [self removeDebuggerAction:sender];
        };
        finished = ^(BOOL f) {
            _debugger = NO;
        };
    }
    
    [UIView animateWithDuration:.25 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.8 options:UIViewAnimationOptionLayoutSubviews animations:animated completion:finished];
}

static int inset = 5;

- (void) buildDebuggerAction: (UIButton *) sender {
    [self removeDebuggerAction:sender];
    
    UIButton    *reloadButton;
    UIButton    *bouncedButton;
    UIButton    *loadButton;
    
    /* reload */
    reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [reloadButton setTitle:@"R" forState:UIControlStateNormal];
    [reloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [reloadButton addTarget:_webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [sender addSubview:reloadButton];
    
    /* can bounces */
    bouncedButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(reloadButton.frame) + inset, 5, 40, 40)];
    [bouncedButton setTitle:@"B" forState:UIControlStateNormal];
    [bouncedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal
     ];
    [bouncedButton addTarget:self action:@selector(bounces:) forControlEvents:UIControlEventTouchUpInside];
    [sender addSubview:bouncedButton];
    
    if ( _webView.scrollView.bounces ) {
        [bouncedButton setBackgroundColor:[UIColor greenColor]];
    } else {
        [bouncedButton setBackgroundColor:[UIColor redColor]];
    }
    
    /* load url */
    loadButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bouncedButton.frame) + inset, 5, 40, 40)];
    [loadButton setTitle:@"L" forState:UIControlStateNormal];
    [loadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [loadButton addTarget:self action:@selector(loadNew) forControlEvents:UIControlEventTouchUpInside];
    [sender addSubview:loadButton];
    
    [self radius:reloadButton];
    [self radius:bouncedButton];
    [self radius:loadButton];
}

- (void) radius: (UIView *) sender {
    sender.layer.cornerRadius = 3;
    sender.layer.masksToBounds = YES;
}

- (void) bounces: (UIButton *) sender {
    _webView.scrollView.bounces = !_webView.scrollView.bounces;
    if ( _webView.scrollView.bounces ) {
        [sender setBackgroundColor:[UIColor greenColor]];
    } else {
        [sender setBackgroundColor:[UIColor redColor]];
    }
}

- (void) removeDebuggerAction: (UIButton *) sender {
    [sender.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * stop) {
        if ( [obj isKindOfClass:[UIButton class]] ) {
            [obj removeFromSuperview];
        }
    }];
}

- (void) loadNew {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Debugger" message:@"请输入要打开的完整URL :)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * open = [UIAlertAction actionWithTitle:@"Open" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString * text = alertController.textFields.lastObject.text;
        if ( text && ![text isEqualToString:@""] && [NSURL URLWithString:text] ) {
            NSURL *url = [NSURL URLWithString:text];
            [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Don't" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:open];
    [alertController addAction:cancel];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField) {
        textField.placeholder = @"http://";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)panGes:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    [UIView animateWithDuration:.25 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        sender.view.center = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    } completion:^(BOOL finished) {
        
    }];
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _debugger = YES;
    [self reload:_debugButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

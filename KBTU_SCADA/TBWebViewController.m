//
//  TBWebViewController.m
//  TBClient
//
//  Created by Jason Townes French on 11/8/15.
//  Copyright © 2015 TRU Beauty. All rights reserved.
//

#import "TBWebViewController.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constants.h"

@interface TBWebViewController ()
    @property (nonatomic, strong) UIWebView* webView;
    @property (nonatomic, assign) BOOL hasUpdatedConstraints;
    @property (nonatomic, assign) NSInteger selectedIndex;
    @end

@implementation TBWebViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //  [self.navigationController setNavigationBarHidden:YES animated:YES];
}
    
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
    
- (instancetype)init
    {
        self = [super init];
        if (self) {
            [self setupViews];
        }
        return self;
    }
    
    
- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle =headerTitle;
    [self.navigationItem setTitle:headerTitle];
}
    
- (void)setupViews {
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
}
    
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
-(void) loadUrl:(NSString*)url
    {
        NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
    
- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
    
#pragma mark - UIWebViewDelegate
    
    
#pragma mark - Status Bar
    
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
    
    @end

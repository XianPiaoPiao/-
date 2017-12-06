//
//  HTMLViewController.m
//  SimpleWord
//
//  Created by Chenly on 16/8/23.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController ()


@end

@implementation HTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
//    if (_HTMLString.length <= 0) {
//        
//        [LCProgressHUD showInfoMsg:@"此商品详情为空"];
//        
//    }
    self.webView = ({
        
        UIWebView *webView = [[UIWebView alloc] init];
        webView.dataDetectorTypes = UIDataDetectorTypeNone;
        [self.view addSubview:webView];
        webView;
    });
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.webView loadHTMLString:self.HTMLString baseURL:nil];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHTMLString:(NSString *)HTMLString {

    _HTMLString = [HTMLString copy];
    if (self.webView) {
        
    [self.webView loadHTMLString:HTMLString baseURL:nil];
        
  }
    
}

@end

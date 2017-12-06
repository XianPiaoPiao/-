//
//  ScanErcodeEndingController.m
//  XuXin
//
//  Created by xuxin on 16/11/7.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ScanErcodeEndingController.h"

@interface ScanErcodeEndingController ()
@property (strong, nonatomic) UIWebView * registerWebView;

@end

@implementation ScanErcodeEndingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavgationBar];
    [self creatUI];

}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
}
-(void)creatNavgationBar{
   
    [self addNavgationTitle:@"注册"];
    [self addBackBarButtonItem];
   
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    
    self.registerWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,  0, ScreenW, screenH )];
    self.registerWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.registerWebView];
    [self.registerWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.registetWebUrl]]];
}


@end

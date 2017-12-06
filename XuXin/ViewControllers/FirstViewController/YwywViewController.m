//
//  YwywViewController.m
//  XuXin
//
//  Created by xuxin on 16/12/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "YwywViewController.h"


@interface YwywViewController ()
@property (strong, nonatomic) UIWebView * ywywWebView;

@end

@implementation YwywViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
    [self creatUI];

}


-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"以物易物"];
    [self addBackBarButtonItem];
    
}
-(void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    
    self.ywywWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,  0, ScreenW, screenH )];
    [self.view addSubview:self.ywywWebView];
    [self.ywywWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ywywHtmlUrl]]];
}


@end

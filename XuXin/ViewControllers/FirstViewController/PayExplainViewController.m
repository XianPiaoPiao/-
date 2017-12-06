//
//  PayExplainViewController.m
//  XuXin
//
//  Created by xuxin on 16/11/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "PayExplainViewController.h"

@interface PayExplainViewController ()
@property (strong, nonatomic) UIWebView * explainWebView;

@end

@implementation PayExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNavgationBar];
    [self creatUI];
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"买单说明"];
    [self addBackBarButtonItem];
    
}
-(void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    
    self.explainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,  0, ScreenW, screenH )];
    self.explainWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.explainWebView];
    [self.explainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payExplainHtmlUrl]]];
}

@end

//
//  HtmWalletPaytypeController.m
//  XuXin
//
//  Created by xuxin on 16/11/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HtmWalletPaytypeController.h"

@interface HtmWalletPaytypeController ()
@property (nonatomic ,strong)UIWebView * explainWebView;
@end

@implementation HtmWalletPaytypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
    [self creatUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)creatNavgationBar{
    
    if (_htmlType == supendHtmlType) {
        [self addNavgationTitle:@"预充值说明"];
    }else if(_htmlType == balaceHtmlType){
        [self addNavgationTitle:@"余额说明"];

    }else if (_htmlType == pointHtmlType){
        [self addNavgationTitle:@"积分说明"];

    }else if (_htmlType == delegateHtmlType){
        [self addNavgationTitle:@"我要代理说明"];

    }else if (_htmlType == redWalletHtmlType){
        [self addNavgationTitle:@"红包说明"];
    }else if (_htmlType == activiteHtmlType){
        
        [self addNavgationTitle:@"活动说明"];
    }else if (_htmlType == couponRulerType){
        [self addNavgationTitle:@"兑换券规则"];
    }else if (_htmlType == registrAgreementType){
        [self addNavgationTitle:@"用户注册协议"];

    }else if (_htmlType == joinType){
        [self addNavgationTitle:@"加盟协议"];

    }
    
    [self addBackBarButtonItem];
    
}

-(void)creatUI{
    
    self.explainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,  0, ScreenW, screenH )];
    self.explainWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.explainWebView];
    [self.explainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
@end

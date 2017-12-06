//
//  RecommondStoreBaseController.m
//  XuXin
//
//  Created by xuxin on 16/12/1.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecommondStoreBaseController.h"
//友盟分享
#import "RecommondStoreController.h"
#import "RecommondStoresController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "XXSegementControl.h"
@interface RecommondStoreBaseController ()

@end

@implementation RecommondStoreBaseController{
    
    XXSegementControl * _segment;
    RecommondStoreController * _recommondStoreVC;
    //推荐商家排行榜
    RecommondStoresController * _recommondBaseVC;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MTA trackPageViewBegin:@"RecommondStoreBaseController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"RecommondStoreBaseController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self creatNavgationBar];
    
    [self settingUI];
    
}
-(void)creatNavgationBar{
    
    UIView * navBgView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navBgView];
    NSArray * array = @[@"推荐的商家",@"商家排行榜"];
    UIButton * returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 22+self.StatusBarHeight, 50, 40)];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:8];

    
    [returnBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    [returnBtn setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];
    [navBgView addSubview:returnBtn];
    //创建一个自定制的segment
    _segment = [[XXSegementControl alloc] initWithItems:array];
    
    _segment.frame = CGRectMake(60, 20+self.StatusBarHeight, 200 , 44);
    _segment.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);

    [_segment addTarget:self action:@selector(jumpViewController:)];
    [self.view addSubview:_segment];
    
   
    
}
-(void)jumpViewController:(XXSegementControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        
        _recommondStoreVC.view.frame = CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH -64);
        _recommondBaseVC.view.frame = CGRectMake(ScreenW, KNAV_TOOL_HEIGHT, ScreenW, screenH - 64);
   
        
    }else if (segment.selectedSegmentIndex == 1){
        
        _recommondBaseVC.view.frame = CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH - 64);
        _recommondStoreVC.view.frame = CGRectMake(ScreenW, KNAV_TOOL_HEIGHT, ScreenW, screenH -64);
   
    }
}
-(void)returnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)settingUI{
    
    _recommondBaseVC = [[RecommondStoresController alloc] init];
    [self.view addSubview:_recommondBaseVC.view];
    _recommondBaseVC.view.frame = CGRectMake(ScreenW, KNAV_TOOL_HEIGHT, ScreenW, screenH);
    [self addChildViewController:_recommondBaseVC];
    
    _recommondStoreVC = [[RecommondStoreController alloc] init];
    _recommondStoreVC.view.frame = CGRectMake(0,KNAV_TOOL_HEIGHT, ScreenW, screenH);

    [self.view addSubview:_recommondStoreVC.view];
    [self addChildViewController:_recommondStoreVC];
    
}


@end

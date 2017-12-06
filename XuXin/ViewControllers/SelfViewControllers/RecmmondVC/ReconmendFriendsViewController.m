//
//  ReconmendFriendsViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/27.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ReconmendFriendsViewController.h"
#import "ChampionBaseViewController.h"
#import "RecomodRankBaseViewController.h"
#import "MyQrcodeViewController.h"
#import "RecomondMyFriendViewController.h"
//友盟分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "XXSegementControl.h"
@interface ReconmendFriendsViewController ()


@end

@implementation ReconmendFriendsViewController{
    
    MyQrcodeViewController * _myQrcodeVC;
    RecomondMyFriendViewController * _MyfriendVC;
    RecomodRankBaseViewController  * _RecomondfriendsBaseVC;
    XXSegementControl * _segment;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MTA trackPageViewBegin:@"ReconmendFriendsViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"ReconmendFriendsViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self settingUI];
    
}
-(void)creatNavgationBar{

    UIView * navBgView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navBgView];
    NSArray * array = @[@"二维码",@"推荐",@"排行榜"];
    UIButton * returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 22+self.StatusBarHeight, 50, 40)];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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

    //分享
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        shareBtn.frame = CGRectMake(ScreenW - 30, 34+self.StatusBarHeight, 16, 16);
    shareBtn.tintColor = [UIColor blackColor];
    [shareBtn setImage:[UIImage imageNamed:@"s03@2x"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareMyercode) forControlEvents:UIControlEventTouchDown];
    [navBgView addSubview:shareBtn];
    
}
-(void)jumpViewController:(XXSegementControl *)segment{
    if (segment.selectedSegmentIndex == 0) {

    _myQrcodeVC.view.frame = CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH -64);
    _RecomondfriendsBaseVC.view.frame = CGRectMake(ScreenW, 64, ScreenW, screenH - 64);
     _MyfriendVC.view.frame = CGRectMake(ScreenW, 64, ScreenW, screenH - 64);

    }else if (segment.selectedSegmentIndex == 1){

        _MyfriendVC.view.frame = CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH - 64);
        _myQrcodeVC.view.frame = CGRectMake(ScreenW, 64, ScreenW, screenH -64);
        _RecomondfriendsBaseVC.view.frame = CGRectMake(ScreenW, 64, ScreenW, screenH - 64);
    }else if (segment.selectedSegmentIndex == 2){

        _RecomondfriendsBaseVC.view.frame = CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH - 64);
        _MyfriendVC.view.frame = CGRectMake(ScreenW, 64, ScreenW, screenH - 64);
        _myQrcodeVC.view.frame = CGRectMake(ScreenW, 64, ScreenW, screenH -64);
    }
}
-(void)returnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)settingUI{
    
    //我的二维码
    _myQrcodeVC = [[MyQrcodeViewController alloc] init];
    _myQrcodeVC.view.frame = CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH -64);
    [self.view addSubview:_myQrcodeVC.view];
    
    //添加智世图控制器
    [self addChildViewController:_myQrcodeVC];
    
 //   推荐朋友排行榜
    _RecomondfriendsBaseVC =[[RecomodRankBaseViewController alloc] init];
   
    _RecomondfriendsBaseVC.requestUrl = recommendUserRankingUrl;
    _RecomondfriendsBaseVC.recommondType = recomondFriendsType;
     _RecomondfriendsBaseVC.view.frame = CGRectMake(ScreenW, KNAV_TOOL_HEIGHT, ScreenW, screenH -64);
    [self.view addSubview:_RecomondfriendsBaseVC.view];
    [self addChildViewController:_RecomondfriendsBaseVC];

    //我的推荐
    _MyfriendVC = [[RecomondMyFriendViewController alloc] init];
    _MyfriendVC.view.frame = CGRectMake(ScreenW, KNAV_TOOL_HEIGHT, ScreenW, screenH -64);
    [self.view addSubview:_MyfriendVC.view];

    [self addChildViewController:_MyfriendVC];


}
-(void)shareMyercode{
    //分享文字
    NSString * shareText = [NSString stringWithFormat:@"我的二维码"];
    //分享图片

    
    [UMSocialWechatHandler setWXAppId:__WXappID appSecret:__WXappSecret url:[NSString stringWithFormat:@"%@?ref_id=%@",scanRegisterUrl,[User defalutManager].id]];
    
   
    //  设置QQAppId、appSecret，分享url
    [UMSocialQQHandler setQQWithAppId:@"1105491978" appKey:@"4vcul0EYJddeh32a" url:[NSString stringWithFormat:@"%@?ref_id=%@",scanRegisterUrl, [User defalutManager].id]];
    
    UIImage * shareImage = _myQrcodeVC.myErcodeImageView.image;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMSocialAppKey                                      shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatSession, nil] delegate:nil];
 
}



@end

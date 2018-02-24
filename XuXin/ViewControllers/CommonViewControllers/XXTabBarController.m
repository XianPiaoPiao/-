//
//  XXTabBarController.m
//  XuXin
//
//  Created by xuxin on 16/8/10.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "XXTabBarController.h"
#import "XXUiNavigationController.h"
#import "QueueViewController.h"
#import "HDMainViewController.h"
#import "MyTableViewController.h"
#import "AllStoreAndGoodsBaseController.h"
#import "HDCovertViewController.h"
#import "HDConvertController.h"

@interface XXTabBarController ()

@end

@implementation XXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTabBar];
}
-(void)creatTabBar{

    HDMainViewController * mainVC =[[HDMainViewController alloc] init];
     XXUiNavigationController * nav = [[XXUiNavigationController alloc] initWithRootViewController:mainVC];
    mainVC.title = @"首页";

    [mainVC.tabBarItem setImage:[[UIImage imageNamed:@"home_page_one@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [mainVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"home_page@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];;

    
    QueueViewController * queVC =[[QueueViewController alloc] init];
    XXUiNavigationController * nav2 = [[XXUiNavigationController alloc] initWithRootViewController:queVC];
    [queVC.tabBarItem setImage:[[UIImage imageNamed:@"pdui@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [queVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"paidui@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    queVC.title = @"排队";
    
    AllStoreAndGoodsBaseController * marketVC = [[AllStoreAndGoodsBaseController alloc] init];
    
    XXUiNavigationController * nav3 = [[XXUiNavigationController alloc] initWithRootViewController:marketVC];
    [marketVC.tabBarItem setImage:[UIImage imageNamed:@"business@3x.png"]];
    [marketVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"business2@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    marketVC.title = @"逛一逛";
    
    UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * myVC = [storybord instantiateViewControllerWithIdentifier:@"MyTableViewController" ];
    
    XXUiNavigationController * nav4 = [[XXUiNavigationController alloc] initWithRootViewController:myVC];
    [myVC.tabBarItem setImage:[[UIImage imageNamed:@"wode_2@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
  
    [myVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"wode@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [myVC.tabBarItem setImageInsets:UIEdgeInsetsMake(-6, 0, 6, 0)];
    
    myVC.title =  @"我的"; 
    
    HDCovertViewController * coverVC = [[HDCovertViewController alloc] init];
    XXUiNavigationController * nav5 =[[XXUiNavigationController alloc] initWithRootViewController:coverVC];
    [coverVC.tabBarItem setImage:[[UIImage imageNamed:@"dh@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [coverVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"duihuan@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    coverVC.title = @"兑换";
    
    //添加到分栏控制器上
    self.viewControllers = @[nav,nav3,nav4,nav5,nav2];
  //设置字体大小和颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName:[UIColor colorWithHexString:MainColor],NSFontAttributeName:[UIFont systemFontOfSize:10]                                             } forState:UIControlStateSelected];
       
}


@end

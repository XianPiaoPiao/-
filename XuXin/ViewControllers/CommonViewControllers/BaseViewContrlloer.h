//
//  BaseViewContrlloer.h
//  XuXin
//
//  Created by xuxin on 16/8/10.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ _Nullable Success)(id responseObject);     // 成功Block
typedef void (^ _Nullable Failure)(NSError *error);

@class EaseLoadingView;

// 失败Blcok

@interface BaseViewContrlloer : UIViewController
//状态栏
@property (nonatomic, assign)NSInteger StatusBarHeight;
@property (nonatomic, assign)NSInteger TabbarHeight;
//网络请求
@property (nonatomic ,strong)AFHTTPSessionManager * _Nullable httpManager;
@property (nonatomic ,strong)EaseLoadingView * loadingView;
//网络请求
//添加导航条的title
-(void)addNavgationTitle:(NSString *_Nullable)title;
//添加导航条上的按钮
-(void)addBarButtonItemWithTitle:(NSString *)title image:(UIImage *_Nullable)image target:(id)target action:(SEL _Nonnull )selector isLeft:(BOOL)isLeft;
//添加分类或者设置的按钮
-(void)addMainBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft;
//添加返回的按钮
-(void)addBackBarButtonItem;
-(void)backAction;
-(void)customNavigationItem;

-(void)showStaus:(NSString *)str;
//菊花
-(void)creatIndortor;
-(void)timerStop;
-(void)goLanding;

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

@end

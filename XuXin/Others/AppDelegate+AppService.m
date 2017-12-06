//
//  AppDelegate+AppService.m
//  XuXin
//
//  Created by xian on 2017/11/30.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "AppDelegate+AppService.h"
// 导入微信支付的SDK
#import "WXApi.h"
//分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "MyOrderBaseViewController.h"
#import "MessageViewController.h"
#import "UMessage.h"
@implementation AppDelegate (AppService)
- (void)configurationLaunchUserOption{
    
}

- (void)registerMap{
    
    //注册高德地图的key
    [AMapServices sharedServices].apiKey = @"d8701adfab2630065e1b43cd6ca2ff30";
}

- (void)registerMTA{
    //注册移动分析工具
    [[MTAConfig getInstance] setSmartReporting:YES];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
    
    [[MTAConfig getInstance] setDebugEnable:NO];
    [MTA startWithAppkey:@"IH3TGK57NL2X"]; //xxxx为注册App时得到的APPKEY
}

- (void)registerUMWithOptions:(NSDictionary *)launchOptions{
    //向微信注册
    [WXApi registerApp:__WXappID withDescription:@"demo 2.0"];
    //
    // 设置微博的AppKey、appSecret，分享url
    //  [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
    //                                            secret:@"appSecret"
    //                                       RedirectURL:@"url链接"];
    // 友盟分享初始化
    [UMSocialData setAppKey:UMSocialAppKey];
    
    //请求用户权限,注册远程推送通知
    //
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:@"581b094a45297d074000222d" launchOptions:launchOptions];
    
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
        
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    //UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    //[UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    
    //for log
    [UMessage setLogEnabled:YES];
}

- (void)uploadMessagAboutUser{
    
}

- (void)checkAppUpDataWithShowOption:(BOOL)showOption{
    
}
@end

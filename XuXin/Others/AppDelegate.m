//
//  AppDelegate.m
//  XuXin
//
//  Created by xuxin on 16/8/10.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "XXTabBarController.h"
#import "StartViewController.h"
//导入支付宝SDK
#import <AlipaySDK/AlipaySDK.h>
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

//移动分析
#import "MTA.h"
#import "MTAConfig.h"

#import "LJContactManager.h"


@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic,strong)AFHTTPSessionManager * httpManager;
@end

@implementation AppDelegate{
    
    CLLocationManager      *_locationmanager;

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    XXTabBarController * tabBarController = [[XXTabBarController alloc] init];
    NSString * isFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"];
    
    if ([isFirst isEqualToString:@"no"] == YES) {
        
        self.window.rootViewController=tabBarController;
        
    } else {
        
        StartViewController * start = [[StartViewController alloc] init];
        self.window.rootViewController = start;
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isFirst"];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self registerUMWithOptions:launchOptions];

    [self registerMap];
    
    [self registerMTA];
    
//    [self checkAppUpDataWithShowOption];
    
    
    [LJContactManager sharedInstance].contactChangeHanlder = ^(BOOL succeed, NSArray<LJPerson *> *newContacts) {
        
        NSLog(@"通讯录修改咯");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveContact" object:nil];
        
    };
    
    return YES;
 
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
 {
     
     NSLog(@"**********%@",error);
 // 如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
 //1.2.7版本开始自动捕获这个方法，log以application:didFailToRegisterForRemoteNotificationsWithError开头
 }
//注册远程推送成功的回调,返回device token
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
     [UMessage registerDeviceToken:deviceToken];

 
    //需要将DeviceToken发送给自定义的服务器
    //将NSData转换为字符串
     NSString *token=[NSString stringWithFormat:@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""]];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"UMToken"];
//    NSLog(@"USER-TOKEN:%@",token);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    //关闭友盟对话框

    [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    
   //角标个数
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"badge"] forKey:@"badge"];
    
    //后台进入
  
    if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageComing" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
        
    };

}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    [UMessage setAutoAlert:NO];

    NSDictionary * userInfo = notification.request.content.userInfo;
    
    //角标个数
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"badge"] forKey:@"badge"];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
    
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        
        //应用处于前台时的本地推送接受
        
    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    //角标个数
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"badge"] forKey:@"badge"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageComing" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        if([UIApplication sharedApplication].applicationState ==     UIApplicationStateBackground){
  
            
        }
    }else{
        //应用处于后台时的本地推送接受
        
    }
    
}


-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString * strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString * strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq *  temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage * msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject * obj = msg.mediaObject;
        
        NSString * strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString * strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString * strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString * strMsg = @"这是从微信启动的消息";
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString * strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString * strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
                
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinSucess" object:nil];
                
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }

}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
   
       NSLog(@"=======================%@",url);

    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //跳转到订单
            
            NSString * str = resultDic[@"resultStatus"];
            if ([str integerValue] == 9000) {
                
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySucess" object:nil];
            }
          
    
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    //微信支付
    if ([url.absoluteString rangeOfString:@"wxefd"].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
    }
    return YES;
}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    NSLog(@"=======================%@",url);
//    //微信支付
//    if ([url.absoluteString rangeOfString:@"weixin"].location != NSNotFound) {
//        return [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
//    }
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // 统计应用时长,结束时打点
    [MTA trackActiveEnd];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 统计应用时长,开始时打点
    [MTA trackActiveBegin];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
    
}

@end

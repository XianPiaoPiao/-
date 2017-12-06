//
//  AppDelegate+AppService.h
//  XuXin
//
//  Created by xian on 2017/11/30.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)
/**
 基本配置
 */
- (void)configurationLaunchUserOption;

/**
 地图注册
 */
- (void)registerMap;

/**
 腾讯用户行为分析注册
 */
- (void)registerMTA;

/**
 注册微信，友盟

 @param launchOptions 描述
 */
- (void)registerUMWithOptions:(NSDictionary *)launchOptions;

/**
 检查更新
 
 @param showOption 是否是最新
 */
- (void)checkAppUpDataWithShowOption:(BOOL)showOption;

/**
 上传用户设备信息
 */
- (void)uploadMessagAboutUser;

@end

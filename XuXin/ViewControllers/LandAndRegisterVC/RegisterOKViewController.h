//
//  ForgetSecretViewController.h
//  XuXin
//
//  Created by xuxin on 16/9/13.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"
//传值到登录界面

@interface RegisterOKViewController : BaseViewContrlloer
@property (nonatomic ,strong)NSString * phoneNumber;
@property (nonatomic ,strong)NSString * verifyCode;
@property (nonatomic ,copy)NSString * requestUrl;
@property (nonatomic , assign)NSInteger category;

@end

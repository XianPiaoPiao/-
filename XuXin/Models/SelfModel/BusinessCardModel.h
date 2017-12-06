//
//  BusinessCardModel.h
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessCardModel : NSObject
///姓名
@property (nonatomic, copy) NSString *username;
///邮箱
@property (nonatomic, copy) NSString *email;
///公司
@property (nonatomic, copy) NSString *company;
///职务
@property (nonatomic, copy) NSString *job;
///地址
@property (nonatomic, copy) NSString *addr;
///网址
@property (nonatomic, copy) NSString *web;
///手机号
@property (nonatomic, copy) NSString *mobile;
///名片ID
@property (nonatomic, copy) NSString *id;
///自己的ID
@property (nonatomic, copy) NSString *userCardId;
///个人介绍
@property (nonatomic, copy) NSString *intro;
///公司介绍
@property (nonatomic, copy) NSString *company_intro;
///二维码地址
@property (nonatomic, copy) NSString *qrcode;
@end

//
//  MyBankModel.h
//  XuXin
//
//  Created by xuxin on 16/10/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bank;
@interface MyBankModel : NSObject


@property (nonatomic, copy) NSString *iDCard;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString * bankCard;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) Bank *bank;

@property (nonatomic, copy) NSString *trueName;

@end
@interface Bank : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *logoPath;

@end


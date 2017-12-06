//
//  userListCouponModel.h
//  XuXin
//
//  Created by xuxin on 16/11/3.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userListCouponModel : NSObject


@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString * transfersTime;

@property (nonatomic, assign) NSInteger propWeiInit;

@property (nonatomic, assign) long long queueTime;

@property (nonatomic, assign) NSInteger exchangeTime;

@property (nonatomic, assign) NSInteger isQueue;

@property (nonatomic, assign) NSInteger queueEndTime;

@property (nonatomic, assign) NSInteger value;

@property (nonatomic, assign) NSInteger queueNum;

@property (nonatomic, copy) NSString *merchantName;

@property (nonatomic, copy) NSString *cradName;

@property (nonatomic, assign) NSInteger transfersFlag;

@property (nonatomic, assign) NSInteger propWei;

@property (nonatomic, copy) NSString * ownerName;


@end

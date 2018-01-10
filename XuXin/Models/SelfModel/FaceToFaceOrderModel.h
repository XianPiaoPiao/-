//
//  FaceToFaceOrderModel.h
//  XuXin
//
//  Created by xuxin on 16/12/4.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceToFaceOrderModel : NSObject<YYModel>

@property (nonatomic, assign) CGFloat orderPrice;

@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *storeAddress;

@property (nonatomic, copy) NSString *storePhone;

@property (nonatomic, copy) NSString *storeArea;

@property (nonatomic ,assign)NSInteger evaluationState;

@property (nonatomic, copy) NSString *orderSn;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, assign) NSInteger usedRedPacket;

@property (nonatomic, copy) NSString *storeLogo;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *payment;

@property (nonatomic, assign) long long orderCreateTime;
/*
 13    couponmoeny    优惠券抵扣金额（未使用的情况下为0，使用了就是金额大小）    是    [string]
 14    redpacketmoeny    红包抵扣金额（未使用的情况下为0，使用了就是金额大小）    是    [string]
 */

@property (nonatomic, assign) CGFloat couponmoeny;
@property (nonatomic, assign) CGFloat redpacketmoeny;

@end

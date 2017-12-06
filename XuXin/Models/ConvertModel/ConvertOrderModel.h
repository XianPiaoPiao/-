//
//  ConvertOrderModel.h
//  XuXin
//
//  Created by xuxin on 16/10/20.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertOrderModel : NSObject<YYModel>

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, assign) NSInteger totalIntegral;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *orderSn;

@property (nonatomic, assign) NSInteger totalCash;


@property (nonatomic, assign) NSInteger firstIntegralGoodsId;

@property (nonatomic, copy) NSString *firstIntegralGoodsLogo;

@property (nonatomic, copy) NSString *firstIntegralGoodsName;

@end

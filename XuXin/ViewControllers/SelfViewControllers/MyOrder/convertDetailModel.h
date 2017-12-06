//
//  convertDetailModel.h
//  XuXin
//
//  Created by xuxin on 16/10/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Address,OrderIntegralgoods,Goods;
@interface convertDetailModel : NSObject


@property (nonatomic, assign) CGFloat trans_fee;

@property (nonatomic, copy) NSString * orderSn;

@property (nonatomic, assign) NSInteger transport;

@property (nonatomic, assign) CGFloat totalCash;

@property (nonatomic, strong) Address *address;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *trade_no;

@property (nonatomic, assign) NSInteger totalIntegral;

@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, assign) NSInteger usedIntegral;

@property (nonatomic, assign) long long orderCreateTime;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray<OrderIntegralgoods *> *integralGoods;


@end
@interface Address : NSObject


@property (nonatomic, copy) NSString *mobile;


@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, copy) NSString *address;

@end

@interface OrderIntegralgoods : NSObject

@property (nonatomic, assign) NSInteger trans_fee;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) Goods * goods;

@property (nonatomic, copy) NSString *ig_goods_name;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, copy) NSString *photo;

@end

@interface Goods : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *gc;

@property (nonatomic, copy) NSString *ig_goods_tag;

@property (nonatomic, copy) NSString *ig_content;

@property (nonatomic, assign) NSInteger ig_click_count;

@property (nonatomic, assign) NSInteger ig_goods_count;

@property (nonatomic, assign) NSInteger ig_goods_price;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, assign) NSInteger goods_volume;

@property (nonatomic, assign) NSInteger goods_weight;

@property (nonatomic, assign) NSInteger ig_exchange_count;

@property (nonatomic, copy) NSString *ig_goods_sn;

@property (nonatomic, copy) NSString *ig_goods_name;

@property (nonatomic, assign) NSInteger ig_goods_integral;

@property (nonatomic, assign) CGFloat cash;

@property (nonatomic, assign) NSInteger ig_limit_count;

@end


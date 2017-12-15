//
//  ReadPayViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/17.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//


#import "BaseViewContrlloer.h"
@interface ReadPayViewController : BaseViewContrlloer

@property (nonatomic ,copy)NSString * requestUrl;

@property (nonatomic, copy)NSString * orderId;
//现金
@property (nonatomic, copy)NSString * price;
//积分
@property (nonatomic, copy)NSString *integral;
//总的金额
//@property (nonatomic, copy) NSString *totalCash;
@property (nonatomic, copy)NSString * order_sn;

@property (nonatomic ,assign)NSInteger payType;

@property (nonatomic ,assign)NSInteger sendType;

@property (nonatomic ,assign)NSInteger categoryType;

//快递费
@property (nonatomic ,copy)NSString * sendPriceValue;

@property (nonatomic ,assign) BOOL isUseRedWallet;

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy) NSString *redpacketId;

//购物车数量
@property (nonatomic ,assign)NSInteger shopCarNumber;

//订单类型
@property (nonatomic ,assign)NSInteger orderType;

//未支付返回
@property (nonatomic, copy) NSString *backString;
@end

//
//  qucklySendViewController.h
//  XuXin
//
//  Created by xuxin on 16/9/1.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface qucklySendViewController : BaseViewContrlloer
@property (nonatomic,copy)NSString * areaId;
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic,copy)NSString * price;
@property (nonatomic ,copy)NSString * orderSn;

@property (nonatomic ,copy)NSString * intergralPoint;

@property(nonatomic ,assign)NSInteger shopCarNumber;
//快递方式
@property (nonatomic ,assign)NSInteger sendType;

@property (nonatomic ,assign)NSInteger payType;

@property (nonatomic ,assign)NSInteger ordertType;

@end

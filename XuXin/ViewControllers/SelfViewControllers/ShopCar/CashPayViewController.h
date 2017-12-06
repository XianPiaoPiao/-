//
//  CashPayViewController.h
//  XuXin
//
//  Created by xian on 2017/9/25.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface CashPayViewController : BaseViewContrlloer

@property (nonatomic,copy)NSString * areaId;
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic, copy) NSString *cash;//现金
@property (nonatomic,copy)NSString * sendPrice;//快递费
@property (nonatomic ,copy)NSString * orderSn;

@property (nonatomic ,copy)NSString * intergralPoint;//现金+快递费

@property(nonatomic ,assign)NSInteger shopCarNumber;
//快递方式
@property (nonatomic ,assign)NSInteger sendType;

@property (nonatomic ,assign)NSInteger payType;

@property (nonatomic ,assign)NSInteger ordertType;


@end

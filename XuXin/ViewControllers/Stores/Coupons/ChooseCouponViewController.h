//
//  ChooseCouponViewController.h
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "BaseViewContrlloer.h"
#import "StoreCouponModel.h"

@interface ChooseCouponViewController : BaseViewContrlloer

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *orderType;

@property (nonatomic, assign) BOOL isCoupon;

@property (nonatomic, copy) void(^cancelBtnBlock)(BOOL);

@property (nonatomic, copy) void(^redpacketBlock)(StoreCouponModel *);

@property (nonatomic, copy) void(^couponBlock)(StoreCouponModel *);

- (void)requestData;

- (void)requestDataRedPacket;

@end

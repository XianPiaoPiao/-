//
//  StoreCouponModel.h
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreCouponModel : NSObject

///最后有效期
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;

///优惠券ID
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
///允许使用的订单金额
@property (nonatomic, copy) NSString *order_price;
@property (nonatomic, copy) NSString *picture;
///优惠券面值
@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) BOOL selected;

//receivestate领取状态，0未领取，1已领取，2已领完
@property (nonatomic, assign) NSInteger receivestate;

@end

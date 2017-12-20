//
//  MyOrderTableViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewController : UITableViewController

@property (nonatomic,copy)NSString * orderNumber;
@property (nonatomic,copy)NSString * orderId;

@property (nonatomic ,copy)NSString *  orderPrice;

@property (nonatomic ,assign)CGFloat  sendFee;

//订单类型
@property (nonatomic ,assign)NSInteger orderType;
///红包订单类型 1:面对面 0:线上线下 2:无优惠券的情况（没有使用）3:从未支付订单来
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isUseCoupon;
@property (nonatomic, assign)NSInteger redpacketmoeny;
@property (nonatomic, assign) NSInteger couponmoeny;
@end

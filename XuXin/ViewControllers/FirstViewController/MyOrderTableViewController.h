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
@property (nonatomic, copy) NSString *storecartId;

@property (nonatomic ,copy)NSString *  orderPrice;

@property (nonatomic ,assign)CGFloat  sendFee;

//订单类型
@property (nonatomic ,assign)NSInteger orderType;
@property (nonatomic, assign) NSInteger type;//红包订单类型 1：面对面
@property (nonatomic, copy) NSString *couponID;
@end

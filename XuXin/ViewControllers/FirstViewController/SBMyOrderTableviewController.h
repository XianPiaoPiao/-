//
//  SBMyOrderTableviewController.h
//  XuXin
//
//  Created by xuxin on 16/11/22.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMyOrderTableviewController : UITableViewController
@property (nonatomic,copy)NSString * orderNumber;
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic ,copy)NSString * orderPrice;
@property (nonatomic ,copy)NSString * storeName;

@property (nonatomic ,assign)CGFloat  sendFee;

//订单类型
@property (nonatomic ,assign)NSInteger orderType;

@end

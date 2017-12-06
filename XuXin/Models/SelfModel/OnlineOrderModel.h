//
//  OnlineOrderModel.h
//  XuXin
//
//  Created by xuxin on 17/3/10.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineOrderModel : NSObject

@property (nonatomic ,assign)NSInteger  count;
@property (nonatomic ,copy)NSString * goodsName;

@property (nonatomic ,copy)NSString * logo;

@property (nonatomic ,assign)CGFloat  price;

@property (nonatomic ,assign)NSInteger  status;

@property (nonatomic ,copy)NSString * orderId;

@property (nonatomic ,assign)NSInteger time;

@property (nonatomic ,copy)NSString * consignee;
@property (nonatomic ,copy)NSString * address;
@property (nonatomic ,copy)NSString * mobile;
@property (nonatomic ,copy)NSString * id;
@property (nonatomic ,copy)NSString * order_sn;

@property (nonatomic ,copy)NSString * consumptionCode;

@property (nonatomic ,copy)NSString * paymentMethod;
@property (nonatomic ,copy)NSString * storeName;
@property (nonatomic ,copy)NSString * storeLogo;
@property (nonatomic ,copy)NSString * storeId;
@property (nonatomic ,assign)CGFloat freight;
@property (nonatomic ,copy)NSString * goodsSpecifications;

@property (nonatomic ,assign)NSInteger usedRed;

@property (nonatomic ,assign)NSInteger usedRedPacket;

;

@end

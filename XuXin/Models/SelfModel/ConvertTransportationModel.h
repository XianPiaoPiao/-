//
//  ConvertTransportationModel.h
//  XuXin
//
//  Created by xuxin on 17/2/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertTransportationModel : NSObject
@property(nonatomic ,copy)NSString * context;

@property (nonatomic ,copy)NSString * ftime;

@property (nonatomic ,copy)NSString * time;

@property(nonatomic ,copy)NSString * com;

@property(nonatomic ,copy)NSString * nu;

@property(nonatomic ,copy)NSString * ischeck;

@property(nonatomic ,copy)NSString * condition;

@property (nonatomic ,assign)NSInteger state;

@property(nonatomic ,copy)NSString * message;

@property (nonatomic ,copy)NSString * goodsLog;
@end

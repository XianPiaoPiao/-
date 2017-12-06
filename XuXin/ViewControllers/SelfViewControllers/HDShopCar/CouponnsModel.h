//
//  CouponnsModel.h
//  XuXin
//
//  Created by xuxin on 16/10/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponnsModel : NSObject

@property (nonatomic, assign) NSInteger prop_wei;

@property (nonatomic, copy) NSString *card_name;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *is_used;

@property (nonatomic, assign) NSInteger prop_wei_init;

@property (nonatomic, assign) NSInteger is_queue;

@property (nonatomic, assign) NSInteger queue_num;

@property (nonatomic, assign) NSInteger value;

@property (nonatomic ,assign)BOOL isSelected;
@end

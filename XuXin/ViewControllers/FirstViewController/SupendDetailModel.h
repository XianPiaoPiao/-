//
//  SupendDetailModel.h
//  XuXin
//
//  Created by xuxin on 16/11/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupendDetailModel : NSObject

@property (nonatomic, assign) CGFloat log_amount;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *times;

@property (nonatomic, assign) long long addTime;

@property (nonatomic, copy) NSString *log_info;

@end

//
//  BalanceDetailModel.h
//  XuXin
//
//  Created by xuxin on 16/11/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceDetailModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * user_id;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) long long addTime;

@property (nonatomic, copy) NSString * describe;

@end

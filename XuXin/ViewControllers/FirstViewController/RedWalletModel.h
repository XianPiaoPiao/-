//
//  RedWalletModel.h
//  XuXin
//
//  Created by xuxin on 16/11/10.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedWalletModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *packet_name;

@property (nonatomic, copy) NSString *user;

@property (nonatomic, copy) NSString *is_send;

@property (nonatomic, assign) long long packet_start_time;

@property (nonatomic, assign) long long start_time;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger value;

@property (nonatomic, assign) long long addTime;

@property (nonatomic, assign) long long end_time;

@property (nonatomic, copy) NSString *is_close;

@property (nonatomic, assign) NSInteger is_userd;

@property (nonatomic, assign) long long packet_ent_time;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger ownerID;

@end

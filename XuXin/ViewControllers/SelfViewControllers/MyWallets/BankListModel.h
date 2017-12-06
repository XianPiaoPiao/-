//
//  BankListModel.h
//  XuXin
//
//  Created by xuxin on 16/10/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankListModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *logoPath;

@property (nonatomic, assign) long long addTime;

@property (nonatomic, copy) NSString *name;

@end

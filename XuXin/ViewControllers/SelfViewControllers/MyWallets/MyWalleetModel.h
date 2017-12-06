//
//  MyWalleetModel.h
//  XuXin
//
//  Created by xuxin on 16/10/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWalleetModel : NSObject

@property (nonatomic, assign) CGFloat availableBalance;

@property (nonatomic, assign) CGFloat shopcoin;
//冻结的
@property (nonatomic, assign) CGFloat freezeBlance;

@property (nonatomic, assign) NSInteger bankCardCount;

@property (nonatomic, assign) NSInteger integral;

@end

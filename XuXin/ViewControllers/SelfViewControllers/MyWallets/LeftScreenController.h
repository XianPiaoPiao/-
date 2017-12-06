//
//  LeftScreenController.h
//  嗨兑商家端
//
//  Created by xuxin on 17/6/5.
//  Copyright © 2017年 www.hidui.com. All rights reserved.
//

#import "BaseViewContrlloer.h"

typedef void (^myBankBlock)(NSInteger  income,NSString *buyerUserName,NSString *orderSn ,NSInteger  beginTime,NSInteger endTime );

@interface LeftScreenController : BaseViewContrlloer

@property (nonatomic ,copy)myBankBlock  block;

@end

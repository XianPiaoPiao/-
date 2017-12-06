//
//  HDRegisterController.h
//  XuXin
//
//  Created by xuxin on 16/12/13.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface HDRegisterController : BaseViewContrlloer

typedef void (^ReturnTextBlock)(NSString * showText);

@property (nonatomic ,copy)ReturnTextBlock block;
@property (nonatomic ,copy)NSString * userId;
@property (nonatomic ,assign)NSInteger pushType;
@end

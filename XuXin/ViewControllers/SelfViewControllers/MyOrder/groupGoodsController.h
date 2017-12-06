//
//  groupGoodsController.h
//  XuXin
//
//  Created by xuxin on 17/3/9.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface groupGoodsController : BaseViewContrlloer
@property (nonatomic ,strong)NSMutableArray * ImageArray;
@property (nonatomic ,copy)NSString * storeCartId;
@property (nonatomic ,copy)NSString * goodsCartId;
@property (nonatomic ,copy)NSString * amountMoney;
@property (nonatomic ,copy)NSString * userMobile;
@property (nonatomic ,assign)NSInteger  goodsCount;

@end

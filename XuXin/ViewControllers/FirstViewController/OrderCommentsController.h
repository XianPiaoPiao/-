//
//  OrderCommentsController.h
//  XuXin
//
//  Created by xuxin on 17/3/6.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface OrderCommentsController : BaseViewContrlloer
@property (nonatomic ,copy)NSString * storeId;
@property (nonatomic ,copy)NSString * storeLogo;
@property (nonatomic ,copy)NSString * storeName;
@property (nonatomic ,assign)NSInteger orderType;
@property (nonatomic ,copy)NSString * goodsId;

@property (nonatomic ,strong)NSMutableArray * goodsArray;

@end

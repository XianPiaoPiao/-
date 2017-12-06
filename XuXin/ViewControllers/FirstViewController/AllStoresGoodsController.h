//
//  AllStoresGoodsController.h
//  hidui
//
//  Created by xuxin on 17/1/17.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface AllStoresGoodsController : BaseViewContrlloer
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,assign)NSInteger moreGoodsType;

@property (nonatomic ,copy)NSString * storeId;

@property (nonatomic ,copy)NSString * goodsId;
@property (nonatomic ,copy)NSString * requestUrl;

@end

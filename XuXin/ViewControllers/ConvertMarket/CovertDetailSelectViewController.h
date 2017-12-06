//
//  CovertDetailSelectViewController.h
//  XuXin
//
//  Created by xuxin on 16/10/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
typedef void (^orderByBlock)(NSString * orderBy);
typedef void (^priceValueBlock)(NSString * lowPrice,NSString * highPrice);

@interface CovertDetailSelectViewController : BaseViewContrlloer
@property (nonatomic ,copy)orderByBlock block;
@property (nonatomic ,copy)priceValueBlock priceBlock;
@end


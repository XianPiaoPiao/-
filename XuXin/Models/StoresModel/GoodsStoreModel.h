//
//  GoodsStoreModel.h
//  XuXin
//
//  Created by xuxin on 17/3/9.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsStoreModel : NSObject

@property (nonatomic ,assign)CGFloat  distance;

@property (nonatomic ,copy)NSString * store_name;

@property (nonatomic ,copy)NSString * store_address;

@property (nonnull ,copy)NSString * img;

@property (nonatomic ,assign)NSInteger  store_id;

@property (nonatomic ,copy)NSString * store_telephone;


@end

//
//  MoreShopModel.h
//  XuXin
//
//  Created by xuxin on 16/9/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreShopModel : NSObject

@property (nonatomic, copy) NSString *store_name;

@property (nonatomic, copy) NSString *store_address;

@property (nonatomic, copy) NSString *area_name;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger area_id;
@property (nonatomic ,assign)NSInteger percapita;

@end

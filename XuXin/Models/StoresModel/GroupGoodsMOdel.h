//
//  GroupGoodsMOdel.h
//  hidui
//
//  Created by xuxin on 17/1/17.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupGoodsMOdel : NSObject
@property (nonatomic ,copy)NSString * goods_name;
@property (nonatomic ,assign)CGFloat  goods_price;
@property (nonatomic ,copy)NSString * goods_salenum;

@property (nonatomic ,assign)CGFloat * store_price;

@property (nonatomic ,copy)NSString * img;

@property (nonatomic ,copy)NSString * id;
@property (nonatomic ,copy)NSString * goods_id;

@property (nonatomic ,assign)NSInteger * goods_choice_type;

@property (nonatomic ,assign)NSInteger goods_click;

@property (nonatomic ,assign)NSInteger evaluates_count;

@property (nonatomic ,assign)NSInteger count;

@property (nonatomic ,assign)BOOL isSelect;
@end

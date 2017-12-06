//
//  ONLINEgoodsModel.h
//  XuXin
//
//  Created by xuxin on 17/3/14.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONLINEgoodsModel : NSObject
@property (nonatomic ,copy)NSString * goodsName;
@property (nonatomic ,copy)NSString * goodsname;

@property (nonatomic ,copy)NSString * goods_name;
@property (nonatomic ,copy)NSString * img;
@property (nonatomic ,assign)CGFloat  goods_price;
@property (nonatomic ,assign)CGFloat  store_price;

@property (nonatomic ,assign)NSInteger goods_salenum;
@property (nonatomic ,copy)NSString * id;

@property (nonatomic ,copy)NSString * logo;
@property (nonatomic ,assign)CGFloat  goodsPrice;
@property (nonatomic ,assign)NSInteger count;
@property (nonatomic ,copy)NSString * goods_id;

@property (nonatomic ,copy)NSString * goodsSpecifications;

@end

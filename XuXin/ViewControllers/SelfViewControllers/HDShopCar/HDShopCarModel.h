//
//  HDShopCarModel.h
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDShopCarModel : NSObject


@property (nonatomic, assign) NSInteger  p_id;

@property (nonatomic, assign) CGFloat  ig_goods_integral;

@property (nonatomic, strong) NSString  * ig_goods_name;

@property (nonatomic, strong) NSString  *logo;

@property (nonatomic, assign) NSInteger p_stock;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic ,assign)BOOL is_default;

@property (nonatomic ,copy)NSString * goodsCartId;
@property (nonatomic ,copy)NSString * goodsLogo;
@property (nonatomic ,assign)NSInteger goodsCount;
@property (nonatomic ,copy)NSString * goodsName;
@property (nonatomic ,copy)NSString * goodsSpecifications;

@property (nonatomic ,assign)NSInteger  goodsId;

@property (nonatomic ,assign)CGFloat  price;

@property (nonatomic, assign) CGFloat cash;

//商品是否被选中
@property (nonatomic, assign) BOOL   isSelect;

@property (nonatomic, copy) NSString *vendor;

@end

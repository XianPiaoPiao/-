//
//  intergralGoodsModel.h
//  XuXin
//
//  Created by xuxin on 16/10/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Integrals;
@interface intergralGoodsModel : NSObject

@property (nonatomic, assign) NSInteger trans_fee;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) Integrals *goods;

@property (nonatomic, copy) NSString *ig_goods_name;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, copy) NSString *photo;

@end
@interface Integrals : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *gc;

@property (nonatomic, copy) NSString *ig_goods_tag;

@property (nonatomic, copy) NSString *ig_content;

@property (nonatomic, assign) NSInteger ig_click_count;

@property (nonatomic, assign) NSInteger ig_goods_count;

@property (nonatomic, assign) NSInteger ig_goods_price;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, assign) NSInteger goods_volume;

@property (nonatomic, assign) NSInteger goods_weight;

@property (nonatomic, assign) NSInteger ig_exchange_count;

@property (nonatomic, copy) NSString *ig_goods_sn;

@property (nonatomic, copy) NSString *ig_goods_name;

@property (nonatomic, assign) NSInteger ig_goods_integral;

@property (nonatomic, assign) NSInteger ig_limit_count;

@property (nonatomic, assign) CGFloat cash;

@end


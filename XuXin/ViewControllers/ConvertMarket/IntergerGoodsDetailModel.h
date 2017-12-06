//
//  IntergerGoodsDetailModel.h
//  XuXin
//
//  Created by xuxin on 16/10/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Recommendgoods,Exchangerecord;
@interface IntergerGoodsDetailModel : NSObject

@property (nonatomic, copy) NSString *ig_goods_tag;

@property (nonatomic, assign) NSInteger ig_exchange_count;

@property (nonatomic, assign) NSInteger ig_click_count;

@property (nonatomic, assign) NSInteger integralGoodsClassId;

@property (nonatomic, assign) NSInteger ig_goods_integral;

@property (nonatomic, copy) NSString *ig_goods_name;

@property (nonatomic, assign) CGFloat goods_volume;

@property (nonatomic, assign) NSInteger ig_limit_count;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSArray *dimension;

@property (nonatomic, strong) NSArray *evaluate;

@property (nonatomic, assign) NSInteger favoriteId;

@property (nonatomic, copy) NSString *ig_goods_sn;

@property (nonatomic, strong) NSArray<Recommendgoods *> *recommendGoods;

@property (nonatomic, assign) NSInteger ig_goods_count;

@property (nonatomic, copy) NSString *ig_content;

@property (nonatomic, assign) CGFloat goods_weight;

@property (nonatomic, assign) CGFloat ig_goods_price;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, assign) NSInteger favoriteStatus;

@property (nonatomic, strong) NSArray<Exchangerecord *> *exchangeRecord;

@property (nonatomic ,assign)NSInteger count;

@property (nonatomic, assign) CGFloat cash;

@property (nonatomic, copy) NSString *vendor;

@end

@interface Recommendgoods : NSObject

@property (nonatomic, copy) NSString *ig_goods_tag;

@property (nonatomic, assign) NSInteger ig_exchange_count;

@property (nonatomic, assign) NSInteger ig_click_count;

@property (nonatomic, assign) NSInteger integralGoodsClassId;

@property (nonatomic, assign) NSInteger ig_goods_integral;

@property (nonatomic, copy) NSString *ig_goods_name;

@property (nonatomic, assign) NSInteger goods_volume;

@property (nonatomic, assign) NSInteger ig_limit_count;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSArray *dimension;

@property (nonatomic, strong) NSArray *evaluate;

@property (nonatomic, assign) NSInteger favoriteId;

@property (nonatomic, copy) NSString *ig_goods_sn;

@property (nonatomic, strong) NSArray *recommendGoods;

@property (nonatomic, assign) NSInteger ig_goods_count;

@property (nonatomic, copy) NSString *ig_content;

@property (nonatomic, assign) NSInteger goods_weight;

@property (nonatomic, assign) NSInteger ig_goods_price;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, assign) BOOL favoriteStatus;

@property (nonatomic, strong) NSArray *exchangeRecord;

@property (nonatomic, assign) CGFloat cash;

@end

@interface Exchangerecord : NSObject

@property (nonatomic, copy) NSString *goodsLogo;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, copy) NSString *integralGoods_name;

@property (nonatomic, copy) NSString *userPhoto;

@end


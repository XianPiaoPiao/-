//
//  shopListDetailModel.h
//  XuXin
//
//  Created by xuxin on 16/9/18.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopListDetailModel : NSObject<YYModel>

@property (nonatomic, strong) NSArray *slides;

@property (nonatomic, copy) NSString *store_banner;

@property (nonatomic, assign) NSInteger store_lng;

@property (nonatomic, assign) NSInteger goods_recommend_count;

@property (nonatomic, copy) NSString *store_telephone;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, strong) NSArray *goods_list;

@property (nonatomic, copy) NSString *store_info;

@property (nonatomic, copy) NSString *store_class;

@property (nonatomic, assign) NSInteger store_lat;

@property (nonatomic, copy) NSString *store_name;

@property (nonatomic, copy) NSString *store_ower;

@property (nonatomic, copy) NSString *store_qq;

@property (nonatomic, assign) NSInteger idName;

@property (nonatomic, assign) NSInteger store_status;

@property (nonatomic, copy) NSString *store_address;

@property (nonatomic, assign) NSInteger store_evaluate;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, assign) NSInteger goods_count;

@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, assign) NSInteger goods_new_count;

@property (nonatomic, copy) NSString *area_name;

@property (nonatomic, assign) NSInteger favorite_count;
@property (nonatomic ,assign)NSInteger percapita;

@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, assign) NSInteger  goods_salenum;
@property (nonatomic, assign) CGFloat  goods_price;
@property (nonatomic, copy) NSString * id;

@end

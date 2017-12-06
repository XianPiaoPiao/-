//
//  ConvertGoodsCellModel.h
//  XuXin
//
//  Created by xuxin on 16/9/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ConvertGoodsCellModel : NSObject<YYModel>



@property (nonatomic, copy) NSString *logo;
///原价
@property (nonatomic, assign) CGFloat ig_goods_price;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger ig_exchange_count;

@property (nonatomic, copy) NSString *ig_goods_name;

@property (nonatomic, assign) NSInteger ig_click_count;
///积分
@property (nonatomic, assign) CGFloat ig_goods_integral;
///现金
@property (nonatomic, assign) CGFloat cash;

@property (nonatomic, copy) NSString *ig_goods_tag;

@property (nonatomic ,assign)NSInteger count;
@property (nonatomic ,assign)NSInteger usedRedPacket;

@end

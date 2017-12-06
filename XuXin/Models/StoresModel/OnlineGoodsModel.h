//
//  OnlineGoodsModel.h
//  hidui
//
//  Created by xuxin on 17/1/17.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineGoodsModel : NSObject
@property (nonatomic ,copy)NSString * goods_name;
@property (nonatomic ,assign)CGFloat goods_price;
@property (nonatomic ,copy)NSString * goods_salenum;

@property (nonatomic ,copy)NSString * img;
@property (nonatomic ,copy)NSString * id;
@end

//
//  recmondShopModel.m
//  XuXin
//
//  Created by xuxin on 16/9/7.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "recmondShopModel.h"

@implementation recmondShopModel
+(NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"idName":@"id"};
}
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
     
    }
    return self;
}
@end

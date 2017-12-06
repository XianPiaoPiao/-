//
//  MapLocationViewController.h
//  XuXin
//
//  Created by xuxin on 16/9/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
#import "recmondShopModel.h"
//商家地址
typedef void (^locationBlock)(NSString * address);

@interface MapLocationViewController : BaseViewContrlloer

@property (nonatomic,strong)recmondShopModel * model;

@property (nonatomic,copy)locationBlock block;

@property (nonatomic ,strong)CLLocation * userLocation;
@end

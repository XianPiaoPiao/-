//
//  CitySearchViewController.h
//  XuXin
//
//  Created by xuxin on 16/9/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
typedef void (^cityBlock)(NSString * cityName);
@interface CitySearchViewController : BaseViewContrlloer<NSCoding>

@property (nonatomic ,copy)cityBlock block;


@end

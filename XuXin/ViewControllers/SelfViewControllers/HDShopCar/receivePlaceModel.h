//
//  receivePlaceModel.h
//  XuXin
//
//  Created by xuxin on 16/10/14.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface receivePlaceModel : NSObject
@property (nonatomic ,copy)NSString * area;
@property (nonatomic ,copy)NSString * area_info;

@property (nonatomic ,assign)long id;
@property (nonatomic ,assign)BOOL is_default;
@property (nonatomic ,assign)long area_id;
@property (nonatomic ,copy)NSString * mobile;
@property (nonatomic ,copy)NSString * trueName;
@property (nonatomic ,copy)NSString * zip;
@property (nonatomic ,assign) BOOL isSelected;
@end

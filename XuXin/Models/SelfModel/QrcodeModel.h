//
//  QrcodeModel.h
//  XuXin
//
//  Created by xuxin on 17/4/10.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QrcodeModel : NSObject
@property (nonatomic ,copy)NSString * consumptionCode;
@property (nonatomic ,copy)NSString * codeGoodsName;

@property (nonatomic ,copy)NSString * codeId;

@property (nonatomic ,assign)NSInteger is_used;
@property (nonatomic ,assign)BOOL isSelected;
@end

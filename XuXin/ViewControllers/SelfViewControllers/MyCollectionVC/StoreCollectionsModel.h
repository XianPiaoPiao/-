//
//  StoreCollectionsModel.h
//  XuXin
//
//  Created by xuxin on 16/10/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreCollectionsModel : NSObject

@property (nonatomic, copy) NSString *img;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *store_name;

@property (nonatomic, copy) NSString *store_address;

@property (nonatomic, assign) NSInteger store_id;

@property (nonatomic ,assign)BOOL isSeleceted;
@end

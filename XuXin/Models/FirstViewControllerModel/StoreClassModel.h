//
//  StoreClassModel.h
//  XuXin
//
//  Created by xuxin on 16/11/14.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreClassModel : NSObject

@property (nonatomic, strong) NSArray *childs;

@property (nonatomic, assign) NSInteger sequence;

@property (nonatomic, copy) NSString *className;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger storeNum;

@property (nonatomic, copy) NSString *storeLogo;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *store_Classimg;

@end

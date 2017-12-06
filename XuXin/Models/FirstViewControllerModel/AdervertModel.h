//
//  AdervertModel.h
//  XuXin
//
//  Created by xuxin on 16/11/11.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdervertModel : NSObject
@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *ad_ap;

@property (nonatomic, assign) NSInteger ad_acc_id;

@property (nonatomic, copy) NSString *img;
@property (nonatomic ,copy)NSString * name;

@property (nonatomic, copy) NSString *ad_url;
@end

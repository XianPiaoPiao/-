//
//  UserCommentsModel.h
//  XuXin
//
//  Created by xuxin on 17/3/9.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCommentsModel : NSObject
@property (nonatomic ,copy)NSString * userPhoto;

@property (nonatomic ,copy)NSString * addTime;

@property (nonatomic ,copy)NSString * buyTime;

@property (nonatomic ,copy)NSString * userName;

@property (nonatomic ,copy)NSString * id;

@property (nonatomic ,copy)NSString * evaluate_info;

@property (nonatomic ,copy)NSString * appraiser;
@property (nonatomic ,copy)NSString * content;
@property (nonatomic ,assign)NSInteger deliverySpeed;
@property (nonatomic ,assign)NSInteger service;
@property (nonatomic ,assign)NSInteger describe;

@property (nonatomic ,copy)NSString *  evaluationTime;


@end

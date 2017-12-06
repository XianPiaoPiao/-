//
//  EdictPlaceViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"
#import "receivePlaceModel.h"
typedef void (^receiveModelBlock)(receivePlaceModel * model);

@interface EdictPlaceViewController : BaseViewContrlloer

@property (weak, nonatomic) IBOutlet UIView *SelectPlaceView;
@property (nonatomic,copy)NSString * requestUrl;
@property (nonatomic ,assign) NSInteger placeType;
@property (nonatomic ,copy) receiveModelBlock block;
@property(nonatomic,strong)receivePlaceModel * model;
@end

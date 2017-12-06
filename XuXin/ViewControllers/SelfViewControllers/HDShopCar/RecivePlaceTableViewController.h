//
//  RecivePlaceTableViewController.h
//  XuXin
//
//  Created by xuxin on 16/10/14.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "receivePlaceModel.h"
#import "BaseViewContrlloer.h"

typedef void (^PlaceBlock)(receivePlaceModel * placeModel);

@interface RecivePlaceTableViewController : BaseViewContrlloer

@property (nonatomic ,copy)PlaceBlock block;
@end

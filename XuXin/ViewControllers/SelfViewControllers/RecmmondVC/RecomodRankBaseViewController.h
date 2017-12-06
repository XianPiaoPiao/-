//
//  RecomodRankBaseViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"
@interface RecomodRankBaseViewController : BaseViewContrlloer

@property (nonatomic ,copy)NSString * requestUrl;

@property (nonatomic ,assign)NSInteger recommondType;
@end

//
//  MyOrderDetailViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"
@interface MyOrderDetailViewController : BaseViewContrlloer
@property (nonatomic ,copy)NSString * requestUrl;

@property (nonatomic ,copy)NSString * goodID;

@property (nonatomic ,copy) NSString *backString;
@end

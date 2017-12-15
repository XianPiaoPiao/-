//
//  CouponsViewController.h
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"
@interface CouponsViewController : BaseViewContrlloer

@property (nonatomic, strong) NSString *storeID;
@property (nonatomic, copy) void(^finishBtnBlock)(BOOL);
@end

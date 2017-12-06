//
//  SearchShopViewController.h
//  XuXin
//
//  Created by xuxin on 16/9/11.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"
typedef void (^shopClassBlock)(NSString * shopName);
@interface SearchShopViewController : BaseViewContrlloer
@property (nonatomic ,copy)shopClassBlock block;
@end

//
//  NewsViewController.h
//  XuXin
//
//  Created by xian on 2017/9/29.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"

@interface NewsViewController : BaseViewContrlloer

///1:自己 ; 0:好友
@property (nonatomic, assign) NSInteger type;
///类型:0 产品 1 新闻 2 招商
@property (nonatomic, assign) NSInteger newsType;

@property (nonatomic, copy) NSString *ucId;

@property (nonatomic, copy) NSString *navTitle;

@end

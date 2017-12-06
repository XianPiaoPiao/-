//
//  CardDetailViewController.h
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
@class BusinessCardModel;

@interface CardDetailViewController : BaseViewContrlloer

///1:自己；0:好友
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *userCardId;

@property (nonatomic, assign) BOOL isFriend;


@end

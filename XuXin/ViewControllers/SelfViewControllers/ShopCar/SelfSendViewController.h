//
//  SelfSendViewController.h
//  XuXin
//
//  Created by xuxin on 16/9/1.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
typedef void (^selfPlace)(NSString * placeID,NSString * adressName);

@interface SelfSendViewController : BaseViewContrlloer
@property(nonatomic ,copy)selfPlace block;
@end

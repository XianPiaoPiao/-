//
//  BackOnlineOrderController.h
//  XuXin
//
//  Created by xuxin on 17/4/10.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface BackOnlineOrderController : BaseViewContrlloer
@property (weak, nonatomic) IBOutlet UILabel *backMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;
@property (nonatomic ,copy)NSString * orderId;
@property (nonatomic ,assign)CGFloat  backPriceValue;

//退货还是退款
@property (nonatomic ,assign)NSInteger orderType;
@end

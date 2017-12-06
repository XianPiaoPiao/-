//
//  BackGoodsTransportController.h
//  XuXin
//
//  Created by xuxin on 17/4/10.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface BackGoodsTransportController : BaseViewContrlloer
@property (weak, nonatomic) IBOutlet UITextField *transportNumberField;

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (nonatomic ,copy)NSString * orderId;
@end

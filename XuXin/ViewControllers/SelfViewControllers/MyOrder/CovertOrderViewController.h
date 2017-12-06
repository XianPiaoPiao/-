//
//  CovertOrderViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface CovertOrderViewController : BaseViewContrlloer
@property (weak, nonatomic) IBOutlet UILabel *orderStutasLabel;
@property (weak, nonatomic) IBOutlet UILabel *adeessLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *addTimeOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLbael;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *turePayLabel;
@property (nonatomic ,copy)NSString * idName;
@property (weak, nonatomic) IBOutlet UILabel *redwalletLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewTop;
@end

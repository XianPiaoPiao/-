//
//  MyRedWalletTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/10/22.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedWalletModel.h"
@interface MyRedWalletTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statementLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (nonatomic ,strong)RedWalletModel * model;
@end

//
//  MyWalletTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *PayforLabel;
@property (weak, nonatomic) IBOutlet UILabel *BalanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *RechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *DetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *explainBtn;
@property (weak, nonatomic) IBOutlet UIImageView *HDImageView;

@end

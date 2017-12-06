//
//  MyWalletTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyWalletTableViewCell.h"

@implementation MyWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.DetailBtn.layer.cornerRadius = 16;
    self.RechargeBtn.layer.cornerRadius = 16 ;
    self.DetailBtn.backgroundColor = [UIColor colorWithHexString:@"#81a6c6"];
    self.RechargeBtn.backgroundColor = [UIColor colorWithHexString:@"#81a6c6"];
    self.BalanceLabel.textColor = [UIColor colorWithHexString:@"#81a6c6"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

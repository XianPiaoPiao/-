//
//  MoreShopTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/16.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MoreShopTableViewCell.h"

@implementation MoreShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopHeaderImageView.layer.masksToBounds = YES;
    self.shopHeaderImageView.layer.cornerRadius = 6;
}
-(void)setModel:(MoreShopModel *)model{
    _model = model;
    self.shopNameLabel.text = model.store_name;
    self.placeLabel.text = model.store_address;
    [self.shopHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    self.moneyLabel.text = [NSString stringWithFormat:@"人均:￥%ld",model.percapita];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

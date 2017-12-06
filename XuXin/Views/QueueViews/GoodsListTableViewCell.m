//
//  GoodsListTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/10/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "GoodsListTableViewCell.h"

@implementation GoodsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImageView.layer.masksToBounds = YES;
    self.goodsImageView.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

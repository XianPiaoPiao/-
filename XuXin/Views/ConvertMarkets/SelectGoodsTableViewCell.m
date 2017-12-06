//
//  SelectGoodsTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/23.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SelectGoodsTableViewCell.h"

@implementation SelectGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsCountView.layer.cornerRadius = 4;
    self.goodsCountView.layer.borderWidth = 1;
    self.goodsCountView.layer.borderColor = [UIColor colorWithHexString:BackColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

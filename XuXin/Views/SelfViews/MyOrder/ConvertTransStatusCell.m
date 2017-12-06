//
//  ConvertTransStatusCell.m
//  XuXin
//
//  Created by xuxin on 17/2/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ConvertTransStatusCell.h"

@implementation ConvertTransStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

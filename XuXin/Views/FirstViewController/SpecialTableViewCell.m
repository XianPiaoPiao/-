//
//  SpecialTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/15.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SpecialTableViewCell.h"

@implementation SpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

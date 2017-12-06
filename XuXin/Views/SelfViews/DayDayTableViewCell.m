//
//  DayDayTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "DayDayTableViewCell.h"

@implementation DayDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.nameLabel.layer.masksToBounds = YES;
    self.nameLabel.layer.cornerRadius = 15;
    
    self.headerBtn.layer.masksToBounds = YES;
    self.headerBtn.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

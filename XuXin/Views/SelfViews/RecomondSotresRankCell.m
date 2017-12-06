//
//  RecomondSotresRankCell.m
//  XuXin
//
//  Created by xuxin on 16/12/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecomondSotresRankCell.h"

@implementation RecomondSotresRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rankLabel.layer.masksToBounds = YES;
    self.rankLabel.layer.cornerRadius = 15;
    self.headerBtn.layer.masksToBounds = YES;
    self.headerBtn.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

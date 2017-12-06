//
//  ReconmondFriendTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/28.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ReconmondFriendTableViewCell.h"

@implementation ReconmondFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

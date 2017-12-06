//
//  goodsCell.m
//  XuXin
//
//  Created by xuxin on 17/3/9.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "goodsCell.h"

@implementation goodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImgeVIew.layer.masksToBounds = YES;
    self.goodsImgeVIew.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

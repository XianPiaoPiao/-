//
//  AllshopThreeListCell.m
//  XuXin
//
//  Created by xuxin on 16/9/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "AllshopThreeListCell.h"

@implementation AllshopThreeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(Result *)model{
    
    _model = model;
    _nameLabel.text = model.areaName ;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

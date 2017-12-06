//
//  RecivePlaceTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/10/14.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecivePlaceTableViewCell.h"

@implementation RecivePlaceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.setAdressBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
     [self.eidcBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
     [self.deleteBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
}
-(void)setModel:(receivePlaceModel *)model{
    _model = model;
    _NameLabel.text = model.trueName;
    _phoneNumberLabel.text = model.mobile;
    _receivePlaceLabel.text = model.area;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

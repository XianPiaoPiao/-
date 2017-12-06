//
//  CovertRecordTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/23.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CovertRecordTableViewCell.h"

@implementation CovertRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 21;
}
-(void)setRecordModel:(Exchangerecord *)recordModel{
    _recordModel = recordModel;
    _goodsLabel.text = recordModel.integralGoods_name;
    _pointNumberLabel.text =[NSString stringWithFormat:@"%ld",recordModel.integral];
      _userNmaeLabel.text = recordModel.userName;
    _CovertDateLabel.text = recordModel.addTime;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:recordModel.userPhoto] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];   //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

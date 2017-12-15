//
//  ChooseCouponTableViewCell.m
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "ChooseCouponTableViewCell.h"
#import "StoreCouponModel.h"

@implementation ChooseCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.chooseButton setImage:[UIImage imageNamed:@"icon_money_check_off.png"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"red_envelopes"] forState:UIControlStateSelected];
}

- (void)setModel:(StoreCouponModel *)model{
    _model = model;
    self.valueLabel.text = [NSString stringWithFormat:@"%@",model.name] ;
    _chooseButton.selected = model.selected;
}

- (IBAction)clickChooseButton:(id)sender {
    self.chooseButton.selected = !self.chooseButton.selected;
    _model.selected = _chooseButton.selected;
    if (self.selectedCheckBtnBlock) {
        self.selectedCheckBtnBlock(self.model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

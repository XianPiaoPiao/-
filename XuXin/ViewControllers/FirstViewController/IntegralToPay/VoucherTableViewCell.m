//
//  VoucherTableViewCell.m
//  XuXin
//
//  Created by xian on 2017/11/6.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "VoucherTableViewCell.h"
#import "VoucherModel.h"

@implementation VoucherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //icon_money_check_off.png
    [self.checkButton setImage:[UIImage imageNamed:@"icon_money_check_off.png"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"dingdan_chenggong.png"] forState:UIControlStateSelected];
    
}

- (void)setModel:(VoucherModel *)model{
    _model = model;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",model.value] ;
    self.codeLabel.text = [NSString stringWithFormat:@"%@",model.card_name] ;
    self.numberLabel.text = [NSString stringWithFormat:@"第%@位",model.num];
    _checkButton.selected = model.selected;
}

- (IBAction)clickCheckBtn:(id)sender {
    self.checkButton.selected = !self.checkButton.selected;
    _model.selected = _checkButton.selected;
    if (self.selectedCheckBtnBlock) {
        self.selectedCheckBtnBlock(self.model);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

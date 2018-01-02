//
//  StoreCouponTableViewCell.m
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "StoreCouponTableViewCell.h"
#import "StoreCouponModel.h"

@implementation StoreCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self.getCouponButton setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
//    [self.getCouponButton setBackgroundColor:[UIColor whiteColor]];
//    self.getCouponButton.layer.cornerRadius = 15.0f;
//    self.getCouponButton.layer.masksToBounds = YES;
}

- (void)setModel:(StoreCouponModel *)model{
    _model = model;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",[model.price doubleValue]];
    self.conditionLabel.text = [NSString stringWithFormat:@"满%.2f使用",[model.order_price doubleValue]];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期：%@",model.end_time];
    if (model.receivestate == 0) {
        [self.getCouponButton setImage:[UIImage imageNamed:@"receive"] forState: UIControlStateNormal];
    } else if (model.receivestate == 1) {
        [self.getCouponButton setImage:[UIImage imageNamed:@"already_received"] forState: UIControlStateNormal];
    } else if (model.receivestate == 2) {
        [self.getCouponButton setImage:[UIImage imageNamed:@"already_finished"] forState: UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

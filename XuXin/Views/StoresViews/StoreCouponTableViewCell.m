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
    self.valueLabel.text = [NSString stringWithFormat:@"%@",model.price];
    self.conditionLabel.text = [NSString stringWithFormat:@"满%@使用",model.order_price];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期：%@",model.end_time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

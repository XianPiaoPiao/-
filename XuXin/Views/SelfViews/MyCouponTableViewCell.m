//
//  MyCouponTableViewCell.m
//  XuXin
//
//  Created by xian on 2017/12/14.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "MyCouponTableViewCell.h"

@implementation MyCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:BackColor];
    _useButton.layer.borderColor = [[UIColor colorWithHexString:@"#557fd8"] CGColor];
    _useButton.layer.borderWidth = 1.0f;
    _useButton.layer.cornerRadius = 12.0f;
    _useButton.layer.masksToBounds = YES;
    _useButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

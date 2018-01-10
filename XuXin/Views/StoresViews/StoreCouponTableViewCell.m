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
    self.getCouponButton.userInteractionEnabled = NO;
    _bgview = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, 100)];
    [self addSubview:_bgview];
    _bgImgView = [UIImageView new];
    [self addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgview.mas_top);
        make.right.equalTo(_bgview.mas_right);
        make.width.equalTo(_bgview.mas_height);
        make.height.equalTo(_bgview.mas_height);
    }];
    
    
}

- (void)setModel:(StoreCouponModel *)model{
    _model = model;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",[model.price doubleValue]];
    self.conditionLabel.text = [NSString stringWithFormat:@"满%.2f使用",[model.order_price doubleValue]];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期：%@",model.end_time];
    [self.getCouponButton setImage:[UIImage imageNamed:@"receive"] forState: UIControlStateNormal];
    self.status = model.receivestate;
    WEAK
    [RACObserve(self, status) subscribeNext:^(NSNumber *x) {
        STRONG
        if (x.integerValue > 0) {
            self.userInteractionEnabled = NO;
            self.bgview.backgroundColor = [UIColor colorWithHexString:@"#ffc2a5" alpha:0.85];
            if (x.integerValue == 1) {
                [self.bgImgView setImage:[UIImage imageNamed:@"coupons_have_been_received"]];
            } else if (x.integerValue == 2) {
                [self.bgImgView setImage:[UIImage imageNamed:@"the_coupon_is_finished"]];
            }
        } else {
            self.userInteractionEnabled = YES;
            self.bgview.backgroundColor = [UIColor clearColor];
//            [self.bgview removeFromSuperview];
            [self.bgImgView setImage:nil];
//            [self.bgImgView removeFromSuperview];
        }
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

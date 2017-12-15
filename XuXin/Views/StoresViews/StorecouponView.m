//
//  StorecouponView.m
//  XuXin
//
//  Created by xian on 2017/12/11.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "StorecouponView.h"

@implementation StorecouponView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(58, 12));
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.receiveLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(80, 25));
        make.left.equalTo(self.leftImgView.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(8, 10));
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (UIImageView *)leftImgView{
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.image = [UIImage imageNamed:@"coupon_icon"];
        [self addSubview:_leftImgView];
    }
    return _leftImgView;
}

- (UILabel *)receiveLbl{
    if (!_receiveLbl) {
        _receiveLbl = [UILabel new];
        _receiveLbl.text = @"领取优惠券";
        _receiveLbl.font = [UIFont systemFontOfSize:12.0f];
        _receiveLbl.textColor = [UIColor colorWithHexString:WordLightColor];
        [self addSubview:_receiveLbl];
    }
    return _receiveLbl;
}

- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [UIImageView new];
        _rightImgView.image = [UIImage imageNamed:@"icon_address_right_arrow"];
        [self addSubview:_rightImgView];
    }
    return _rightImgView;
}

@end

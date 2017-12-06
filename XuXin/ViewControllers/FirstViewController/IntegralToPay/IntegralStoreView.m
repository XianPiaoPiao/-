//
//  IntegralStoreView.m
//  XuXin
//
//  Created by xian on 2017/11/6.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "IntegralStoreView.h"

@implementation IntegralStoreView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.skfLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.size.sizeOffset(CGSizeMake(80, 25));
    }];
    
    [self.skfDetailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skfLbl.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.skfLbl.mas_centerY);
        make.height.mas_offset(25);
    }];
    
    [self.orderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.skfLbl.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(80, 25));
    }];
    
    [self.orderCodeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderLbl.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.orderLbl.mas_centerY);
        make.height.mas_offset(25);
    }];
    
    UILabel *bgLbl = [UILabel new];
    bgLbl.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self addSubview:bgLbl];
    
    [bgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.orderLbl.mas_bottom).offset(5);
        make.size.sizeOffset(CGSizeMake(ScreenW, 10));
    }];
    
    [self.voucherLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(bgLbl.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(80, 25));
    }];
    
    [self.usevoucherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.voucherLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 30));
    }];
    
    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.voucherLbl.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(80, 25));
    }];
    
    [self.totalDetailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalLbl.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.totalLbl.mas_centerY);
        make.height.mas_offset(25);
    }];
    
    [self.pwdLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.totalLbl.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(80, 25));
    }];
    
    [self.pwdTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdLbl.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.pwdLbl.mas_centerY);
        make.height.mas_offset(25);
    }];
    
    
}

- (UILabel *)skfLbl{
    if (!_skfLbl) {
        _skfLbl = [UILabel new];
        _skfLbl.text = @"收款方";
        _skfLbl.font = [UIFont systemFontOfSize:13.0f];
        _skfLbl.textColor = [UIColor colorWithHexString:WordDeepColor];
        [self addSubview:_skfLbl];
    }
    return _skfLbl;
}

- (UILabel *)skfDetailLbl{
    if (!_skfDetailLbl) {
        _skfDetailLbl = [UILabel new];
        _skfDetailLbl.text = @"嗨兑商城移动";
        _skfDetailLbl.textAlignment = NSTextAlignmentRight;
        _skfDetailLbl.font = [UIFont systemFontOfSize:14.0f];
        _skfDetailLbl.textColor = [UIColor colorWithHexString:WordLightColor];
        [self addSubview:_skfDetailLbl];
    }
    return _skfDetailLbl;
}

- (UILabel *)orderLbl{
    if (!_orderLbl) {
        _orderLbl = [UILabel new];
        _orderLbl.text = @"订单";
        _orderLbl.font = [UIFont systemFontOfSize:14.0f];
        _orderLbl.textColor = [UIColor colorWithHexString:WordDeepColor];
        [self addSubview:_orderLbl];
    }
    return _orderLbl;
}

- (UILabel *)orderCodeLbl{
    if (!_orderCodeLbl) {
        _orderCodeLbl = [UILabel new];
        _orderCodeLbl.textAlignment = NSTextAlignmentRight;
        _orderCodeLbl.font = [UIFont systemFontOfSize:14.0f];
        _orderCodeLbl.textColor = [UIColor colorWithHexString:WordLightColor];
        [self addSubview:_orderCodeLbl];
    }
    return _orderCodeLbl;
}

- (UILabel *)totalLbl{
    if (!_totalLbl) {
        _totalLbl = [UILabel new];
        _totalLbl.text = @"可用积分";
        _totalLbl.font = [UIFont systemFontOfSize:14.0f];
        _totalLbl.textColor = [UIColor colorWithHexString:WordDeepColor];
        [self addSubview:_totalLbl];
    }
    return _totalLbl;
}

- (UILabel *)totalDetailLbl{
    if (!_totalDetailLbl) {
        _totalDetailLbl = [UILabel new];
        _totalDetailLbl.textAlignment = NSTextAlignmentRight;
        _totalDetailLbl.font = [UIFont systemFontOfSize:14.0f];
        _totalDetailLbl.textColor = [UIColor colorWithHexString:WordLightColor];
        [self addSubview:_totalDetailLbl];
    }
    return _totalDetailLbl;
}

- (UILabel *)voucherLbl{
    if (!_voucherLbl) {
        _voucherLbl = [UILabel new];
        _voucherLbl.text = @"使用兑换券";
        _voucherLbl.font = [UIFont systemFontOfSize:14.0f];
        _voucherLbl.textColor = [UIColor colorWithHexString:WordDeepColor];
        [self addSubview:_voucherLbl];
    }
    return _voucherLbl;
}

- (UILabel *)pwdLbl{
    if (!_pwdLbl) {
        _pwdLbl = [UILabel new];
        _pwdLbl.text = @"支付密码";
        _pwdLbl.font = [UIFont systemFontOfSize:14.0f];
        _pwdLbl.textColor = [UIColor colorWithHexString:WordDeepColor];
        [self addSubview:_pwdLbl];
    }
    return _pwdLbl;
}

- (UIButton *)usevoucherBtn{
    if (!_usevoucherBtn) {
        _usevoucherBtn = [UIButton new];
        
        [_usevoucherBtn setImage:[UIImage imageNamed:@"icon_shopcart_right_arrow"] forState:UIControlStateNormal];
        [self addSubview:_usevoucherBtn];
    }
    return _usevoucherBtn;
}

- (UITextField *)pwdTxt{
    if (!_pwdTxt) {
        _pwdTxt = [UITextField new];
        _pwdTxt.placeholder = @"请输入支付密码";
        _pwdTxt.secureTextEntry = YES;
        _pwdTxt.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_pwdTxt];
    }
    return _pwdTxt;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

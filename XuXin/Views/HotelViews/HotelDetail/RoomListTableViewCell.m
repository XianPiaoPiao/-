//
//  RoomListTableViewCell.m
//  HotelUIDemo
//
//  Created by xian on 2018/1/27.
//  Copyright © 2018年 xian. All rights reserved.
//

#import "RoomListTableViewCell.h"

@implementation RoomListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = [UIColor colorWithHexString:BackColor];
    CGFloat width = self.bounds.size.width/5*3;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(1, self.bounds.size.height-10));
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(width);
    }];
    
    UILabel *bottomLbl = [[UILabel alloc] init];
    bottomLbl.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLbl];
    [bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.size.sizeOffset(self.bounds.size);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(label.mas_left).offset(5);
    }];
    
    [self.payTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.right.equalTo(label.mas_left).offset(5);
    }];
    
    [self.satisfactionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.satisfactionLbl.mas_bottom).offset(10);
        make.right.equalTo(label.mas_left).offset(5);
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
//        make.
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderBtn.mas_left).offset(-10);
    }];
    
}

- (UILabel *)nameLbl {
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] init];
        [self addSubview:_nameLbl];
    }
    return _nameLbl;
}

- (UILabel *)payTypeLbl {
    if (!_payTypeLbl) {
        _payTypeLbl = [[UILabel alloc] init];
        _payTypeLbl.textColor = [UIColor grayColor];
        [self addSubview:_payTypeLbl];
    }
    return _payTypeLbl;
}

- (UILabel *)satisfactionLbl {
    if (!_satisfactionLbl) {
        _satisfactionLbl = [[UILabel alloc] init];
        _satisfactionLbl.textColor = [UIColor grayColor];
        [self addSubview:_satisfactionLbl];
    }
    return _satisfactionLbl;
}

- (UILabel *)priceLbl {
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] init];
        _priceLbl.textColor = [UIColor redColor];
        _priceLbl.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_priceLbl];
    }
    return _priceLbl;
}

- (UIButton *)orderBtn {
    if (!_orderBtn) {
        _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self addSubview:_orderBtn];
    }
    return _orderBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

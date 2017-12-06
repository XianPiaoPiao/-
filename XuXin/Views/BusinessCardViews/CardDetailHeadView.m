//
//  CardDetailHeadView.m
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CardDetailHeadView.h"
#import "BusinessCardModel.h"

@implementation CardDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIImageView *bgImgView = [UIImageView new];
    bgImgView.frame = self.bounds;
    [bgImgView setImage:[UIImage imageNamed:@"mpbj"]];
    [self addSubview:bgImgView];
    
    [self.firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(10);
        make.size.sizeOffset(CGSizeMake(70, 70));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.firstNameLabel.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(ScreenW-20, 25));
    }];
    
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(ScreenW-20, 25));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.jobLabel.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(ScreenW-20, 25));
    }];
}

- (void)setModel:(BusinessCardModel *)model{
    _firstNameLabel.text = [model.username substringToIndex:1];
    _nameLabel.text = model.username;
    _jobLabel.text = model.job;
    _addressLabel.text = model.company;
}

- (UILabel *)firstNameLabel{
    if (!_firstNameLabel) {
        _firstNameLabel = [UILabel new];
        _firstNameLabel.textAlignment = NSTextAlignmentCenter;
        _firstNameLabel.font = [UIFont systemFontOfSize:30.0f];
        _firstNameLabel.textColor = [UIColor colorWithHexString:@"#ee6721"];
        _firstNameLabel.layer.cornerRadius = 35.0f;
        _firstNameLabel.layer.masksToBounds = YES;
        _firstNameLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_firstNameLabel];
    }
    return _firstNameLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)jobLabel{
    if (!_jobLabel) {
        _jobLabel = [UILabel new];
        _jobLabel.textAlignment = NSTextAlignmentCenter;
        _jobLabel.font = [UIFont systemFontOfSize:14.0f];
        _jobLabel.textColor = [UIColor whiteColor];
        [self addSubview:_jobLabel];
    }
    return _jobLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.font = [UIFont systemFontOfSize:14.0f];
        _addressLabel.textColor = [UIColor whiteColor];
        [self addSubview:_addressLabel];
    }
    return _addressLabel;
}

@end

//
//  HotelLoactionBottom.m
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/5.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import "HotelLoactionBottom.h"
#import "ACMacros.h"

@interface HotelLoactionBottom()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *label;
@end

@implementation HotelLoactionBottom

-(instancetype)init{
    if (self == [super init]) {
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.mas_equalTo(-8);
            make.width.height.mas_equalTo(21);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.mas_equalTo(10);
        }];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self init];
}

#pragma -mark lazy
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconView.image = [UIImage imageNamed:@"query_location_icon"];
        [self addSubview:_iconView];
    }
    return _iconView;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        _label.text = @"当前位置";
        _label.font = [UIFont systemFontOfSize:10.];
        _label.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_label];
    }
    return _label;
}

@end

//
//  HotelNavView.m
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/2.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import "HotelNavView.h"
#import "ACMacros.h"
@interface HotelNavView()
@property (nonatomic,strong) UIView *bottomView;
//返回
@property (nonatomic,strong) UIButton *backBtn;
//内容视图
@property (nonatomic,strong) UIView *contentView;
///日历选择
@property (nonatomic,strong) UIButton *calendarBtn;
//住
@property (nonatomic,strong) UILabel *startLabel;
//离
@property (nonatomic,strong) UILabel *endLabel;
//downIcon
@property (nonatomic,strong) UIImageView *chooseIcon;
//分割线
@property (nonatomic,strong) UIView *lineView;
//搜索按钮
@property (nonatomic,strong) UIButton *searchBtn;

@property (nonatomic,strong) UIButton *locationBtn;

@property (nonatomic,strong) UIButton *messageBtn;

@end

@implementation HotelNavView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma -mark setUp
-(void)setUp{
    
    self.backgroundColor = UIColorFromRGB(0x08A4EA);
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(20, 0, 0, 0)).equalTo(self);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.width.height.mas_equalTo(26);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageBtn.mas_left).offset(-12);
        make.width.height.mas_equalTo(26);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(10);
        make.right.equalTo(self.locationBtn.mas_left).offset(-10);
        make.height.mas_offset(32);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.calendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.bottom.equalTo(self.contentView).offset(0);
        make.width.mas_equalTo(75);
    }];
    
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendarBtn).offset(0);
        make.centerY.equalTo(self.calendarBtn).offset(-8);
    }];
    
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendarBtn).offset(0);
        make.centerY.equalTo(self.calendarBtn).offset(8);
    }];
    
    [self.chooseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.calendarBtn).offset(-10);
        make.centerY.equalTo(self.calendarBtn);
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendarBtn.mas_right).offset(0);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(18);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(0);
        make.top.right.bottom.equalTo(self.contentView);
    }];
}


#pragma -mark lazy

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_backBtn setImage:[UIImage imageNamed:@"query_the_head_arrow_icon"] forState:UIControlStateNormal];
        [self.bottomView addSubview:_backBtn];
        [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"返回");
            [self.delegate clickNavViewButton:@"back"];
        }];
    }
    return _backBtn;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 18.0;
        _contentView.layer.masksToBounds = YES;
        [self.bottomView addSubview:_contentView];
    }
    return _contentView;
}

-(UIButton *)calendarBtn{
    if (!_calendarBtn) {
        _calendarBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_calendarBtn];
        [[_calendarBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"日历");
            [self.delegate clickNavViewButton:@"calendar"];
        }];
    }
    return _calendarBtn;
}


-(UILabel *)startLabel{
    if (!_startLabel) {
        _startLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _startLabel.text = @"住01-25";
        _startLabel.textColor = UIColorFromRGB(0x666666);
        _startLabel.font = [UIFont systemFontOfSize:12];
        [self.calendarBtn addSubview:_startLabel];
    }
    return _startLabel;
}

-(UILabel *)endLabel{
    if (!_endLabel) {
        _endLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _endLabel.text = @"离01-27";
        _endLabel.textColor = UIColorFromRGB(0x666666);
        _endLabel.font = [UIFont systemFontOfSize:12];
        [self.calendarBtn addSubview:_endLabel];
    }
    return _endLabel;
}

-(UIImageView *)chooseIcon{
    if (!_chooseIcon) {
        _chooseIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _chooseIcon.image = [UIImage imageNamed:@"list_filter_dropdown_icon"];
        [self.calendarBtn addSubview:_chooseIcon];
    }
    return _chooseIcon;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0x666666);
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_searchBtn setTitle:@"解放碑" forState:UIControlStateNormal];
        _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_searchBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_searchBtn setImage:[UIImage imageNamed:@"homepage_search_icon"] forState:UIControlStateNormal];
        [_searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_searchBtn];
        [[_searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"搜索");
            [self.delegate clickNavViewButton:@"search"];
        }];
    }
    return _searchBtn;
}

-(UIButton *)locationBtn{
    if (!_locationBtn) {
        _locationBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_locationBtn setImage:[UIImage imageNamed:@"list_address_icon"] forState:UIControlStateNormal];
        [self.bottomView addSubview:_locationBtn];
        [[_locationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"定位");
            [self.delegate clickNavViewButton:@"location"];
        }];
    }
    return _locationBtn;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _messageBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [_messageBtn setImage:[UIImage imageNamed:@"home_page_information_icon"] forState:UIControlStateNormal];
        [self.bottomView addSubview:_messageBtn];
        [[_messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"消息");
            [self.delegate clickNavViewButton:@"message"];
        }];
    }
    return _messageBtn;
}

@end

//
//  CardHeaderView.m
//  XuXin
//
//  Created by xian on 2017/9/23.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CardHeaderView.h"

@implementation CardHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:_imgView];
    }
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, ScreenW-70, 30)];
        [self addSubview:_titleLbl];
    }
    
}

- (void)setType:(BOOL)type{
    if (type) {
        _titleLbl.text = @"我的名片";
        [_imgView setImage:[UIImage imageNamed:@"my_icon"]];
    } else {
        _titleLbl.text = @"好友名片";
        [_imgView setImage:[UIImage imageNamed:@"friends_icon"]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

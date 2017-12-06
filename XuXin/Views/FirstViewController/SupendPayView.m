//
//  SupendPayView.m
//  XuXin
//
//  Created by xuxin on 16/8/21.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SupendPayView.h"

@implementation SupendPayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    
    self.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 10;
    CGFloat buttonW = 100;//122
    CGFloat buttonH = 33;
    CGFloat buttonX = ScreenW - buttonW - margin;
    CGFloat buttonY = 30;//10
    
 
    
   self.payButton= [[UIButton alloc] initWithFrame:CGRectMake(buttonX,buttonY , buttonW,buttonH)];
    [self addSubview:_payButton];
    _payButton.backgroundColor = [UIColor colorWithHexString:MainColor];
    [_payButton setTitle:@"面对面支付" forState:UIControlStateNormal];
    _payButton.titleLabel.font= [UIFont systemFontOfSize:15];
    _payButton.layer.cornerRadius = 15;
 
    CGFloat titleLabelW = ScreenW -20;
    CGFloat titleLabelH = 30;
    CGFloat titleLabelX = 10;
    CGFloat titleLabelY = 0;
 
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    [_titleLabel setText:@""];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLabel];
    
    CGFloat likeLableX = 10;
    CGFloat likeLabelY = 35;
    CGFloat likeLabelW = 100;
    CGFloat likeLabelH = 18;
    
    StarsView * likeLabel = [[StarsView alloc] initWithFrame:CGRectMake(likeLableX, likeLabelY, likeLabelW, likeLabelH)];
    self.starsView = likeLabel;
    [self addSubview:likeLabel];
    
    CGFloat equalLableX = 10;//120
    CGFloat equalLableY = 48;//32
    CGFloat equalLabelW = 100;
    CGFloat equalLabelH = 20;
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(equalLableX, equalLableY, equalLabelW, equalLabelH)];
    [self addSubview:_priceLabel];
    [_priceLabel setText:@""];
    [_priceLabel setTextColor:[UIColor colorWithHexString:MainColor]];
    _priceLabel.font =[UIFont systemFontOfSize:14];
    //分割线
    UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, ScreenW, 1)];
    seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self addSubview:seperateView];
}

@end

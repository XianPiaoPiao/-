//
//  CityListHeaderVIew.m
//  XuXin
//
//  Created by xuxin on 16/9/11.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CityListHeaderVIew.h"

@implementation CityListHeaderVIew{
    UILabel * _label;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    
     UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW -10, 40)];
    [bgView addSubview:_label];
    
    [self addSubview:bgView];
    
}
-(void)addTitle:(NSString *)title{
    
    [_label setText:title];
    [_label setFont:[UIFont systemFontOfSize:14]];
    [_label setTextColor:[UIColor blackColor]];
}
@end

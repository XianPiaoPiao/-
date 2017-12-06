//
//  HaiDuiField.m
//  XuXin
//
//  Created by xuxin on 16/8/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HaiDuiField.h"

@implementation HaiDuiField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    
    UITextField * numberField = [[UITextField alloc] initWithFrame:CGRectMake(0, 200, ScreenW, 45)];
    numberField.backgroundColor = [UIColor redColor];
    
    [self addSubview:numberField];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
    label.textAlignment = 1;
    label.text = @"金额";
    [label setTextColor:[UIColor blackColor]];
    [numberField setLeftView:label];
    [label setFont:[UIFont systemFontOfSize:17]];
    //设置field的左视图
    numberField.leftViewMode = UITextFieldViewModeAlways;
    numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [numberField setPlaceholder:@"请输入充值金额"];
}
@end

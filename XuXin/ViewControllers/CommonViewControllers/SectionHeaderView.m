//
//  SectionHeaderView.m
//  XuXin
//
//  Created by xuxin on 16/8/23.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView{
    UIImageView * imageView;
    UILabel * label;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
      
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    //创建文字图片
   imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 18, 18)];
   label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 200, 40)];
   //分割线
    [label setFont:[UIFont systemFontOfSize:14]];
    UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenW, 1)];
    seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [bgView addSubview:seperateView];
    [bgView addSubview:imageView];
    [bgView addSubview:label];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
}
-(void)addImage:(NSString *)ImageTitle andTitle:(NSString *)title{
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",ImageTitle]];
     [label setText:title];
      [label setTextColor:[UIColor colorWithHexString:MainColor]];
}
@end

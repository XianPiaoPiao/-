//
//  StarsView.m
//  XuXin
//
//  Created by xuxin on 16/9/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "StarsView.h"

@implementation StarsView
{
    //前景图
    UIImageView * _foregroundImageView;
    UIImageView * _backgroundImageView;
}
-(void)createViews{
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wujiaoxing2"]];
    [self addSubview:_backgroundImageView];
    //设置图片属性
    //居左
    //创建前景图
    _foregroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wujiaoxing"]];
    
    [self addSubview:_foregroundImageView];
    //设置显示模式
    _foregroundImageView.contentMode = UIViewContentModeLeft;
    _backgroundImageView.contentMode =UIViewContentModeLeft;
    
    //裁剪视图
    _foregroundImageView.clipsToBounds = YES;
}
//当自定义的视图和xib或者storyboard中对应的视图关联后，xib或者storyboard会调用该方法创建对象
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self createViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    CGRect customRect = CGRectMake(frame.origin.x, frame.origin.y,frame.size.width , frame.size.height);
    if (self = [super initWithFrame:customRect]) {
        [self createViews];
    }
    return self;
}
-(void)setStarValue:(CGFloat)starValue{
    
    _starValue = starValue;
    
    if (_starValue <0 || _starValue >5) {
        return;
    }
    //处理前景图
    CGRect rect = _backgroundImageView.frame;
    // CGRect rect = CGRectMake(_backgroundImageView.frame.origin.x, _backgroundImageView.frame.origin.y, _backgroundImageView.frame.size.width, 8);
    rect.size.width = rect.size.width * (_starValue / 5.0f);
    _foregroundImageView.frame = rect;
    
}

@end

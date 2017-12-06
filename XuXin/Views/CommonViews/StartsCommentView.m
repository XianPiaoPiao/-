//
//  StartsCommentView.m
//  XuXin
//
//  Created by xuxin on 17/3/6.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "StartsCommentView.h"

@implementation StartsCommentView
{
    //前景图
    UIImageView * _foregroundImageView;
    UIImageView * _backgroundImageView;
}
-(void)createViews{
    
//    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    NSLog(@"%f",self.frame.size.width);
//    _backgroundImageView.image = [UIImage imageNamed:@"Five-star-grey"];
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Five-star-grey"]];
    [self addSubview:_backgroundImageView];

    //设置图片属性
    //居左
    
    //创建前景图
//    _foregroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    _foregroundImageView.image = [UIImage imageNamed:@"Wuxing"];
    _foregroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Wuxing"]];
    
    [self addSubview:_foregroundImageView];
    //设置显示模式
    _foregroundImageView.contentMode = UIViewContentModeLeft;
    _backgroundImageView.contentMode =UIViewContentModeLeft;
    
    //裁剪视图
    _foregroundImageView.clipsToBounds = YES;
    
    //startView添加点击事件
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startValueChange:)];
    
    [self addGestureRecognizer:tapGesture];
    //startView添加滑动手势
    UISwipeGestureRecognizer * swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeStartsValue:)];
    [self addGestureRecognizer:swipGesture];
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
#pragma mark --星星的值改变
-(void)startValueChange:(UITapGestureRecognizer * )gesture{
    
    CGPoint point = [gesture locationInView:self];
    
    if (point.x > 160){
        
        [self setStarValue:5];
        
        
    }else if (point.x > 120){
        
        [self setStarValue:4];
        
    }else if (point.x > 80){
        
        [self setStarValue:3];
        
    }else if (point.x > 40 ) {
        
        [self setStarValue:2];
        
    }else{
        
        [self setStarValue:1];
        
    }
}

-(void)swipeStartsValue:(UISwipeGestureRecognizer *)gesture{
    
    
    CGPoint point = [gesture locationInView:self];
    
    if (point.x > 160){
        
        [self setStarValue:5];
        
    }else if (point.x > 120){
        [self setStarValue:4];
        
    }else if (point.x > 80){
        
        [self setStarValue:3];
        
    }else if (point.x > 40 ) {
        
        [self setStarValue:2];
        
    }else{
        [self setStarValue:1];
        
    }
    
}
@end

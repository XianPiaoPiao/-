//
//  EaseLoadingView.m
//  XuXin
//
//  Created by xuxin on 16/9/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "EaseLoadingView.h"



@interface EaseLoadingView ()
@property (nonatomic ,strong)NSMutableArray * imageArray;
@end

@implementation EaseLoadingView{
    
    UILabel * _textLabel;
}
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}
+(instancetype)defalutManager{
    
    static EaseLoadingView * view = nil;
    
    static dispatch_once_t onceToken = 0 ;
    dispatch_once(&onceToken, ^{
        if (!view) {
            view = [[EaseLoadingView alloc] initPrivate];
          
        }
    });
    return view;
}
-(instancetype)init{
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
    
}

-(instancetype)initPrivate{
    if (self = [super init]) {
        //
        CGFloat headerImageW = 60;
        CGFloat headerImageH = 120;
        //干些事情
        self.frame = CGRectMake(0, 64, ScreenW, screenH );
        //背景颜色
        self.backgroundColor = [UIColor whiteColor];
    
       _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake( (ScreenW - headerImageW)/2.0f, screenH/2.0f - headerImageH ,  headerImageW  , headerImageH)];
       [self addSubview:_headerImageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenW - 120)/2.0f, screenH/2.0f , 120  , 20)];
        _textLabel.text = @"努力加载中...";
        _textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _textLabel.textAlignment = 1;
        _textLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:_textLabel];
        
        for (int i = 1; i<= 3; i++) {
            
            NSString * imageName = [NSString stringWithFormat:@"tu%d@3x.png",i];
            UIImage * image = [UIImage imageNamed:imageName];
            [self.imageArray addObject:image];
            
        }
        [_headerImageView setAnimationImages:self.imageArray];
        [_headerImageView setAnimationDuration:1];
        [_headerImageView setAnimationRepeatCount:100];
    }
         return self;
}
-(void)startLoading{
    
    [_headerImageView startAnimating];

}
-(void)stopLoading{
    
    [_headerImageView stopAnimating];
    [self removeFromSuperview];
}
-(void)showErrorStatus{
      

}
@end

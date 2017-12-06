//
//  XXSegementControl.m
//  定制segmentControl
//
//  Created by xuxin on 16/4/12.
//  Copyright © 2016年 xuxin. All rights reserved.
//

#import "XXSegementControl.h"
#define button_tag 100
@implementation XXSegementControl{
   
    id _target;
    SEL _action;
}

-(void)addTarget:(id)target action:(SEL)action{
    
      _target = target;
      _action = action;
}

-(instancetype)initWithItems:(NSArray *)items{
    if (self=[super init]) {
        
        _items = items;
        
        [self creatUI];
    }
    return self;
}


#pragma mark - 重写选中下标的set方法
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex{
    
    _selectedSegmentIndex = selectedSegmentIndex;
    //将选中下标对应的按钮变成选中状态
  
    UIButton * btn = (UIButton *)[self viewWithTag:0 + buttonTag];
    UIButton * sBtn = (UIButton *)[self viewWithTag:1 + buttonTag];
    UIButton * ssBtn = (UIButton *)[self viewWithTag:2 + buttonTag];

    if (selectedSegmentIndex == 0) {
      
        btn.selected = YES;
        sBtn.selected = NO;
        [UIView animateWithDuration:0.3f animations:^{
            
        _sliderView.center = CGPointMake(btn.center.x, self.frame.size.height - _sliderView.frame.size.height/2.0f);
            
        }];
    }else if(selectedSegmentIndex == 1){
      
        sBtn.selected = YES;
        btn.selected = NO;
        [UIView animateWithDuration:0.3f animations:^{
            
        _sliderView.center = CGPointMake(sBtn.center.x, self.frame.size.height - _sliderView.frame.size.height/2.0f);
        }];
        
    }else{
        
        ssBtn.selected = YES;
        btn.selected = NO;
        sBtn.selected = NO;
        [UIView animateWithDuration:0.3f animations:^{
            
       _sliderView.center = CGPointMake(ssBtn.center.x, self.frame.size.height - _sliderView.frame.size.height/2.0f);
        }];
    }
    //关闭用户交互
  //  btn.userInteractionEnabled = NO;
    
    //改变滑块的中心点
    
}

-(void)creatUI{
    
    _sliderView = [[UIView alloc] init];
    
    _sliderView.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self addSubview:_sliderView];
    
    
    for (int i = 0; i < _items.count ; i ++) {
        
        UIButton * button = [[UIButton alloc] init];
        [self addSubview:button];
        
        button.tag = button_tag + i;
        if (i == 0) {
            
        button.selected = YES;
        }
        
        NSString * str = _items[i];

        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchDown];

    }
    
}
-(void)layView{
    
    //添加BUtton
    CGFloat W= self.frame.size.width/_items.count;
    CGFloat H= self.frame.size.height;
    
    CGFloat Y=0;
    
    for (int i = 0; i < _items.count; i++) {
        
        UIButton * button = [self viewWithTag:100 + i];
        button.frame =CGRectMake(i*W, Y, W, H);
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _sliderView.frame = CGRectMake(0 , button.frame.size.height - 2 , W, 2);

        
    }
    
}
-(void)onClicked:(UIButton *)button{

    UIButton * selectedBtn = (UIButton *)[self viewWithTag:_selectedSegmentIndex + buttonTag];
    //将之前选中的变成非选中状态
    selectedBtn.selected = NO;
    //让按钮可以点击
    selectedBtn.userInteractionEnabled = YES;
    
    
    //2.让被点击的按钮变成选中状态
    //    button.selected = YES;
    //    //让按钮不可点击
    //    button.userInteractionEnabled = NO;
    //    //更新当前选中的按钮下标
    //    _selectedSegmentIndex = button.tag - BUTTON_Tag;
    //代替上面上句话（因为设置按钮的选中和关闭按钮交互已经重新设置选中下标都已经在_selectedSegmentIndex的set方法中完成了）
    self.selectedSegmentIndex = button.tag - buttonTag;
    
    
    //3.选中下标的值发生改变，让效应消息的对象去效应消息
    //先判断事件对应的方法有没有实现
    if ([_target respondsToSelector:_action]) {
        
        [_target performSelector:_action withObject:self];
        
    }else{
        
        NSLog(@"警告:事件方法没有实现");
    }
    

}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    [self layView];
}
@end

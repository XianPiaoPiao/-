//
//  AddressView.m

//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.//
//

#import "AddressView.h"
#import "UIView+Frame.h"

static  CGFloat  const  QLBarItemMargin = 20;
@interface AddressView ()
@property (nonatomic,strong) NSMutableArray * btnArray;
@end

@implementation AddressView

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    for (NSInteger i = 0; i <= self.btnArray.count - 1 ; i++) {
        
        UIView * view = self.btnArray[i];
        if (i == 0) {
            view.left = QLBarItemMargin;
        }
        if (i > 0) {
            UIView * preView = self.btnArray[i - 1];
            view.left = QLBarItemMargin  + preView.right;
        }
        
    }
}

- (NSMutableArray *)btnArray{
    
    NSMutableArray * mArray  = [NSMutableArray array];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}

@end

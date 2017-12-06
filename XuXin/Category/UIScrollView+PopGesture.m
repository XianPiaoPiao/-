//
//  UIScrollView+PopGesture.m
//  Bulid
//
//  Created by xc on 2017/5/13.
//  Copyright © 2017年 ___YLJ___. All rights reserved.
//

#import "UIScrollView+PopGesture.h"

@implementation UIScrollView (PopGesture)
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            
            self.contentOffset = CGPointMake(0, 0);
            
            self.bounces = NO;
            
            return YES;
        }
    }
    
    return NO;
}
@end

//
//  UIImage+Extenstion.m
//  XuXin
//
//  Created by xuxin on 17/4/8.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "UIImage+Extenstion.h"

@implementation UIImage (Extenstion)
- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);CGContextAddPath(UIGraphicsGetCurrentContext(),
                                                                                                      [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

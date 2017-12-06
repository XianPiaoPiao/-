//
//  HaiduiTextFiled.m
//  嗨兑商家端
//
//  Created by xuxin on 17/5/31.
//  Copyright © 2017年 www.hidui.com. All rights reserved.
//

#import "HaiduiTextFiled.h"

@implementation HaiduiTextFiled


-(CGRect)textRectForBounds:(CGRect)bounds{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.textColor = [UIColor colorWithHexString:@"#333333"];
    
    self.font = [UIFont systemFontOfSize:15];
    
    CGRect rect = [super textRectForBounds:bounds];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    return UIEdgeInsetsInsetRect(rect, insets);

}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super textRectForBounds:bounds];
    
    
    CGFloat offset =40 - textRect.origin.x;
    
    textRect.origin.x =10;
    
    textRect.size.width = textRect.size.width - offset - 10;
    
    return textRect;
    
}

@end

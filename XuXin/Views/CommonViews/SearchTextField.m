//
//  SearchTextField.m
//  hidui
//
//  Created by xuxin on 17/2/13.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SearchTextField.h"

@implementation SearchTextField
-(CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super textRectForBounds:bounds];
    
    
    CGFloat offset =40 - textRect.origin.x;
    
    textRect.origin.x =30;
    
    textRect.size.width = textRect.size.width - offset - 10;
    
    return textRect;
    
}
-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect leftRect = [super leftViewRectForBounds:bounds];
    
    
    leftRect.origin.x =10;
    
    return leftRect;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightRect = [super rightViewRectForBounds:bounds];
    
    rightRect.origin.x = ScreenW - 30;
    
    return rightRect;
    
}

@end

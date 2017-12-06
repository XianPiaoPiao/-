//
//  RegisterField.m
//  XuXin
//
//  Created by xuxin on 16/9/13.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RegisterField.h"

@implementation RegisterField

-(CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super textRectForBounds:bounds];
    
    
    CGFloat offset =40 - textRect.origin.x;
    
    textRect.origin.x =10;
    
    textRect.size.width = textRect.size.width - offset - 10;
    
    return textRect;
    
}
-(BOOL)isSpacesExists
{
    //    NSString *_string = [NSString stringWithFormat:@"123 456"];
    NSRange _range = [self.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        
        [SVProgressHUD showErrorWithStatus:@"不能有空格"];
        return YES;
        
    }else
    {        //没有空格
        return NO;
    }
}
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super textRectForBounds:bounds];
    
    
    CGFloat offset =40 - textRect.origin.x;
    
    textRect.origin.x =10;
    
    textRect.size.width = textRect.size.width - offset - 10;
    
    return textRect;
    
}
-(BOOL)isSpecialCharacters
{
    NSCharacterSet *ValidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange Range = [self.text rangeOfCharacterFromSet:ValidCharacters];
    if (Range.location != NSNotFound)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有特殊字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return YES;
    }
    return NO;
}



@end

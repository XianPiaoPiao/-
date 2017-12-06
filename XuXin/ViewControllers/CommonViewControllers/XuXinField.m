//
//  XuXinField.m
//  XuXin
//
//  Created by xuxin on 16/9/6.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "XuXinField.h"
#import <CommonCrypto/CommonDigest.h>
@implementation XuXinField

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
-(CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super textRectForBounds:bounds];
    
    if (self.leftView ==nil) {
        
        return CGRectInset(textRect, 10,0);
        
    }else if (self.rightView == nil){
        
        return CGRectInset(textRect, 10,0);

    }
    
    textRect.origin.x = 70;
    
    return textRect;
    
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super textRectForBounds:bounds];
    
    
    CGFloat offset =40 - textRect.origin.x;
    
    textRect.origin.x =10;
    
    textRect.size.width = textRect.size.width - offset - 10;
    
    return textRect;
    
}
-(BOOL)isSpacesExists
{
    
    NSRange _range = [self.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能有空格" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return YES;
        
    }else
    {
        //没有空格
        return NO;
    }
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

-(NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
@end

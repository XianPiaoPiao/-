//
//  XuXinField.h
//  XuXin
//
//  Created by xuxin on 16/9/6.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XuXinField : UITextField
-(BOOL)isSpacesExists;

-(BOOL)isSpecialCharacters;

-(NSString *)md5:(NSString *)str;
@end

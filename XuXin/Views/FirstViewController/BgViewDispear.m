//
//  BgViewDispear.m
//  XuXin
//
//  Created by xuxin on 16/8/23.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BgViewDispear.h"

@implementation BgViewDispear

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tap" object:nil];
    
}

@end

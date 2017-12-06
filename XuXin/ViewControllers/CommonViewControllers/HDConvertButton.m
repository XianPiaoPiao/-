//
//  HDConvertButton.m
//  XuXin
//
//  Created by xuxin on 16/10/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDConvertButton.h"

@implementation HDConvertButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, contentRect.size.height - 10,ScreenW / 4.0f, 10);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((ScreenW/4.0f - 40)/2.0f, 0, 40 , 40);
}

@end

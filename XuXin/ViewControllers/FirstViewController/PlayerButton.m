//
//  PlayerButton.m
//  XuXin
//
//  Created by xuxin on 16/11/16.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "PlayerButton.h"
#import "LoLStoreViewController.h"
@implementation PlayerButton

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch =[touches anyObject];
    
    LoLStoreViewController * LoLVC=[[LoLStoreViewController alloc] init];
    
    CGPoint  point =[touch locationInView:LoLVC.view];
    
    self.center=point;
    
}
@end

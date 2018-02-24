//
//  HotelToolView.m
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/2.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import "HotelToolView.h"

@implementation HotelToolView


- (IBAction)clickSort:(UIButton *)sender {
    NSLog(@"推荐排序");
}

- (IBAction)clickPrice:(UIButton *)sender {
    NSLog(@"星级价格");
}

- (IBAction)clickLoaction:(UIButton *)sender {
    NSLog(@"酒店位置");
}

- (IBAction)clickComprehensive:(UIButton *)sender {
    NSLog(@"综合筛选");
}

@end

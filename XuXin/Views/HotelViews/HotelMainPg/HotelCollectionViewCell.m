//
//  HotelCollectionViewCell.m
//  HotelUIDemo
//
//  Created by xian on 2018/1/31.
//  Copyright © 2018年 xian. All rights reserved.
//

#import "HotelCollectionViewCell.h"

@implementation HotelCollectionViewCell

+(CGSize)getSize {
    return CGSizeMake(ScreenW/3, ScreenW/3+50);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

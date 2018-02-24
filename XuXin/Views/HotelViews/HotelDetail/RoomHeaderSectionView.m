//
//  RoomHeaderSectionView.m
//  XuXin
//
//  Created by xian on 2018/2/9.
//  Copyright © 2018年 xienashen. All rights reserved.
//

#import "RoomHeaderSectionView.h"
@interface RoomHeaderSectionView ()
/**
 酒店icon
 */
@property (weak, nonatomic) IBOutlet UIImageView *hotelImgView;
/**
 房间名称
 */
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
/**
 房间大小
 */
@property (weak, nonatomic) IBOutlet UILabel *roomSizeLabel;
/**
 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 优惠券
 */
@property (weak, nonatomic) IBOutlet UIButton *couponButton;
/**
 右侧按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
@implementation RoomHeaderSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

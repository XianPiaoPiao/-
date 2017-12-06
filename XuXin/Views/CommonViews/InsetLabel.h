//
//  InsetLabel.h
//  hidui
//
//  Created by xuxin on 17/1/16.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetLabel : UILabel
//用于设置Label的内边距
@property(nonatomic) UIEdgeInsets insets;
//初始化方法一
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
//初始化方法二
-(id) initWithInsets: (UIEdgeInsets) insets;
@end

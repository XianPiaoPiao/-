//
//  HDHeaderView.m
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDHeaderView.h"
@interface HDHeaderView()


@end

@implementation HDHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setHeaderUI];
    }
    return self;
}

- (void)setHeaderUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectStoreGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectStoreGoodsButton.frame = CGRectZero;
    
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"icon_radio_circle_off@2x"]
                                 forState:UIControlStateNormal];
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"dingdan_chenggong"]
                                 forState:UIControlStateSelected];
    self.selectStoreGoodsButton.backgroundColor=[UIColor clearColor];
 //   [self.selectStoreGoodsButton addTarget:self action:@selector(selectShopGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectStoreGoodsButton];
    
    self.storeNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.storeNameButton.frame = CGRectZero;
    [self.storeNameButton setTitle:@"嗨兑商城"
                          forState:UIControlStateNormal];
    [self.storeNameButton setTitleColor:[UIColor blackColor]
                               forState:UIControlStateNormal];
    self.storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.storeNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.storeNameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.storeNameButton];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.selectStoreGoodsButton.frame = CGRectMake(5, 5, 30, 30);
    
    self.storeNameButton.frame = CGRectMake(24, 0, ScreenW - 40, 40);
    
}

+ (CGFloat)getCartHeaderHeight{
    
    return 40;
}

@end

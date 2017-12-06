//
//  HDFooterView.m
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDFooterView.h"
#import "HDShopCarModel.h"
@interface HDFooterView ()

@property (nonatomic, retain) UILabel *priceLabel;

@end
@implementation HDFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initCartFooterView];
    }
    return self;
}

- (void)initCartFooterView{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = @"小记:￥15.80";
    _priceLabel.textColor = [UIColor redColor];
    
    [self addSubview:_priceLabel];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _priceLabel.frame = CGRectMake(10, 0.5, ScreenW-20, 30);
    
}

- (void)setShopGoodsArray:(NSMutableArray *)shopGoodsArray{
    
    _shopGoodsArray = shopGoodsArray;
    
    NSArray *pricesArray = [[[_shopGoodsArray rac_sequence] map:^id(HDShopCarModel *model) {
        

        return @(model.count*model.ig_goods_integral);
        
    }] array];
    
    float shopPrice = 0;
    for (NSNumber *prices in pricesArray) {
        shopPrice += prices.floatValue;
    }
    _priceLabel.text = [NSString stringWithFormat:@"小记:￥%.2f",shopPrice];
}


+ (CGFloat)getCartFooterHeight{
    
    return 30;
}


@end

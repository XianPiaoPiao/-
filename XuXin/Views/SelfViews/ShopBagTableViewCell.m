//
//  ShopBagTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ShopBagTableViewCell.h"
#import "UILabel+Extension.h"

@implementation ShopBagTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selfStepperView.layer.borderWidth =1;
    self.selfStepperView.layer.cornerRadius = 5;
    self.selfStepperView.layer.borderColor = [UIColor colorWithHexString:BackColor].CGColor;
    self.shopBagImageView.layer.masksToBounds = YES;
    self.shopBagImageView.layer.cornerRadius = 6;
    
}
-(void)setModel:(HDShopCarModel *)model{
    
    _model = model;
    [self.shopBagImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    
    if (model.ig_goods_integral > 0) {
        [self.priceLabel labelWithIntegral:model.ig_goods_integral money:model.price];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price];
    }
    self.metureLabel.text = model.goodsSpecifications;
    
    self.goodsNameLabel.text = model.ig_goods_name;
    self.selectedBtn.selected = model.isSelect;
    self.selfStepperView.totalNum = model.p_stock;
    self.selfStepperView.currentCountNumber = model.count;
    
}
-(void)setOnlineModel:(GroupGoodsMOdel *)onlineModel{
    
    [self.shopBagImageView sd_setImageWithURL:[NSURL URLWithString:onlineModel.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",onlineModel.goods_price];
    
    self.goodsNameLabel.text = onlineModel.goods_name;
    self.selectedBtn.selected = onlineModel.isSelect;
   // self.selfStepperView.totalNum = onlineModel.p_stock;
    
    self.selfStepperView.currentCountNumber = onlineModel.count;
}
+ (CGFloat)getCartCellHeight{
    
    return 120;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

@end

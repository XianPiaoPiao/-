//
//  OrderDerailTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "OrderDerailTableViewCell.h"

@implementation OrderDerailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(intergralGoodsModel *)model{
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.goods.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld",model.count];
 
    self.goodsName.text = model.goods.ig_goods_name;
   
    //总积分
    self.pointTotalLabel.text=[NSString stringWithFormat:@"%ld分", model.goods.ig_goods_integral * model.count];
}
-(void)setGoodsModel:(ONLINEgoodsModel *)goodsModel{
   
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld",goodsModel.count];
    
    self.goodsName.text = goodsModel.goodsName;
    
    //总价格
    self.pointTotalLabel.text=[NSString stringWithFormat:@"￥%.2f", goodsModel.goodsPrice ];
    
    _metureLabel.text = goodsModel.goodsSpecifications;

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

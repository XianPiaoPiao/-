//
//  StoresGoodsCellTableViewCell.m
//  hidui
//
//  Created by xuxin on 17/1/17.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "StoresGoodsCellTableViewCell.h"

@implementation StoresGoodsCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImageView.layer.masksToBounds = YES;
    self.goodsImageView.layer.cornerRadius = 4;
}
-(void)setOnlineGoodsModel:(ONLINEgoodsModel *)onlineGoodsModel{
    _onlineGoodsModel = onlineGoodsModel;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:onlineGoodsModel.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    _goodsNameLbael.text = onlineGoodsModel.goods_name;
    _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", onlineGoodsModel.goods_price];
    _goodsCountLabel.text= [NSString stringWithFormat:@"%ld人付款", onlineGoodsModel.goods_salenum];
    
}
-(void)setGroupModel:(GroupGoodsMOdel *)groupModel{
    _groupModel = groupModel;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:groupModel.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    _goodsNameLbael.text = groupModel.goods_name;
    _goodsPriceLabel.text =[NSString stringWithFormat:@"￥%.2f",_groupModel.goods_price];
    _goodsCountLabel.text=[NSString stringWithFormat:@"%@人付款", groupModel.goods_salenum];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CovertDetailTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CovertDetailTableViewCell.h"
#import "UILabel+Extension.h"

@implementation CovertDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImageView.layer.masksToBounds = YES;
    self.goodsImageView.layer.cornerRadius = 3;
}
-(void)setGoodsModel:(Recommendgoods *)goodsModel{
    _goodsModel = goodsModel;
    _saleNumberLabel.hidden = YES;
  
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.logo] placeholderImage:[UIImage imageNamed:SqureBgImage]];
    _starsView.hidden = YES;
    _goodNumberLabel.text =[NSString stringWithFormat:@"%ld积分",goodsModel.ig_goods_integral];
    _goodsDescribeLabel.text = goodsModel.ig_goods_name;
}
-(void)setConvertModel:(ConvertGoodsCellModel *)convertModel{
    _convertModel = convertModel;
    _goodsDescribeLabel.font = [UIFont systemFontOfSize:14];
    _goodsDescribeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:convertModel.logo] placeholderImage:[UIImage imageNamed:SqureBgImage]];
    
    [_goodNumberLabel setTextColor:[UIColor colorWithHexString:WordLightColor]];
    _goodNumberLabel.font = [UIFont systemFontOfSize:10];
    
    _saleNumberLabel.font = [UIFont systemFontOfSize:14];
    _saleNumberLabel.textColor = [UIColor colorWithHexString:MainColor];
    
    _goodNumberLabel.text = [NSString stringWithFormat:@"%ld人兑换",convertModel.ig_exchange_count];
    [_saleNumberLabel labelWithIntegral:convertModel.ig_goods_integral money:convertModel.cash];
    _goodsDescribeLabel.text = convertModel.ig_goods_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

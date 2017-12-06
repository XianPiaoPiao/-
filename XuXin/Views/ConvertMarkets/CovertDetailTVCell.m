//
//  CovertDetailTVCell.m
//  XuXin
//
//  Created by xian on 2017/9/21.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CovertDetailTVCell.h"
#import "UILabel+Extension.h"

@implementation CovertDetailTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.goodsImageView.layer.masksToBounds = YES;
//    self.goodsImageView.layer.cornerRadius = 3;
}
-(void)setGoodsModel:(Recommendgoods *)goodsModel{
    _goodsModel = goodsModel;
    
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.logo] placeholderImage:[UIImage imageNamed:SqureBgImage]];
    _goodNumberLabel.text =[NSString stringWithFormat:@"%ld积分",goodsModel.ig_goods_integral];
    _goodsDescribeLabel.text = goodsModel.ig_goods_name;
}
-(void)setConvertModel:(ConvertGoodsCellModel *)convertModel{
    _convertModel = convertModel;
    _goodsDescribeLabel.font = [UIFont systemFontOfSize:14];
    _goodsDescribeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _goodsDescribeLabel.text = convertModel.ig_goods_name;
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:convertModel.logo] placeholderImage:[UIImage imageNamed:SqureBgImage]];
    
    [_goodNumberLabel setTextColor:[UIColor colorWithHexString:WordLightColor]];
//    _goodNumberLabel.font = [UIFont systemFontOfSize:15];
    _goodNumberLabel.text =[NSString stringWithFormat:@"%ld人兑换",convertModel.count];
    _goodNumberLabel.font = [UIFont systemFontOfSize:10];
    
    [_integralLabel labelWithIntegral:convertModel.ig_goods_integral money:convertModel.cash];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

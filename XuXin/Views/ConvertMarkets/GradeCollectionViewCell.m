//
//  GradeCollectionViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "GradeCollectionViewCell.h"
#import "UILabel+Extension.h"

@implementation GradeCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}
-(void)setModel:(ConvertGoodsCellModel *)model{
      _model = model;
    _goodsName.text = model.ig_goods_name;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:SqureBgImage]];
    _goodsGradeLabel.text =[NSString stringWithFormat:@"%.0f", model.ig_goods_integral];
    [_goodsGradeLabel labelWithIntegral:model.ig_goods_integral money:model.cash];
    
}
@end

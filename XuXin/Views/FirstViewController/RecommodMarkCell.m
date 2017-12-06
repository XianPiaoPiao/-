//
//  RecommodMarkCell.m
//  XuXin
//
//  Created by xuxin on 16/8/12.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecommodMarkCell.h"

@implementation RecommodMarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.ConstantLabel setTextColor:[UIColor colorWithHexString:WordDeepColor]];
    self.moneyNuberLabel.textColor = [UIColor colorWithHexString:WordDeepColor];
    self.ConsumeLabel.textColor = [UIColor colorWithHexString:WordDeepColor];
    self.NameLabel.textColor = [UIColor blackColor];
    self.DoLabel.textColor = [UIColor colorWithHexString:WordDeepColor];
    self.CharcterLabel.textColor = [UIColor colorWithHexString:WordDeepColor];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 3;
    
}
-(void)setModel:(recmondShopModel *)model{
    
    _model = model;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    
    self.NameLabel.text = model.store_name;
    
    if (model.percapita == 0) {
        
         self.moneyNuberLabel.text =  @"--元/人";
        
    }else{
        
       self.moneyNuberLabel.text = [NSString stringWithFormat:@"￥%ld/人",(long)model.percapita];
    }
    if (model.distance > 1 && model.distance < 999) {
        
        self.ConstantLabel.text =[NSString stringWithFormat:@"%.0fkm",model.distance];
        
    }else if (model.distance == 0 || model.distance > 999 ){
        
        self.ConstantLabel.text =@"--m";
    }
    else{
        self.ConstantLabel.text =[NSString stringWithFormat:@"%.0fm",model.distance * 1000];
    }
     self.CharcterLabel.text = [NSString stringWithFormat:@"[%@]   %@",model.area_name,model.store_class];
 
    self.DoLabel.text =model.store_address;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
   
}

@end

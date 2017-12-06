//
//  AllShopTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/16.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "AllShopTableViewCell.h"

@implementation AllShopTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.shopNameLbel.textColor = [UIColor blackColor];
    self.characterLabel.textColor = [UIColor colorWithHexString:MainColor];
//    self.characterLabel.layer.borderWidth = 0.5;
//    self.characterLabel.layer.borderColor = [[UIColor colorWithHexString:MainColor] CGColor];
    self.placeLabel.textColor = [UIColor colorWithHexString:WordDeepColor];
    self.priceLabel.textColor = [UIColor colorWithHexString:WordDeepColor];
    self.constantLabel.textColor = [UIColor colorWithHexString:WordDeepColor];

//    self.shopImageView.layer.masksToBounds = YES;
//    self.shopImageView.layer.cornerRadius = 3;
}
-(void)setModel:(shopListDetailModel *)model{
    _model= model;
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    
    _shopNameLbel.text = model.store_name;
    _placeLabel.text = model.store_address;
    if (model.distance > 1 && model.distance < 999) {
        
        _constantLabel.text =[NSString stringWithFormat:@"%.2fkm",model.distance];

    }else if (model.distance == 0 || model.distance > 999){
        
           _constantLabel.text =@"--m";
    }
    else{
        _constantLabel.text =[NSString stringWithFormat:@"%.0fm",model.distance * 1000];
    }
    _characterLabel.text = [NSString stringWithFormat:@"[%@]   [%@]",model.store_class,model.area_name];
    //人均
    if (model.percapita == 0) {
        
        _priceLabel.text = @"￥--/人";
    }else{
        
        _priceLabel.text =[NSString stringWithFormat:@"￥%ld/人",model.percapita];
    }
    if (model.store_evaluate == 0) {
        
        _startView.starValue = 5;

    }else{
        
        _startView.starValue = model.store_evaluate;

    }
}

-(void)setRecmondModel:(recmondShopModel *)recmondModel{
    _recmondModel= recmondModel;
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:recmondModel.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    
    _shopNameLbel.text = recmondModel.store_name;
    _placeLabel.text = recmondModel.store_address;
    if (recmondModel.distance > 1 && recmondModel.distance < 999) {
        
        _constantLabel.text =[NSString stringWithFormat:@"%.2fkm",recmondModel.distance];
        
    }else if (recmondModel.distance == 0 || recmondModel.distance > 999){
        
        _constantLabel.text =@"--m";
    }
    else{
        _constantLabel.text =[NSString stringWithFormat:@"%.0fm",recmondModel.distance * 1000];
    }
    _characterLabel.text = [NSString stringWithFormat:@"[%@]   [%@]",recmondModel.store_class,recmondModel.area_name];
    //人均
    if (recmondModel.percapita == 0) {
        
        _priceLabel.text = @"￥--/人";
    }else{
        
        _priceLabel.text =[NSString stringWithFormat:@"￥%ld/人",recmondModel.percapita];
    }
    if (recmondModel.store_evaluate == 0) {
        
        _startView.starValue = 5;
        
    }else{
        
        _startView.starValue = recmondModel.store_evaluate;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

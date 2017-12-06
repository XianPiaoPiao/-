//
//  QueueStatusTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/11/5.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "QueueStatusTableViewCell.h"

@implementation QueueStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _contentLabel.layer.masksToBounds = YES;
    _contentLabel.layer.cornerRadius = 4;
    self.shopHeaderImage.layer.masksToBounds = YES;
    self.shopHeaderImage.layer.cornerRadius = 15;
}

-(void)setModel:(AllcouponsModel *)model{
    _model = model;
    [_shopHeaderImage sd_setImageWithURL:[NSURL URLWithString:model.userPhoto] placeholderImage:[UIImage imageNamed:HaiduiUserImage]];
    
    _shopNumberLabel.text = model.ownerName;
    _storeNameLabel.text = model.merchantName;
    _couponPriceLabel.text =[NSString stringWithFormat:@"%ld",model.value];

    if (model.isQueue == 2) {
        _contentLabel.text = @"排队完成";
        _contentLabel.backgroundColor = [UIColor colorWithHexString:@"FF8C9B"];
    }else if (model.isQueue == 3){
        
        _contentLabel.text = @"已兑换成功";
        _contentLabel.backgroundColor = [UIColor colorWithHexString:@"999999"];
        
    }else{
        _contentLabel.text = @"已转账";
        _contentLabel.backgroundColor = [UIColor grayColor];
    }

    
    _couponLabel.text = model.transfersTime;
    
}

@end

//
//  QueueTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/23.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "QueueTableViewCell.h"

@implementation QueueTableViewCell{
    UILabel * _statusLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _shopHeaderImage.layer.masksToBounds = YES;
    _shopHeaderImage.layer.cornerRadius = 15;
}
-(void)setModel:(AllcouponsModel *)model{
    _model = model;
    [_shopHeaderImage sd_setImageWithURL:[NSURL URLWithString:model.userPhoto] placeholderImage:[UIImage imageNamed:HaiduiUserImage]];
    
    _shopNumberLabel.text = model.ownerName;
    _storeNameLabel.text = model.merchantName;
    _couponPriceLabel.text =[NSString stringWithFormat:@"%ld",model.value];
        _contentLabel.text = [NSString stringWithFormat:@"序列号%ld号，当前排%ld位，还差%ld位返现",(long)model.propWeiInit,model.propWei, model.queueNum];
   

    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.queueTime/1000.f];
    NSString * dateStr = [format stringFromDate:date];
    _couponLabel.text = dateStr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  FacePayOrderTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "FacePayOrderTableViewCell.h"

@implementation FacePayOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderImageView.layer.masksToBounds = YES;
    self.orderImageView.layer.cornerRadius = 6;
}
-(void)setModel:(FaceToFaceOrderModel *)model{
    
    _model = model;
    self.storeName.text = model.storeName;
    
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:model.storeLogo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    self.orderPriceLabel.text =[NSString stringWithFormat:@"消费:￥%.2f",model.orderPrice ];
    self.orderNumber.text =[NSString stringWithFormat:@"订单号:%@", model.orderSn];
    self.adressLabel.text = model.storeArea;
    //订单状态
    if (model.status == 0) {
        
        _commontStatedLabel.text = @"未支付";
        
    }else if (model.status == 1 ){
        
        _commontStatedLabel.text = @"已付款";
        
    }
    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.orderCreateTime/1000.f];
    NSString * dateStr = [format stringFromDate:date];

    self.orderTime.text = dateStr;
    
}


@end

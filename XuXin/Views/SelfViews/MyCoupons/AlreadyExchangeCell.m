//
//  AlreadyExchangeCell.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "AlreadyExchangeCell.h"

@implementation AlreadyExchangeCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.borderView.layer.borderColor = UIColorFromHexValue(0xc4c4c4).CGColor;
    
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.masksToBounds = YES;
    self.borderView.layer.cornerRadius = 3;
  
    
    
}
-(void)setModel:(userListCouponModel *)model{
    
    _model = model;
    _storeNameLabel.text = model.merchantName;
//    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.exchangeTime/1000.f];
//    NSDate * date2 =[NSDate dateWithTimeIntervalSince1970:model.exchangeTime];
//    //领现时间
//    NSString * dateStr2 =[format stringFromDate:date2];
//    //排队时间
   NSString * dateStr = [format stringFromDate:date];
//    _datLabel.text = dateStr;
    _couponNumberLabel.text = model.cradName;
    _useCouponDateLabel.text =[NSString stringWithFormat:@"使用兑换券时间%@", dateStr];
    _priceValueLaebl.text =[NSString stringWithFormat:@"￥%ld",model.value];
    _originalLabel.text = [NSString stringWithFormat:@"%ld",model.propWeiInit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

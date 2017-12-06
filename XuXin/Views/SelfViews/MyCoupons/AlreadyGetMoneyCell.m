//
//  AlreadyGetMoneyCell.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "AlreadyGetMoneyCell.h"

@implementation AlreadyGetMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.liaghtGrayView.backgroundColor = UIColorFromHexValue(0xefefef);
    
    self.borderView.layer.masksToBounds = YES;
    self.borderView.layer.cornerRadius = 3;
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.borderColor = [UIColor colorWithHexString:@"d0ead3"].CGColor;
    
 //   self.borderView.backgroundColor = UIColorFromHexValue(0xe6e6e6);
    
}
-(void)setModel:(userListCouponModel *)model{
    _model = model;
    _storeNameLabel.text = model.merchantName;
//    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.queueTime/1000.f];
//    NSDate * date2 =[NSDate dateWithTimeIntervalSince1970:model.transfersTime];
    //领现时间
//    NSString * dateStr2 =[format stringFromDate:date2];
 //   NSString * dateStr = [format stringFromDate:date];
     //排队时间
 //   _dateLabel.text = dateStr;
    
    _couponNumberLabel.text = model.cradName;
    _compeletLabel.text =[NSString stringWithFormat:@"领现时间%@",model.transfersTime];
    _priceValueLabel.text =[NSString stringWithFormat:@"%ld",model.value];
    _oraignalLabel.text =[NSString stringWithFormat:@"%ld", model.propWeiInit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

@end

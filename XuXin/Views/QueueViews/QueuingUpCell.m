//
//  QueuingUpCell.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "QueuingUpCell.h"



@implementation QueuingUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    for (UILabel * label  in self.titleColor) {
//        label.textColor = UIColorFromHexValue(0xe66a73);
//    }
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.borderColor = UIColorFromHexValue(0xe55a76).CGColor;
    self.borderView.layer.masksToBounds = YES;
    self.borderView.layer.cornerRadius = 3;
  
 //   self.borderView.backgroundColor = UIColorFromHexValue(0xfce8ea);
    
//    self.bgView.backgroundColor = UIColorFromHexValue(0xefefef);
//
//    self.cutImageView.backgroundColor = [UIColor redColor];
    //    如果是大于5s的机型 一行显示

    
}
-(void)setModel:(userListCouponModel *)model{
    _model = model;
    _storeNameLabel.text = model.merchantName;
    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
  //  NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.queueEndTime/1000.f];
    NSDate * queueDate = [NSDate dateWithTimeIntervalSince1970:model.queueTime/1000.f];
 //   NSString * dateStr2 = [format stringFromDate:queueDate];
    NSString * dateStr = [format stringFromDate:queueDate];
   // 排队时间
   
    _couponNumberLabel.text = model.cradName;
    //排队完成时间
    _compeletDateLabel.text =[NSString stringWithFormat:@"排队完成时间%@",dateStr];
    _titleLabel.text =[NSString stringWithFormat:@"￥%ld",model.value];
    _orignalLabel.text = [NSString stringWithFormat:@"%ld",model.propWeiInit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

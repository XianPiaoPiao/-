//
//  CompletionQueueCell.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "CompletionQueueCell.h"

@interface CompletionQueueCell ()


@end

@implementation CompletionQueueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bluebottomBgView.backgroundColor = UIColorFromHexValue(0xdaeef8);
    _borderBgView.layer.borderColor = UIColorFromHexValue(0x4fa8e1).CGColor;
    _borderBgView.layer.borderWidth = 1;
    _borderBgView.layer.masksToBounds = YES;
    _borderBgView.layer.cornerRadius = 3;

//    如果是大于5s的机型  一行显示
    if (HalfOfScreenScale * 2 > 1) {
        self.dateLabel.numberOfLines = 1;
        self.dateLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    self.lightGrayView.backgroundColor = UIColorFromHexValue(0xefefef);
}

-(void)setModel:(userListCouponModel *)model{
    _model = model;
    _storeNameLabel.text = model.merchantName;
    
    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.queueTime/1000.f];
    NSString * dateStr = [format stringFromDate:date];
    _dateLabel.text = dateStr;
    
    _couponNumberLabel.text = model.cradName;
    _curentNumberLabel.text = [NSString stringWithFormat:@"%ld",model.propWei];
    _startNumberLabel.text = [NSString stringWithFormat:@"%ld",model.propWeiInit];
    //
    _couponStatusLabel.text = @"排队中";
    _manyqueueLabel.text = [NSString stringWithFormat:@"%ld",model.queueNum];
    _priceValueLabel.text =[NSString stringWithFormat:@"￥%ld",model.value];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

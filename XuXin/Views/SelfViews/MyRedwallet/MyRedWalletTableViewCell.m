//
//  MyRedWalletTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/10/22.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyRedWalletTableViewCell.h"

@implementation MyRedWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(RedWalletModel *)model{
    _model = model;
   // _userPhoneNumberLabel.text = [NSString stringWithFormat:@"仅限当前用户使用",[User defalutManager].userName];
    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.packet_ent_time/1000.f];
    NSString * dateStr = [format stringFromDate:date];

    NSDate * date2 = [NSDate dateWithTimeIntervalSince1970:model.end_time/1000.f];
    NSString * dateStr2 = [format stringFromDate:date2];

    _endTimeLabel.text = [NSString stringWithFormat:@"%@到期",dateStr];

    if (model.is_userd == 1) {
        
        _statementLabel.text= @"已使用";
        _endTimeLabel.text = [NSString stringWithFormat:@"%@使用",dateStr2];

    }else if(model.is_userd == 0){
        
        _statementLabel.text= @"未使用";

    }else{
        _statementLabel.text= @"已过期";

    }
}

@end

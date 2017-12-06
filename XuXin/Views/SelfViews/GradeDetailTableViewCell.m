//
//  GradeDetailTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "GradeDetailTableViewCell.h"

@implementation GradeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setSupendModel:(SupendDetailModel *)supendModel{
    _supendModel= supendModel;
    _addTimeLabel.text = supendModel.times;
    _orderNumberLbael.text =supendModel.log_info;
    if (supendModel.log_amount > 0) {
        
        _priceValueLabel.text =[NSString stringWithFormat:@"+%.2f",supendModel.log_amount];
        _priceValueLabel.textColor = [UIColor colorWithHexString:MainColor];
        
    }else{
        
         _priceValueLabel.text =[NSString stringWithFormat:@"%.2f",supendModel.log_amount];
        _priceValueLabel.textColor = [UIColor colorWithHexString:@"#1ac837"];
    }
    
    
}
-(CGFloat)getBalanceCellHeight:(BalanceDetailModel *)balanceModel{
    
    CGRect textRect = [balanceModel.describe boundingRectWithSize:CGSizeMake(ScreenW - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil];
    
   return  textRect.size.height + 40;
}
-(CGFloat)getSupendCellHeight:(SupendDetailModel *)supendModel{
    
    CGRect textRect = [supendModel.log_info boundingRectWithSize:CGSizeMake(ScreenW - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil];
    
    return  textRect.size.height + 40;
}
-(CGFloat)getPointCellHeight:(PointDetailModel *)pointModel{
    CGRect textRect = [pointModel.content boundingRectWithSize:CGSizeMake(ScreenW - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil];
    
    return  textRect.size.height + 40;
}
-(void)setBalanceModel:(BalanceDetailModel *)balanceModel{
    
    _balanceModel= balanceModel;
    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:balanceModel.addTime/1000.f];
    NSString * dateStr = [format stringFromDate:date];
    
    
    _addTimeLabel.text = dateStr;
    
    _orderNumberLbael.text =balanceModel.describe;
    if (balanceModel.price > 0) {
        _priceValueLabel.text =[NSString stringWithFormat:@"+%.2f",balanceModel.price];
        _priceValueLabel.textColor = [UIColor colorWithHexString:MainColor];
        
    }else{
        
        _priceValueLabel.text =[NSString stringWithFormat:@"%.2f",balanceModel.price];
        _priceValueLabel.textColor = [UIColor colorWithHexString:@"#1ac837"];
    }
    
    
}
-(void)setPointModel:(PointDetailModel *)pointModel{
    _pointModel = pointModel;
    _addTimeLabel.text = pointModel.addTime;
    _orderNumberLbael.text =pointModel.content;
    if (pointModel.integral > 0) {
        
         _priceValueLabel.text =[NSString stringWithFormat:@"+%ld",pointModel.integral];
        _priceValueLabel.textColor = [UIColor colorWithHexString:MainColor];
        
    }else{
         _priceValueLabel.text =[NSString stringWithFormat:@"%ld",pointModel.integral];
        _priceValueLabel.textColor = [UIColor colorWithHexString:@"#1ac837"];
    }
   
    
}
@end

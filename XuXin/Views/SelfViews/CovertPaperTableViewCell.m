//
//  CovertPaperTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CovertPaperTableViewCell.h"

@implementation CovertPaperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(CouponnsModel *)model{
    
    _model = model;
    
    _postionNumberLbael.text =[NSString stringWithFormat:@"第%ld位", model.prop_wei];
    
    _couponsNumberLabel.text = model.card_name;
    
    _priceNumberLabel.text =[NSString stringWithFormat:@"%ld", model.value];
  
    if (model.isSelected == YES) {
        _selectedStateBtn.selected = YES;
    }else{
        _selectedStateBtn.selected = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

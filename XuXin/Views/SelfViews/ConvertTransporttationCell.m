//
//  ConvertTransporttationCell.m
//  XuXin
//
//  Created by xuxin on 17/2/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ConvertTransporttationCell.h"

@implementation ConvertTransporttationCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
 
    
   // self.contextLabel.insets = UIEdgeInsetsMake(0, 10, 0, 5);
   
    
}
-(CGFloat)getPointCellHeight:(ConvertTransportationModel *)pointModel{
    
    CGRect textRect = [pointModel.context boundingRectWithSize:CGSizeMake(ScreenW - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil];
    
    return  textRect.size.height + 60;
}
-(void)setModel:(ConvertTransportationModel *)model{
    
    _model = model;
    _contextLabel.text = model.context;
    _timeLabel.text = model.time;
    
    //整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contextLabel.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contextLabel.text length])];
    self.contextLabel.attributedText = attributedString;
    
    [self.contextLabel sizeToFit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

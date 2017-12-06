//
//  MessageTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(CGFloat)getPointCellHeight:(MessageListModel *)pointModel{
    //有行间距的计算方式
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:4];
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style};
    
    CGRect textRect = [pointModel.content boundingRectWithSize:CGSizeMake(ScreenW - 65, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    return  textRect.size.height + 100;
}
-(void)setModel:(MessageListModel *)model{
    
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    
    if (model.type == 0) {
        
        [_titleImageView setImage:[UIImage imageNamed:@"systemMessage"]];
        
    }else if (model.type == 1){
        [_titleImageView setImage:[UIImage imageNamed:@"message"]];

    }else if (model.type ==2){
        [_titleImageView setImage:[UIImage imageNamed:@"aboutMoney"]];

    }else if (model.type == 3){
        [_titleImageView setImage:[UIImage imageNamed:@"transCar"]];

    }else if (model.type == 4){
        [_titleImageView setImage:[UIImage imageNamed:@"communite"]];

    }
    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    [format setTimeStyle:NSDateFormatterShortStyle];
    
     [format setDateFormat:@"yyyy年MM月dd日"];

    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.addTime];
    
    NSString * dateStr = [format stringFromDate:date];
    
    _dateLabel.text = dateStr;
    
    
    //整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contentLabel.text length])];
    self.contentLabel.attributedText = attributedString;
    
    [self.contentLabel sizeToFit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

@end

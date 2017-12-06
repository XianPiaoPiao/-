//
//  UserCommentsCell.m
//  XuXin
//
//  Created by xuxin on 17/3/8.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "UserCommentsCell.h"

@implementation UserCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userHeadereImage.layer.masksToBounds = YES;
    self.userHeadereImage.layer.cornerRadius = 20;
}

-(CGFloat)getPointCellHeight:(UserCommentsModel *)commentModel{
    
    CGRect textRect = [commentModel.evaluate_info boundingRectWithSize:CGSizeMake(ScreenW - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil];
    
    return  textRect.size.height + 100;
}
-(void)setCommentsModel:(UserCommentsModel *)model{
    
    _commentsModel = model;
    
    if (model.content.length > 0) {
        
        _contentLabel.text = model.content;


    }else{
        _contentLabel.text = @"此用户没有填写评价";

    }
    
    //时间戳转时间
  //  NSDateFormatter * format = [[NSDateFormatter alloc] init];
  //  [format setDateFormat:@"yyyyMMdd"];
 //   [format setDateStyle:NSDateFormatterMediumStyle];
    
  
    
    _addTimeLabel.text = model.evaluationTime;
    
    _userNameLabel.text =model.appraiser;
    
    _startsView.starValue = (model.describe + model.service + model.deliverySpeed)/3;
    
    [_userHeadereImage sd_setImageWithURL:[NSURL URLWithString:model.userPhoto] placeholderImage:[UIImage imageNamed:HaiduiUserImage]];
    
    //整行间距
    if (self.contentLabel.text) {
        
         NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:4];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contentLabel.text length])];
        self.contentLabel.attributedText = attributedString;
        
        [self.contentLabel sizeToFit];
    }
 
}
-(void)setGoodsModel:(UserCommentsModel *)goodsModel{
    
    if (goodsModel.evaluate_info.length > 0) {
        
        _contentLabel.text = goodsModel.evaluate_info;

    }else{
        
        _contentLabel.text = @"此用户没有填写评价";

    }
    
    _addTimeLabel.text = goodsModel.addTime;
    
    _userNameLabel.text =goodsModel.userName;
    
 //   _startsView.starValue = (model.describe + model.service + model.deliverySpeed)/3;
    
    [_userHeadereImage sd_setImageWithURL:[NSURL URLWithString:goodsModel.userPhoto] placeholderImage:[UIImage imageNamed:HaiduiUserImage]];
    
    //整行间距
    if (self.contentLabel.text) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:4];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contentLabel.text length])];
        self.contentLabel.attributedText = attributedString;
        
        [self.contentLabel sizeToFit];
    }
    
}
@end

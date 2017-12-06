//
//  MyBankCardCell.m
//  XuXin
//
//  Created by xuxin on 16/10/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyBankCardCell.h"

@implementation MyBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 6;
}
-(void)setModel:(MyBankModel *)model{
    _model = model;
    _bankNameLabel.text = model.bank.name;
    
    if (model.id == 11) {
        
        _cardNUmberLabel.text =[NSString stringWithFormat:@"**** **** **** %@",model.bankCard];
        
    }else{
        
        if ([model.bankCard containsString:@"@"] == YES) {
            
            NSArray * array = [model.bankCard componentsSeparatedByString:@"@"];
            NSString * str2 = array[array.count - 1];
            
            NSString * str = array[0];
            NSString * fstr =  [str substringWithRange:NSMakeRange(0, 1)];
            NSString * endStr = [str substringWithRange:NSMakeRange(str.length - 1, 1)];
            _cardNUmberLabel.text =[NSString stringWithFormat:@"%@ **** **** %@@%@",fstr,endStr,str2];
            
            
        }else{
            NSString * str = [model.bankCard substringWithRange:NSMakeRange(0, 3)];
            NSString * str2= [model.bankCard substringWithRange:NSMakeRange(model.bankCard.length - 4, 4)];
            
            _cardNUmberLabel.text =[NSString stringWithFormat:@"%@ **** %@",str,str2];
            
        }
}
    [_cardImageView sd_setImageWithURL:[NSURL URLWithString:model.bank.logoPath] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

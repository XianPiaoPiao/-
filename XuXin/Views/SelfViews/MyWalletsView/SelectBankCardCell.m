//
//  SelectBankCardCell.m
//  XuXin
//
//  Created by xuxin on 16/11/2.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SelectBankCardCell.h"

@implementation SelectBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(MyBankModel *)model{
    _model = model;
    _bankNameLabel.text = model.bank.name;
    [_bankLogImageView sd_setImageWithURL:[NSURL URLWithString:model.bank.logoPath] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    
    if (model.id == 11) {
        
        _bankCardNumberLabel.text =[NSString stringWithFormat:@"**** **** **** %@",model.bankCard];
        
    }else{
        
        if ([model.bankCard containsString:@"@"] == YES) {
            
         NSArray * array = [model.bankCard componentsSeparatedByString:@"@"];
         NSString * str2 = array[array.count - 1];
            
            NSString * str = array[0];
            NSString * fstr =  [str substringWithRange:NSMakeRange(0, 1)];
            NSString * endStr = [str substringWithRange:NSMakeRange(str.length - 1, 1)];
            _bankCardNumberLabel.text =[NSString stringWithFormat:@"%@ **** **** %@@%@",fstr,endStr,str2];
 
            
        }else{
            NSString * str = [model.bankCard substringWithRange:NSMakeRange(0, 3)];
            NSString * str2= [model.bankCard substringWithRange:NSMakeRange(model.bankCard.length - 4, 4)];
            
            _bankCardNumberLabel.text =[NSString stringWithFormat:@"%@ **** %@",str,str2];

        }
        
    }
}
@end

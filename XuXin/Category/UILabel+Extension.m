//
//  UILabel+Extension.m
//  LabelExtension
//
//  Created by apple on 2017/9/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

-(void)labelWithIntegral:(NSInteger)integral money:(CGFloat)money{
    if (money>0) {
        NSMutableAttributedString *start = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%li",integral]];
        [self attribute:start color:[UIColor colorWithHexString:MainColor] font:[UIFont systemFontOfSize:14]];
        
        NSMutableAttributedString *end = [[NSMutableAttributedString alloc]initWithString:@"积分 +"];
        [self attribute:end color:[UIColor colorWithHexString:MainColor] font:[UIFont systemFontOfSize:9]];
        
        NSMutableAttributedString *start1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",money]];
        [self attribute:start1 color:[UIColor colorWithHexString:MainColor] font:[UIFont systemFontOfSize:14]];//red
        
        NSMutableAttributedString *end1 = [[NSMutableAttributedString alloc]initWithString:@"元"];
        [self attribute:end1 color:[UIColor colorWithHexString:MainColor] font:[UIFont systemFontOfSize:9]];//red
        
        [start appendAttributedString:end];
        [start appendAttributedString:start1];
        [start appendAttributedString:end1];
        
        self.attributedText = start;
        
    }else{
        NSMutableAttributedString *start = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%li",integral]];
        [self attribute:start color:[UIColor colorWithHexString:MainColor] font:[UIFont systemFontOfSize:14]];
        
        NSMutableAttributedString *end = [[NSMutableAttributedString alloc]initWithString:@"积分"];
        [self attribute:end color:[UIColor colorWithHexString:MainColor] font:[UIFont systemFontOfSize:9]];
        
        [start appendAttributedString:end];
        
        self.attributedText = start;
    }
}

-(void)attribute:(NSMutableAttributedString *)attribute color:(UIColor *)color font:(UIFont *)font{
    [attribute  addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attribute.length)];
    [attribute  addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attribute.length)];
}

@end

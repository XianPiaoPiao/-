//
//  FirstInformationTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "FirstInformationTableViewCell.h"
#import "ChampionBaseViewController.h"
@implementation FirstInformationTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
  //  self.moneyLabel.layer.masksToBounds  = YES;
  //  self.moneyLabel.layer.cornerRadius = 4;
   // self.ManLabel.layer.masksToBounds = YES;
   // self.ManLabel.layer.cornerRadius = 4;
    self.ChampionBtton.layer.cornerRadius = 3;
}
-(void)setModel:(RankingModel *)model{
    
   
    
    
}
@end

//
//  FirstInformationTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"
@interface FirstInformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateChampinLabel;
@property (weak, nonatomic) IBOutlet UIButton *ChampionBtton;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic ,strong)RankingModel * model;
@end

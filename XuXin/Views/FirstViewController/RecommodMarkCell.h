//
//  RecommodMarkCell.h
//  XuXin
//
//  Created by xuxin on 16/8/12.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recmondShopModel.h"
@interface RecommodMarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ConstantImageView;
@property (weak, nonatomic) IBOutlet UILabel *ConstantLabel;
@property (weak, nonatomic) IBOutlet UILabel *ConsumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *DoLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CharcterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyNuberLabel;
@property (nonatomic ,strong)recmondShopModel * model;
@end

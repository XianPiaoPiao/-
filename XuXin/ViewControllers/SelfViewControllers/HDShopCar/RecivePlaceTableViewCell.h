//
//  RecivePlaceTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/10/14.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "receivePlaceModel.h"
@interface RecivePlaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivePlaceLabel;
@property (weak, nonatomic) IBOutlet UIButton *setAdressBtn;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (nonatomic,strong)receivePlaceModel * model;
@property (weak, nonatomic) IBOutlet UIButton *eidcBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end

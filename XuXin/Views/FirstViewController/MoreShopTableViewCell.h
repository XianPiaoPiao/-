//
//  MoreShopTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/16.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreShopModel.h"
#import "StarsView.h"
@interface MoreShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic ,strong)MoreShopModel * model;

@end

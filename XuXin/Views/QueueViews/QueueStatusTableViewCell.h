//
//  QueueStatusTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/11/5.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllcouponsModel.h"

@interface QueueStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopHeaderImage;
@property (nonatomic ,strong)AllcouponsModel * model;
@end

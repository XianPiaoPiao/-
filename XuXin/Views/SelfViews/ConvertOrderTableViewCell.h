//
//  ConvertOrderTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvertOrderModel.h"
#import "OnlineOrderModel.h"
@interface ConvertOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *metureLabel;


@property (nonatomic,strong)ConvertOrderModel * model;
@property (nonatomic,strong)OnlineOrderModel * orderModel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberMuchLabel;
@end

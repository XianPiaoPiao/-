//
//  CovertGradeAndQueueSendTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "convertDetailModel.h"
@interface CovertGradeAndQueueSendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstant;

@property (weak, nonatomic) IBOutlet UILabel *goodsPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkTransportBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureRecieveGoodsBtn;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;

@property (nonatomic ,strong)UIButton * payQuklyFeeBtn;
@property (nonatomic ,strong)UIButton * cancelOrderBtn;

@property (nonatomic ,strong)UIButton * payOrderBtn;
@property (nonatomic ,strong)UIButton * deleteOrderBtn;
@property (nonatomic ,strong)convertDetailModel * model;
@end

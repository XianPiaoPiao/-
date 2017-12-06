//
//  GradeDetailTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceDetailModel.h"
#import "PointDetailModel.h"
#import "SupendDetailModel.h"
@interface GradeDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLbael;
@property (weak, nonatomic) IBOutlet UILabel *priceValueLabel;
@property (nonatomic ,strong)BalanceDetailModel * balanceModel;
@property (nonatomic ,strong)PointDetailModel * pointModel;
@property (nonatomic ,strong)SupendDetailModel * supendModel;

-(CGFloat)getSupendCellHeight:(SupendDetailModel *)supendModel;
-(CGFloat)getPointCellHeight:(PointDetailModel *)pointModel;
-(CGFloat)getBalanceCellHeight:(BalanceDetailModel *)balanceModel;


@end

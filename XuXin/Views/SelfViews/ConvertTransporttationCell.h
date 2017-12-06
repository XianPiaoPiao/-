//
//  ConvertTransporttationCell.h
//  XuXin
//
//  Created by xuxin on 17/2/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetLabel.h"
#import "ConvertTransportationModel.h"
@interface ConvertTransporttationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (weak, nonatomic) IBOutlet InsetLabel *contextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic ,strong)ConvertTransportationModel * model;
-(CGFloat)getPointCellHeight:(ConvertTransportationModel *)pointModel;
@end

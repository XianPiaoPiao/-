//
//  CovertRecordTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/23.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntergerGoodsDetailModel.h"
@interface CovertRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userNmaeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *CovertDateLabel;
@property (nonatomic ,strong)Exchangerecord * recordModel;
@end

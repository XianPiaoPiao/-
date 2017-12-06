//
//  CovertPaperTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponnsModel.h"
@interface CovertPaperTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postionNumberLbael;
@property (weak, nonatomic) IBOutlet UILabel *couponsNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedStateBtn;

@property (nonatomic ,strong)CouponnsModel * model;
@property (weak, nonatomic) IBOutlet UILabel *priceNumberLabel;
@end

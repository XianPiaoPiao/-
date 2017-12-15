//
//  StoreCouponTableViewCell.h
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StoreCouponModel;

@interface StoreCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCouponButton;
@property (nonatomic, copy) StoreCouponModel *model;
@end

//
//  ChooseCouponTableViewCell.h
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCouponModel.h"

@interface ChooseCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (nonatomic, copy) void (^selectedCheckBtnBlock)(StoreCouponModel *);
@property (nonatomic, copy) StoreCouponModel *model;
@end

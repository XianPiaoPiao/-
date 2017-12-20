//
//  MyCouponTableViewCell.h
//  XuXin
//
//  Created by xian on 2017/12/14.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *useButton;
@end

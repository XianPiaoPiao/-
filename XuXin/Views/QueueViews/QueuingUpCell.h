//
//  QueuingUpCell.h
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userListCouponModel.h"
@interface QueuingUpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orignalLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleColor;

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *couponNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *compeletDateLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *cutImageView;

@property(nonatomic ,strong)userListCouponModel * model;
@end

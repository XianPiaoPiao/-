//
//  CompletionQueueCell.h
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userListCouponModel.h"
@interface CompletionQueueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *manyqueueLabel;

@property (weak, nonatomic) IBOutlet UILabel *startNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *curentNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *lightGrayView;
@property (weak, nonatomic) IBOutlet UILabel *couponNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceValueLabel;

@property (weak, nonatomic) IBOutlet UIView *borderBgView;

@property (weak, nonatomic) IBOutlet UIView *bluebottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *couponStatusLabel;

@property(nonatomic ,strong)userListCouponModel * model;
@end

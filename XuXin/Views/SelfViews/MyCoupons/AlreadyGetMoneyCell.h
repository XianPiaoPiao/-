//
//  AlreadyGetMoneyCell.h
//  Voucher
//
//  Copyright r© 2016年 UninhibitedSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userListCouponModel.h"
@interface AlreadyGetMoneyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *borderView;

@property (weak, nonatomic) IBOutlet UILabel *compeletLabel;
@property (weak, nonatomic) IBOutlet UILabel *oraignalLabel;


@property (weak, nonatomic) IBOutlet UIView *liaghtGrayView;

@property (nonatomic ,strong)userListCouponModel * model;
@end

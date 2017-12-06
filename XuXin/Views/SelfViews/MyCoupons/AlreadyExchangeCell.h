//
//  AlreadyExchangeCell.h
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userListCouponModel.h"
@interface AlreadyExchangeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lightGrayView;

@property (weak, nonatomic) IBOutlet UILabel *originalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cutImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceValueLaebl;

@property (weak, nonatomic) IBOutlet UILabel *couponNumberLabel;



@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *useCouponDateLabel;


@property (weak, nonatomic) IBOutlet UIView *borderView;

@property (nonatomic ,strong)userListCouponModel * model;
@end

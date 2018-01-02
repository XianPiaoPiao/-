//
//  SearchTheStoreViewController.h
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"
typedef void (^storeIdBlock)(NSString * storeID,NSString * storeName);

@interface SearchTheStoreViewController : BaseViewContrlloer
@property (nonatomic ,copy)storeIdBlock block;
@end

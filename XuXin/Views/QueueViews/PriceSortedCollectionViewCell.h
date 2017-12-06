//
//  PriceSortedCollectionViewCell.h
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CellType) {
    CellTypeOne,
    CellTypeTwo
};

@interface PriceSortedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@property (nonatomic,assign) CellType cellType;

@end

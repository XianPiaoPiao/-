//
//  PriceSortedCollectionViewCell.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "PriceSortedCollectionViewCell.h"

@interface PriceSortedCollectionViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingTheImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingTheBorderViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderViewCenterXConstraint;

@end
@implementation PriceSortedCollectionViewCell

-(void)setCellType:(CellType)cellType{
    switch (cellType) {
        case CellTypeOne:
            self.titleLeadingTheImageConstraint.constant = 5;
            break;
            
        case CellTypeTwo:
            self.titleLeadingTheImageConstraint.constant = 19;
            self.imageViewLeadingTheBorderViewConstraint.constant = 11;
            self.borderViewCenterXConstraint.constant = -ScreenW/3.0f;
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

@end

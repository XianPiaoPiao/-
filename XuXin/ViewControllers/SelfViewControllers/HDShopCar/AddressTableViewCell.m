//
//  AddressTableViewCell.m

//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.//
//

#import "AddressTableViewCell.h"
#import "AddressItemModel.h"

@interface AddressTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;

@end

@implementation AddressTableViewCell

#pragma mark - 重写set方法，为cell中的属性赋值
//- (void)setItemlModel:(AddressItemModel *)itemlModel{
//    
//}

-(void)initUI:(AddressItemModel *)itemlModel{
    _itemlModel = itemlModel;
    
    _addressLabel.text = itemlModel.name;
    
    //三目运算。
    _addressLabel.textColor = itemlModel.isSelected ? [UIColor orangeColor] : [UIColor blackColor];
    
    _selectedImg.hidden = !itemlModel.isSelected;
}

//- (void)awakeFromNib {
//    // Initialization code
//    [super awakeFromNib];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

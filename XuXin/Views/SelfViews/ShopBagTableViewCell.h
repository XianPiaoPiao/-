//
//  ShopBagTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDShopCarModel.h"
#import "GroupGoodsMOdel.h"
#import "HDCarNumberCOunt.h"

@interface ShopBagTableViewCell : UITableViewCell



@property (nonatomic, strong) HDShopCarModel *model;
@property (nonatomic, strong) GroupGoodsMOdel *onlineModel;

@property (weak, nonatomic) IBOutlet HDCarNumberCOunt *selfStepperView;

@property (weak, nonatomic) IBOutlet UIImageView *shopBagImageView;
@property (weak, nonatomic) IBOutlet UILabel *metureLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

+ (CGFloat)getCartCellHeight;

@end

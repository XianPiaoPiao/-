//
//  AllShopTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/16.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopListDetailModel.h"
#import "recmondShopModel.h"
#import "StarsView.h"
@interface AllShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLbel;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UILabel *constantLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet StarsView *startView;
@property (nonatomic ,strong)shopListDetailModel * model;
@property (nonatomic, strong) recmondShopModel *recmondModel;
@end

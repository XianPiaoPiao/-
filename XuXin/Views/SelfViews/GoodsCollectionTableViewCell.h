//
//  GoodsCollectionTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/27.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCollectionsModel.h"
#import "StarsView.h"
@interface GoodsCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet StarsView *starsView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic ,strong)StoreCollectionsModel * ShopModel;
@end

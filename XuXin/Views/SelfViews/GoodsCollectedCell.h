//
//  GoodsCollectedCell.h
//  XuXin
//
//  Created by xuxin on 16/12/5.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntergralModel.h"

@interface GoodsCollectedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (nonatomic ,strong)IntergralModel * GoodsModel;

@end

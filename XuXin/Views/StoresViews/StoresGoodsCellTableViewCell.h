//
//  StoresGoodsCellTableViewCell.h
//  hidui
//
//  Created by xuxin on 17/1/17.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupGoodsMOdel.h"
#import "OnlineGoodsModel.h"
@interface StoresGoodsCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLbael;
@property (nonatomic ,strong)GroupGoodsMOdel * groupModel;
@property (nonatomic ,strong)ONLINEgoodsModel * onlineGoodsModel;
@end

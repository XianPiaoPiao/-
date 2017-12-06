//
//  OrderDerailTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "convertDetailModel.h"
#import "intergralGoodsModel.h"
#import "OnlineGoodsModel.h"
@interface OrderDerailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *ConvertNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *pointTotalLabel;
@property (nonatomic,strong)intergralGoodsModel * model;
@property (nonatomic,strong)ONLINEgoodsModel * goodsModel;
@property (weak, nonatomic) IBOutlet UILabel *metureLabel;

@end

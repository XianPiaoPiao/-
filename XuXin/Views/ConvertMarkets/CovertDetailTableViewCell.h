//
//  CovertDetailTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntergerGoodsDetailModel.h"
#import "ConvertGoodsCellModel.h"
#import "StarsView.h"
@interface CovertDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *saleNumberLabel;
@property (weak, nonatomic) IBOutlet StarsView *starsView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNumberLabel;
@property (nonatomic ,strong) Recommendgoods * goodsModel;

@property (nonatomic ,strong)ConvertGoodsCellModel * convertModel;
@end

//
//  CovertDetailTVCell.h
//  XuXin
//
//  Created by xian on 2017/9/21.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntergerGoodsDetailModel.h"
#import "ConvertGoodsCellModel.h"

@interface CovertDetailTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *gspDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (nonatomic ,strong) Recommendgoods * goodsModel;
@property (nonatomic ,strong)ConvertGoodsCellModel * convertModel;


@end

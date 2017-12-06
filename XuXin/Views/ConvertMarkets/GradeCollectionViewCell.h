//
//  GradeCollectionViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvertGoodsCellModel.h"
@interface GradeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsGradeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (nonatomic ,strong)ConvertGoodsCellModel * model;
@end

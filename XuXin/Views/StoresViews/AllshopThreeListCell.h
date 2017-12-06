//
//  AllshopThreeListCell.h
//  XuXin
//
//  Created by xuxin on 16/9/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListModel.h"

@interface AllshopThreeListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong)Result * model;
@end

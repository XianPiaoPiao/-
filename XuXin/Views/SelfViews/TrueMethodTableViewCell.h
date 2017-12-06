//
//  TrueMethodTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrueMethodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *TrueMethodHeadImage;
@property (weak, nonatomic) IBOutlet UIImageView *trueMethodStateImage;
@property (weak, nonatomic) IBOutlet UILabel *PayMethodLabel;
@property (nonatomic ,assign)BOOL isSelected;
@end

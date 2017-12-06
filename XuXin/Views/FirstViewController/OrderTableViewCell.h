//
//  OrderTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/17.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *HeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *ImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *SmallLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SmallImage;

@end

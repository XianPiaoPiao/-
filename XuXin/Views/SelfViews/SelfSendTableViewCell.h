//
//  SelfSendTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/9/1.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfSendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImageState;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic ,assign)BOOL isSelect;

@end

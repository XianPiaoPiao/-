//
//  PhoneTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/21.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *placeView;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end

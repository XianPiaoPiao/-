//
//  SpecialTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/15.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *monneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *scanErcodePayBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *joinHaiduiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *delegeteImageView;

@end

//
//  MyBankCardCell.h
//  XuXin
//
//  Created by xuxin on 16/10/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBankModel.h"
@interface MyBankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNUmberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property(nonatomic ,strong)MyBankModel * model;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

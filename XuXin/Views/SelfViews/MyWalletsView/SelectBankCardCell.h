//
//  SelectBankCardCell.h
//  XuXin
//
//  Created by xuxin on 16/11/2.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBankModel.h"
@interface SelectBankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankLogImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumberLabel;
@property (nonatomic ,strong)MyBankModel * model;
@end

//
//  VoucherTableViewCell.h
//  XuXin
//
//  Created by xian on 2017/11/6.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoucherModel;
@interface VoucherTableViewCell : UITableViewCell
///面额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
///编号
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
///序号
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic, copy) void (^selectedCheckBtnBlock)(VoucherModel *);

@property (nonatomic, copy) VoucherModel *model;

@end

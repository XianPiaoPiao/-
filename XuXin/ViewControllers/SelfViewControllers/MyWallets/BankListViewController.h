//
//  BankListViewController.h
//  XuXin
//
//  Created by xuxin on 16/10/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
#import "BankListModel.h"

typedef void (^bankIdBlock)(BankListModel * model);

@interface BankListViewController : BaseViewContrlloer

@property (nonatomic ,copy)bankIdBlock block;

@end

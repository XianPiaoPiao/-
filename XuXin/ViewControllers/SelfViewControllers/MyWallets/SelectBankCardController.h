//
//  SelectBankCardController.h
//  XuXin
//
//  Created by xuxin on 16/11/2.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
#import "MyBankModel.h"

typedef void (^bankIdBlock)(MyBankModel * model);

@interface SelectBankCardController : BaseViewContrlloer
@property (nonatomic ,copy)bankIdBlock block;
@end

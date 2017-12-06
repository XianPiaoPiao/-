//
//  CheckVoucherViewController.h
//  XuXin
//
//  Created by xian on 2017/11/7.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface CheckVoucherViewController : BaseViewContrlloer

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, copy) NSString *ID;

//@property (nonatomic, copy) NSMutableArray *voucherArray;

@property (nonatomic, copy) void(^cancelBtnBlock)(BOOL);

@property (nonatomic, copy) void(^sureBtnBlock)(NSMutableArray *);

@end

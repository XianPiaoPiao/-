//
//  OnlineShopCsarController.h
//  XuXin
//
//  Created by xuxin on 17/3/15.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
@class JSCartViewModel,JSCartUIService,HDCarBar;

@interface OnlineShopCsarController : BaseViewContrlloer

@property (nonatomic ,strong)NSMutableArray * onlineGoodsArray;
@property (nonatomic, strong) JSCartViewModel * viewModel;
@property (nonatomic, strong) JSCartUIService *service;
@property (nonatomic, strong) HDCarBar  *cartBar;
@property (nonatomic, strong) UITableView *cartTableView;
@property (nonatomic ,strong)UIView * edictBotomView;
@property (nonatomic ,assign)NSInteger shopCarType;


@end

//
//  JSCartUIService.h
//  JSShopCartModule
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSCartViewModel.h"
#import "BaseViewContrlloer.h"
@interface JSCartUIService : BaseViewContrlloer<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JSCartViewModel *viewModel;
@property (nonatomic ,strong)NSMutableArray   *   goodsSelectArray;

@property (nonatomic ,strong)NSMutableArray   *   storesSelectArray;

@property (nonatomic ,copy)NSString * storeId;
@property (nonatomic ,assign)NSInteger lastCellIndex;
@property (nonatomic ,assign)NSInteger willSelectedCellIndex;

@property (nonatomic ,assign)NSInteger currentNumber;

@end

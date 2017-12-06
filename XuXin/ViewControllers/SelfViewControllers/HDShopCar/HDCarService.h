//
//  HDCarService.h
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDCarViewModel.h"
#import "BaseViewContrlloer.h"
@interface HDCarService : BaseViewContrlloer <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HDCarViewModel * viewModel;
//选中商品的数组
@property (nonatomic ,strong)NSMutableArray   *   goodsSelectArray;

@property (nonatomic ,strong)NSMutableArray   *   storesSelectArray;

@end

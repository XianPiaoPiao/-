//
//  HDCarViewModel.h
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewContrlloer.h"

@class HDshopCarViewController;
@interface HDCarViewModel : BaseViewContrlloer
@property (nonatomic, strong) NSMutableArray * cartData;
@property (nonatomic ,strong) NSMutableArray *  storeArray;

@property (nonatomic, weak  ) HDshopCarViewController * cartVC;


@property (nonatomic, weak  ) UITableView          *cartTableView;
//选中商店的数组
@property (nonatomic, strong) NSMutableArray       *shopSelectArray;

/**
 *  carbar 观察的属性变化
 */
@property (nonatomic, assign) float                 allPrices;
@property (nonatomic, assign) float                 allIntegrals;
/**
 *  carbar 全选的状态
 */
@property (nonatomic, assign) BOOL                   isSelectAll;
//- (void)getData;
//全选
- (void)selectAll:(BOOL)isSelect;
//row select
- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath;
//row change quantity
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath;
//获取价格
- (float)getAllPrices;
//获取积分
- (float)getAllIntegrals;

@end

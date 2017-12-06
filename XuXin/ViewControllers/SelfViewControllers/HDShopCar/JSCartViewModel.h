//
//  JSCartViewModel.h
//  JSShopCartModule
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlineShopCsarController.h"

@interface JSCartViewModel : NSObject

@property (nonatomic, strong) NSMutableArray       *cartData;

@property (nonatomic ,strong)OnlineShopCsarController * carVC;

@property (nonatomic, weak  ) UITableView          *cartTableView;
/**
 *  存放店铺选中
 */
@property (nonatomic ,strong) NSMutableArray *  storeArray;

@property (nonatomic, strong) NSMutableArray       *shopSelectArray;
/**
 *  carbar 观察的属性变化
 */
@property (nonatomic, assign) float                 allPrices;
/**
 *  carbar 全选的状态
 */
@property (nonatomic, assign) BOOL                   isSelectAll;
//全选
- (void)selectAll:(BOOL)isSelect;
//row select
- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath;
//row change quantity
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath;
//获取价格
- (float)getAllPrices;

@end

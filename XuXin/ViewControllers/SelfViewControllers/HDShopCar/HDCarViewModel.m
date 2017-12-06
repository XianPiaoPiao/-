//
//  HDCarViewModel.m
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//
//


#import "HDCarViewModel.h"
#import "HDShopCarModel.h"

@interface HDCarViewModel(){
    
    NSArray *_shopGoodsCount;
    NSArray *_goodsPicArray;
    NSArray *_goodsPriceArray;
    NSArray *_goodsQuantityArray;
    
}
@end

@implementation HDCarViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //

    }
    return self;
}

- (NSInteger)random{
    
    NSInteger from = 0;
    NSInteger to   = 5;
    
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
    
}

-(NSMutableArray *)storeArray{
    if (!_storeArray) {
        _storeArray = [[NSMutableArray alloc] init];
    }
    return _storeArray;
}
- (float)getAllPrices{
    
    __block float allPrices = 0;
    
    NSInteger shopCount = self.cartData.count;
    
    NSInteger shopSelectCount = self.shopSelectArray.count;
    
    if (shopSelectCount == shopCount && shopCount!=0) {
        self.isSelectAll = YES;
    }
    NSArray *pricesArray = [[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
        return [[[value rac_sequence] filter:^BOOL(HDShopCarModel *model) {
            if (!model.isSelect) {
                self.isSelectAll = NO;
            }
            return model.isSelect;
        }] map:^id(HDShopCarModel *model) {
            
            
            return @(model.count *model.price);
        }];
    }] array];
    for (NSArray *priceA in pricesArray) {
        for (NSNumber *price in priceA) {
            
            allPrices += price.floatValue;
        }
    }
    
    return allPrices;
}

- (float)getAllIntegrals{
    __block float allIntegrals = 0;
    
    NSInteger shopCount = self.cartData.count;
    
    NSInteger shopSelectCount = self.shopSelectArray.count;
    
    if (shopSelectCount == shopCount && shopCount!=0) {
        self.isSelectAll = YES;
    }
    NSArray *integralsArray = [[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
        return [[[value rac_sequence] filter:^BOOL(HDShopCarModel *model) {
            if (!model.isSelect) {
                self.isSelectAll = NO;
            }
            return model.isSelect;
        }] map:^id(HDShopCarModel *model) {
            
            
            return @(model.count *model.ig_goods_integral);
        }];
    }] array];
    for (NSArray *integralA in integralsArray) {
        for (NSNumber *intrgral in integralA) {
            
            allIntegrals += intrgral.floatValue;
        }
    }
    
    return allIntegrals;
}

- (void)selectAll:(BOOL)isSelect{
    
    __block float allPrices = 0;
    __block float allIntrgrals = 0;
    
    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence] map:^id(NSNumber *value) {
        
        return @(isSelect);
        
    }] array] mutableCopy];
    
    self.cartData = [[[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
        return  [[[[value rac_sequence] map:^id(HDShopCarModel *model) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
            if (model.isSelect) {
                
                allPrices += model.count * model.price;
                allIntrgrals += model.count * model.ig_goods_integral;
            }
            return model;
        }] array] mutableCopy];
    }] array] mutableCopy];
    self.allPrices = allPrices;
    self.allIntegrals = allIntrgrals;
    [self.cartTableView reloadData];
    
}

- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath{
    
    
    NSInteger section = indexPath.section;
    
    NSInteger row = indexPath.row;
    
    NSMutableArray *goodsArray = self.cartData[section];
    
    NSInteger shopCount = goodsArray.count;
    
    HDShopCarModel *model = goodsArray[row];

    [model setValue:@(isSelect) forKey:@"isSelect"];
    //判断是都到达足够数量
    NSInteger isSelectShopCount = 0;
    for (HDShopCarModel *model in goodsArray) {
        if (model.isSelect) {
            
        isSelectShopCount++;
            
        }
    }
    [self.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelectShopCount==shopCount?YES:NO)];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    self.allPrices = [self getAllPrices];
    self.allIntegrals = [self getAllIntegrals];
    
}
//数量选则
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    HDShopCarModel * model = self.cartData[section][row];
    
    [model setValue:@(quantity) forKey:@"count"];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    self.allPrices = [self getAllPrices];
    self.allIntegrals = [self getAllIntegrals];
}

@end

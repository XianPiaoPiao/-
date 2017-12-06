//
//  JSCartViewModel.m
//  JSShopCartModule
//

//

#import "JSCartViewModel.h"
#import "HDShopCarModel.h"

@interface JSCartViewModel (){
    
    
}
//随机获取店铺下商品数
@property (nonatomic, assign) NSInteger random;
@end

@implementation JSCartViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
  
    }
    return self;
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
            
            return @(model.count*model.price);
            
        }];
    }] array];
    for (NSArray *priceA in pricesArray) {
        
        for (NSNumber *price in priceA) {
            allPrices += price.floatValue;
        }
    }
    NSLog(@"-----%f",allPrices);
    return allPrices;
}

- (void)selectAll:(BOOL)isSelect{
    
     __block float allPrices = 0;
    
    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence] map:^id(NSNumber *value) {
        return @(isSelect);
    }] array] mutableCopy];
    self.cartData = [[[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
        return  [[[[value rac_sequence] map:^id(HDShopCarModel *model) {
                [model setValue:@(isSelect) forKey:@"isSelect"];
            if (model.isSelect) {
                allPrices += model.p_id*model.price;
            }
            return model;
        }] array] mutableCopy];
    }] array] mutableCopy];
    self.allPrices = allPrices;
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
}
//数量选则
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    HDShopCarModel *model = self.cartData[section][row];

    [model setValue:@(quantity) forKey:@"count"];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    self.allPrices = [self getAllPrices];
}

@end

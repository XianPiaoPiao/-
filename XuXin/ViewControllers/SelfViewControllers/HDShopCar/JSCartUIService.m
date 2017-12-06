//
//  JSCartUIService.m
//  JSShopCartModule
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "JSCartUIService.h"

#import "HDFooterView.h"

#import "HDHeaderView.h"
#import "ShopBagTableViewCell.h"
#import "HDCarNumberCOunt.h"
#import "WriteOrderViewController.h"
#import "HDShopCarModel.h"

@implementation JSCartUIService{
    
    NSInteger _lastSection;
    
    NSInteger _currentSection;
    
    
    NSInteger _lastRow;
    
    NSInteger _currentRow;
}
-(NSMutableArray *)goodsSelectArray{
    if (!_goodsSelectArray) {
        _goodsSelectArray = [[NSMutableArray alloc] init];
    }
    return _goodsSelectArray;
}
-(NSMutableArray *)storesSelectArray{
    if (!_storesSelectArray) {
        _storesSelectArray = [[NSMutableArray alloc] init];
    }
    return _storesSelectArray;
}
#pragma mark - UITableView Delegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.viewModel.cartData.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.cartData[section] count];
}

#pragma mark - header view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [HDHeaderView getCartHeaderHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *shopArray = self.viewModel.cartData[section];

    HDHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HDHeaderView"];
    
      NSString * storeName = self.viewModel.storeArray[section][@"storeName"];
        _storeId = self.viewModel.storeArray[section][@"storeCartId"];
   //   _storeId = self.viewModel.storeArray[section][@"storeCartId"];
    
  //  [headerView.storeNameButton addTarget:self action:@selector(jumpShop) forControlEvents:UIControlEventTouchDown];
    
     [headerView.storeNameButton setTitle:storeName forState:UIControlStateNormal];
    //店铺全选
    [[[headerView.selectStoreGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(UIButton *xx) {
        xx.selected = !xx.selected;
        BOOL isSelect = xx.selected;
        [self.viewModel.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
        for (HDShopCarModel *model in shopArray) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
        }
        [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        
        self.viewModel.allPrices = [self.viewModel getAllPrices];
    }];
    //店铺选中状态
    headerView.selectStoreGoodsButton.selected = [self.viewModel.shopSelectArray[section] boolValue];
    
    
    //店铺 选中
   [[headerView.selectStoreGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
        x.selected = !x.selected;
       
     if (x.selected == YES) {
       
         for (HDShopCarModel *model in shopArray) {
             
             [self.goodsSelectArray removeObject:model];
             
         }
           [self.storesSelectArray removeObject:self.viewModel.storeArray[section][@"storeName"]];
        
    } else{
        
      
        BOOL storeRet =   [self.storesSelectArray containsObject:self.viewModel.storeArray[section][@"storeName"]];
        
        if (storeRet == NO) {
            
            [self.storesSelectArray addObject: self.viewModel.storeArray[section][@"storeName"]];
        }
        
        
        for (HDShopCarModel *model in shopArray) {
            
        BOOL ret = [self.goodsSelectArray containsObject:model];
            
            if (ret == NO) {
                
                [self.goodsSelectArray addObject:model];

            }
            
   
            
            
        }
        
        
    
}
    
    [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
       
   }];
//
//    [RACObserve(headerView.selectStoreGoodsButton, selected) subscribeNext:^(NSNumber *x) {
//        
//        NSLog(@"====%@",x);
//
//        
//        BOOL isSelect = x.boolValue;
//        
//        [self.viewModel.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
//        
//        if (headerView.selectStoreGoodsButton.selected == YES) {
//            
//            NSLog(@"---===%ld",shopArray.count);
//            for (HDShopCarModel *model in shopArray) {
//                
//                [model setValue:@(isSelect) forKey:@"isSelect"];
//                
//                [self.goodsSelectArray addObject:model];
//            }
//        }else{
//            for (HDShopCarModel *model in shopArray) {
//                [model setValue:@(isSelect) forKey:@"isSelect"];
//                
//                [self.goodsSelectArray removeObject:model];
//                
//            }
//        }
//        [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//    }];
    
    return headerView;
}

#pragma mark - footer view

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
   // NSMutableArray *shopArray = self.viewModel.cartData[section];
   //
  //   HDFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HDFooterView"];
    
 //   footerView.shopGoodsArray = shopArray;
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [ShopBagTableViewCell getCartCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopBagTableViewCell"
                                                       forIndexPath:indexPath];
    //
    [self configureCell:cell forRowAtIndexPath:indexPath and:tableView];

    return cell;
}

- (void)configureCell:( ShopBagTableViewCell*)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath and:(UITableView *)tableview
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    

    HDShopCarModel *model = self.viewModel.cartData[section][row];
    //cell 选中
    WEAK
    [[[cell.selectedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        
        x.selected = !x.selected;

//
//        _currentSection = section;
//        
//        if (_currentSection != _lastSection) {
//            
//        for (int i = 0; i < [self.viewModel.cartData[_lastSection] count]; i ++) {
//            
//        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:_lastSection];
//            
//        ShopBagTableViewCell *cell=  [tableview cellForRowAtIndexPath:index];
//        cell.selectedBtn.selected = NO;
//            
//        }
//    }
//        
//    _lastSection = _currentSection;
        

        //加入到
        if (cell.selectedBtn.selected  == YES) {
            
            HDShopCarModel *model = self.viewModel.cartData[section][row];
            
            [self.goodsSelectArray addObject:model];
            
            _storeId = self.viewModel.storeArray[section][@"storeCartId"];
            
            //
            BOOL ret =   [self.storesSelectArray containsObject:self.viewModel.storeArray[section][@"storeName"]];
            
            if (ret == NO) {
                
                [self.storesSelectArray addObject: self.viewModel.storeArray[section][@"storeName"]];
                
            }
         
            
        }else if(cell.selectedBtn.selected  == NO){
            
            [self.goodsSelectArray removeObject:model];
            
            [self.storesSelectArray removeObject: self.viewModel.storeArray[section][@"storeName"]];
        }
        
        [self.viewModel rowSelect:x.selected IndexPath:indexPath];


    }];
    
    
    //数量改变
    
    cell.selfStepperView.NumberChangeBlock = ^(NSInteger changeCount){
        STRONG
        

        
        _storeId = self.viewModel.storeArray[section][@"storeCartId"];

        [self.viewModel rowChangeQuantity:changeCount indexPath:indexPath];
        
        [self requestAddOrsubData:model];

    };
    cell.model = model;
}
#pragma mark ---数量加减
-(void)requestAddOrsubData:(HDShopCarModel *)model{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"goodsCartId"] = [NSString stringWithFormat:@"%ld",(long)model.p_id];
    
    dic[@"count"] = [NSString stringWithFormat:@"%ld",(long)model.count];
    
    dic[@"storeCartId"] = _storeId;
    
    [weakself POST:updateCartCountUrl parameters:dic success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            [User defalutManager].lineShopCart ++;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteConvertOK" object:nil];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}
//-(void)jumpShop{
//    
//    [User defalutManager].selectedShop = _storeId;
//    
//    UIStoryboard * storybord =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    
//    UIViewController * MyVC = [storybord instantiateViewControllerWithIdentifier:@"ShopDetailViewController"] ;
//    
//    [self.navigationController pushViewController:MyVC animated:YES];
//}
//
@end

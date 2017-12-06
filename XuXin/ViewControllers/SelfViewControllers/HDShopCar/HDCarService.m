
#import "HDCarService.h"

#import "HDFooterView.h"
#import "HDShopCarModel.h"
#import "HDHeaderView.h"
#import "ShopBagTableViewCell.h"
#import "HDCarNumberCOunt.h"
#import "WriteOrderViewController.h"
#import "HDShopCarModel.h"
@implementation HDCarService{
    NSString *  _storeId;
}

#pragma mark - UITableView Delegate/DataSource

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.viewModel.cartData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    
    NSString * storeName = self.viewModel.storeArray[section][@"vendor"];
    _storeId = self.viewModel.storeArray[section][@"storeCartId"];
    
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
        self.viewModel.allIntegrals = [self.viewModel getAllIntegrals];
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
            [self.storesSelectArray removeObject:self.viewModel.storeArray[section][@"vendor"]];
            
        } else{
            
            
            BOOL storeRet =   [self.storesSelectArray containsObject:self.viewModel.storeArray[section][@"vendor"]];
            
            if (storeRet == NO) {
                
                [self.storesSelectArray addObject: self.viewModel.storeArray[section][@"vendor"]];
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
    
    return headerView;

}

#pragma mark - footer view

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
       return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [ShopBagTableViewCell getCartCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopBagTableViewCell"
        forIndexPath:indexPath];

    
    [self configureCell:cell forRowAtIndexPath:indexPath and:tableView];
    
    return cell;
}
- (void)configureCell:( ShopBagTableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath and:(UITableView *)tableview
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    HDShopCarModel *model = self.viewModel.cartData[section][row];
    //cell 选中
    WEAK
    [[[cell.selectedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        
        x.selected = !x.selected;
        
        //加入到
        if (cell.selectedBtn.selected  == YES) {
            
            HDShopCarModel *model = self.viewModel.cartData[section][row];
            
            [self.goodsSelectArray addObject:model];
            
            BOOL ret =   [self.storesSelectArray containsObject:self.viewModel.storeArray[section][@"vendor"]];
            
            if (ret == NO) {
                
                [self.storesSelectArray addObject: self.viewModel.storeArray[section][@"vendor"]];
                
            }
            
            
        }else if(cell.selectedBtn.selected  == NO){
            
            [self.goodsSelectArray removeObject:model];
            
            [self.storesSelectArray removeObject: self.viewModel.storeArray[section][@"vendor"]];
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
/*- (void)configureCell:(ShopBagTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    HDShopCarModel *model = self.viewModel.cartData[section][row];
    //cell 选中
    WEAK
    [[[cell.selectedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        x.selected = !x.selected;
        
        [self.viewModel rowSelect:x.selected IndexPath:indexPath];
        
        NSMutableArray * goodsArray = self.viewModel.cartData[section];
        
        //加入到
        if (cell.selectedBtn.selected == YES) {
            
            BOOL storeRet =   [self.storesSelectArray containsObject:self.viewModel.storeArray[section][@"vendor"]];
            
            if (storeRet == NO) {
                
                [self.storesSelectArray addObject: self.viewModel.storeArray[section][@"vendor"]];
            }
            
            for (HDShopCarModel *model in goodsArray) {
                if (model.isSelect == YES) {
                    [self.goodsSelectArray addObject:model];
                }
//                [self.goodsSelectArray addObject:model];
                
            }
        }else{
            
            for (HDShopCarModel *model in goodsArray) {
                if(model.isSelect == NO){
                    [self.goodsSelectArray removeObject:model];
                }
            
            }
        }
        
    }];
    //数量改变
    cell.selfStepperView.NumberChangeBlock = ^(NSInteger changeCount){
        STRONG
        [self.viewModel rowChangeQuantity:changeCount indexPath:indexPath];
        
        //数量增减
        [self requestAddOrsubData:model];
        
    };
    
    cell.model = model;
    
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDShopCarModel *model = self.viewModel.cartData[indexPath.section][indexPath.row];

    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)model.goodsId],@"textOne", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpNextVC" object:nil userInfo:dic];
    
}
#pragma mark ---数量加减
-(void)requestAddOrsubData:(HDShopCarModel *)model{
    
    __weak typeof(self)weakself = self;
 
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"cartId"] = [NSString stringWithFormat:@"%ld",(long)model.p_id] ;
    dic[@"count"] = [NSString stringWithFormat:@"%ld",(long)model.count];
    [weakself POST:integralGoods_adjust_countUrl parameters:dic success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            [User defalutManager].shopcart = [responseObject[@"result"][@"cartGoodsSize"] integerValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteConvertOK" object:nil];
        } else {
            [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        
    }];

    
}

@end

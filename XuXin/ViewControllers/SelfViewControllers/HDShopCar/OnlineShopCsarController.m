//
//  OnlineShopCsarController.m
//  XuXin
//
//  Created by xuxin on 17/3/15.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "OnlineShopCsarController.h"
#import "JSCartViewModel.h"
#import "JSCartUIService.h"
#import "HDCarBar.h"
#import "OnlineOrderController.h"
#import "HDShopCarModel.h"

@interface OnlineShopCsarController ()<UIScrollViewDelegate>
@property (nonatomic ,assign)NSInteger page;

@end

@implementation OnlineShopCsarController{
    

}
-(NSMutableArray *)onlineGoodsArray{
    if (!_onlineGoodsArray) {
        _onlineGoodsArray = [[NSMutableArray alloc] init];
    }
    return _onlineGoodsArray;
}
#pragma mark - lazy load

- (JSCartViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[JSCartViewModel alloc] init];
        
        _viewModel.carVC = self;
        
        _viewModel.cartTableView  = self.cartTableView;
    }
    return _viewModel;
}


- (JSCartUIService *)service{
    
    if (!_service) {
        
        _service = [[JSCartUIService alloc] init];
        _service.viewModel = self.viewModel;
    }
    return _service;
}

-(UIView*)edictBotomView{
    
    if (!_edictBotomView) {
        
        _edictBotomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH -156-self.StatusBarHeight-3-self.TabbarHeight , ScreenW, 50)];
        
        _edictBotomView.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return _edictBotomView;
}
- (UITableView *)cartTableView{
    
    if (!_cartTableView) {
        
        _cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH- 164) style:UITableViewStyleGrouped];
        
        [_cartTableView registerNib:[UINib nibWithNibName:@"ShopBagTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"ShopBagTableViewCell"];
        [_cartTableView registerClass:NSClassFromString(@"HDFooterView") forHeaderFooterViewReuseIdentifier:@"HDFooterView"];
        [_cartTableView registerClass:NSClassFromString(@"HDHeaderView") forHeaderFooterViewReuseIdentifier:@"HDHeaderView"];
        _cartTableView.dataSource = self.service;
        _cartTableView.delegate   = self.service;
        
        _cartTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
        _cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        //上拉下载
        __weak typeof(self)weakself = self;
        _cartTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //  加载全部分类数据
            weakself.page = 0;

            [weakself getData:weakself.page];
            //  加载城市分类数据
            weakself.cartTableView.mj_footer.hidden = YES;
            
            
        }];
        //下拉加载
        _cartTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            weakself.page ++;
            [weakself getData:weakself.page];
            
        }];
        
    }
    return _cartTableView;
}

- ( HDCarBar*)cartBar{
    
    if (!_cartBar) {
        
        _cartBar = [[HDCarBar alloc] initWithFrame:CGRectMake(0, screenH-156-self.StatusBarHeight-3-self.TabbarHeight, ScreenW, 50)];
        _cartBar.selectAllButton.hidden = YES;
    }
    return _cartBar;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    //初始化化
    _shopCarType = 1;
    
    _page = 0;
    
    //编辑
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBottom) name:@"online" object:nil];
   //完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickupBottom) name:@"onlineOff" object:nil];
   // [self creatUI];
    
    [self.view addSubview:self.cartTableView];
    
    [self.view addSubview:self.cartBar];
    
    [self firstLoad];
    
    //删除
    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    //结算
    [[self.cartBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
        if (self.service.storesSelectArray.count > 1) {
            
            [self showStaus:@"不能跨店铺购买"];
            
        }else{
        //订单填写界面
        OnlineOrderController * onlineVC = [[OnlineOrderController alloc] init];
        //传值到下个界面
        NSMutableString * goodsID =[NSMutableString string];
        
        for (HDShopCarModel * model in self.service.goodsSelectArray) {
            
            [onlineVC.ImageArray addObject:model];
            
            [goodsID appendString:[NSString stringWithFormat:@"%ld,",model.p_id]];
 
        }
        //拼接字符串
        if (goodsID.length) {
            
            [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
        }
        
        onlineVC.goodsCartId = goodsID;
        
        onlineVC.storeCartId = self.service.storeId;
        //购物车进入订单
        onlineVC.shopcarType = 1;
        
        onlineVC.userMobile = [User defalutManager].userName;
        
        onlineVC.amountMoney =[NSString stringWithFormat:@"%.2f",self.cartBar.money];
        
        onlineVC.orderType = 1;
        
        [self.navigationController pushViewController:onlineVC animated:YES];
        }
        
    }];
        
    /* 观察价格属性 */
    WEAK
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        STRONG
        
        self.cartBar.money = x.floatValue;
        
    }];
    
    /* 全选 状态 */
    RAC(self.cartBar.selectAllButton,selected) = RACObserve(self.viewModel, isSelectAll);
    
}
#pragma mark ---通知下拉切换视图

-(void)showBottom{
     [UIView animateWithDuration:0.4 animations:^{
         
    self.cartBar.frame = CGRectMake(0, screenH -156-self.StatusBarHeight-3-self.TabbarHeight, ScreenW, 50);
    
    self.edictBotomView.frame = CGRectMake(0 , screenH , ScreenW, 50);
     }];
}
-(void)pickupBottom{
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.cartBar.frame = CGRectMake(0, screenH , ScreenW, 50);
        
        self.edictBotomView.frame = CGRectMake(0, screenH -156-self.StatusBarHeight-3-self.TabbarHeight, ScreenW, 50);
    }];
}
-(void)firstLoad{
    
    [self.cartTableView.mj_header beginRefreshing];
}
- (void)getData:(NSInteger )page{
    
    //数据请求
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"type"] =[NSString stringWithFormat:@"%ld", _shopCarType];
    param[@"page"]= [NSString stringWithFormat:@"%ld",page];
    
    [self POST:appFindCartByTypeUrl parameters:param success:^(id responseObject) {
        
        
        NSString * str = responseObject[@"isSucc"];
        
        int i = [responseObject[@"code"] intValue];

        if ([str intValue] == 1) {
            //停止动画
            weakself.onlineGoodsArray = responseObject[@"result"];
            

            NSInteger allCount = weakself.onlineGoodsArray.count;

            NSMutableArray * storeArray = [NSMutableArray arrayWithCapacity:allCount];
            
            NSMutableArray *shopSelectAarry = [NSMutableArray arrayWithCapacity:allCount];
            
            
            for (int i = 0; i <weakself.onlineGoodsArray.count; i++) {
                
                NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
                
                NSArray * onlineArray = weakself.onlineGoodsArray[i][@"goodsCartList"];
                
                for (int i = 0; i< onlineArray.count; i++) {
                    
                    HDShopCarModel *cartModel = [[HDShopCarModel alloc] init];
                    NSDictionary * goodsDic = onlineArray[i];
                    
                    cartModel.p_id =[goodsDic[@"goodsCartId"] longLongValue];
                    cartModel.goodsSpecifications = goodsDic[@"goodsSpecifications"];
                    cartModel.price =[goodsDic[@"price"] integerValue];
                    cartModel.ig_goods_name =goodsDic[@"goodsName"];
                    cartModel.logo = goodsDic[@"goodsLogo"];
                    cartModel.count = [goodsDic[@"goodsCount"] integerValue];
                
                    cartModel.goodsId = [goodsDic[@"goodsId"] integerValue];
                
                    [goodsArray addObject:cartModel];
                }
                
                [storeArray addObject:goodsArray];
                
                [shopSelectAarry addObject:@(NO)];
            }

            weakself.viewModel.cartData = storeArray;
            weakself.viewModel.storeArray = self.onlineGoodsArray;
            
            weakself.viewModel.shopSelectArray = shopSelectAarry;
                
        }else{
                //购物车为空
            weakself.cartTableView.hidden = YES;
                
            CGFloat imageW = 120;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageW)];
            UILabel * label  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH/ 2.0f , ScreenW, 20)];
            label.text = @"你还没有添加任何商品";
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = 1;
            
            imageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 80);
            [imageView setImage:[UIImage imageNamed:@"konggouwuche"]];
            [self.view addSubview:imageView];
            [self.view addSubview:label];
        }
        weakself.cartTableView.mj_header.hidden = NO;
        weakself.cartTableView.mj_footer.hidden = NO;
        [weakself.cartTableView.mj_header endRefreshing];
        [weakself.cartTableView.mj_footer endRefreshing];
        
        if(i == 7030){
            
            //没有更多数据
            [weakself.cartTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        //小于5条数据
        if (weakself.onlineGoodsArray.count < 5 && self.onlineGoodsArray.count >0) {
            //数据全部请求完毕
            weakself.cartTableView.mj_footer.hidden = YES;
            
        }else if (self.onlineGoodsArray.count == 0){
            
            [weakself.cartTableView.mj_footer endRefreshing];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
                
            [weakself.cartTableView reloadData];
    });
    
        
    } failure:^(NSError *error) {
        
        [weakself.cartTableView.mj_header endRefreshing];
        [weakself.cartTableView.mj_footer endRefreshing];
        //将自增的page减下来
        if(weakself.page > 0){
            weakself.page--;
        }
    }];
    
}
-(void)creatUI{
    
    //全选按钮
    UIButton *  edictAllSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    [edictAllSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [edictAllSelectBtn setImagePositionWithType: SSImagePositionTypeLeft spacing:20];
    //全选
    [[edictAllSelectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        [self.viewModel selectAll:x.selected];
        static int i = 0;
        if (i == 0) {
            
            [self.service.goodsSelectArray removeAllObjects];
            
            for (NSMutableArray * array in self.viewModel.cartData) {
                for (HDShopCarModel * model in array) {
                    
              [self.service.goodsSelectArray addObject:model];
                    
                }
            }
            i++;
        }else if (i == 1){
            
            [self.service.goodsSelectArray removeAllObjects];
            i--;
        }
    }];
    
    edictAllSelectBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [edictAllSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    
    [edictAllSelectBtn setBackgroundImage:[UIImage imageNamed:@"btn_shopcart_radio_off@3x"] forState:UIControlStateNormal];
    [edictAllSelectBtn setBackgroundImage:[UIImage imageNamed:@"dingdan_chenggong@3x"] forState:UIControlStateSelected];
    
    UILabel * edictAllSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 40, 20)];
    
    [edictAllSelectedLabel setText:@"全选"];
    edictAllSelectedLabel.font = [UIFont systemFontOfSize:W2];
    edictAllSelectedLabel.textColor = [UIColor blackColor];
    
    /* 背景 */
    //模糊效果
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.userInteractionEnabled = NO;
    effectView.frame =CGRectMake(0, 0, ScreenW, 50);
    
    [ self.edictBotomView addSubview:effectView];
    [ self.edictBotomView addSubview:edictAllSelectBtn];
    [ self.edictBotomView addSubview:edictAllSelectedLabel];
    
    //创建按钮
    NSArray * array = @[@"删除",@"移入收藏"];
    for (int i = 0; i< 2; i++) {
        
        NSInteger buttonW = 80 * ScreenScale;
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( ScreenW -((i+1) * buttonW + (i+1) * 10), 10, buttonW, 30)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:W2];
        [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHexString:WordLightColor].CGColor;
        button.tag = buttonTag + i;
        //点击事件
        [button addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchDown];
        [ self.edictBotomView addSubview:button];
    }
   [self.view addSubview:self.edictBotomView];
}

-(void)bottomAction:(UIButton *)sender{
    //删除
    if (sender.tag == buttonTag ) {
        
        if (self.service.goodsSelectArray.count > 0) {
            
            [self requestDeleteData];
            
        }else{
            
            [self showStaus:@"请选择你要删除的商品"];
        }
    }else if (sender.tag == buttonTag + 1){
        
        if (self.service.goodsSelectArray.count == 1) {
            
            [self requestCollectedData];
            
        }else if (self.service.goodsSelectArray.count > 1){
            
            [self collectManyGoods];
            
        }else{
            
            [self showStaus:@"请选择收藏的商品"];
        }
    }
}
#pragma mark --- 收藏
-(void)requestCollectedData{
    
    __weak typeof(self)weakself = self;
    NSMutableString * goodsID = [NSMutableString string];
    
    for (int i = 0; i< weakself.service.goodsSelectArray.count; i++) {
        
        
        HDShopCarModel * model = weakself.service.goodsSelectArray[i];
        
        [goodsID appendString:[NSString stringWithFormat:@"%ld,",(long)model.goodsId]];
        
    }
    
    //拼接字符串
    if (goodsID.length) {
        
        [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"goodsIds"] = goodsID;
    
    param[@"type"] = @"1";
    
    [weakself POST:batchAddFavoriteUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [weakself showStaus:@"收藏成功"];
        
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark ---收藏多个商品
-(void)collectManyGoods{
    
    __weak typeof(self)weakself = self;
    NSMutableString * goodsID = [NSMutableString string];
    
    for (int i = 0; i< weakself.service.goodsSelectArray.count; i++) {
        
        
        HDShopCarModel * model = weakself.service.goodsSelectArray[i];
        
        [goodsID appendString:[NSString stringWithFormat:@"%ld,",(long)model.goodsId]];
        
    }
    
    //拼接字符串
    if (goodsID.length) {
        
        [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"goodsIds"] = goodsID;
    //线上
    param[@"type"] = @"1";
    
    [weakself POST:batchAddFavoriteUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [weakself showStaus:@"收藏成功"];

        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark  ---- 删除
-(void)requestDeleteData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    NSMutableString * goodsID = [NSMutableString string];
    
    NSInteger deleteNumber = weakself.service.goodsSelectArray.count;
    
    for (int i = 0; i< weakself.service.goodsSelectArray.count; i++) {
        
        
        HDShopCarModel * model = weakself.service.goodsSelectArray[i];
        
        [goodsID appendString:[NSString stringWithFormat:@"%ld,",(long)model.p_id]];
        
        //删除数据源
        NSMutableArray *delArr;
        for (NSMutableArray *tempArr in weakself.viewModel.cartData) {
            for (HDShopCarModel *tempModel in tempArr) {
                if (model == tempModel) {
                    delArr = tempArr ;
                    break;
                }
            }
        }
        
        [weakself.viewModel.cartData removeObject:delArr];
        

    }
    //拼接字符串
    if (goodsID.length) {
        
        [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
    }
    //拼接字符串
    param[@"goodsCartId"] = goodsID;
    
    [weakself POST:delectCartByGoodsCartIdUrl parameters:param success:^(id responseObject) {
        
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            [weakself showStaus:@"删除商品成功"];
            
            [weakself.service.goodsSelectArray removeAllObjects];
            
            [weakself getData:weakself.page];
            
            
            [User defalutManager].lineShopCart =[User defalutManager].lineShopCart - deleteNumber;
              
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteConvertOK" object:nil];
            
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

//
//  HDshopCarViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDshopCarViewController.h"
#import "HDCarViewModel.h"
#import "HDCarBar.h"
#import "HDCarService.h"
#import "WriteOrderViewController.h"
#import "HDShopCarModel.h"
#import "CovertGoodsViewController.h"

#import "OnlineShopCsarController.h"
#import "GroupShopCarController.h"
@interface HDshopCarViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) HDCarService *service;

@property (nonatomic, strong) HDCarViewModel *viewModel;

@property (nonatomic, strong) UITableView *cartTableView;
@property (nonatomic ,strong)UIView * edictBotomView;
@property (nonatomic, strong) HDCarBar  *cartBar;

@property (nonatomic ,strong)OnlineShopCsarController * onlineCarVC;

@property (nonatomic ,strong)GroupShopCarController * groupCarVC;
@property(nonatomic,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger index;

@property (nonatomic, strong) NSMutableArray *storeCartArray;

@end

@implementation HDshopCarViewController{
    
    NSArray *_shopGoodsCount;
    NSArray *_goodsPicArray;
    NSArray *_goodsPriceArray;
    NSArray *_goodsQuantityArray;
    
    UIScrollView * _VCScrollView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(NSMutableArray *)storeCartArray{
    if (!_storeCartArray) {
        _storeCartArray = [[NSMutableArray alloc] init];
    }
    return _storeCartArray;
}

-(UIView*)edictBotomView{
    
    if (!_edictBotomView) {
        _edictBotomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH , ScreenW, 50)];
        _edictBotomView.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return _edictBotomView;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.view.subviews[0] != self.cartTableView) {
        
        //self.tableView是我们希望正常显示cell的视图
     self.cartTableView.subviews[0].frame = CGRectMake(0, 64, ScreenW, screenH);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview不加64 位置为0
//   self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.view addSubview:self.cartTableView];

    //数据请求
    [self firstLoad];

    self.title = @"购物车";
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpWriteShopDetailVC:) name:@"jumpNextVC" object:nil];
    
    //创建导航栏
    [self creatNavgationBar];
    //
    //编辑
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBottom) name:@"convert" object:nil];
    //完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickupBottom) name:@"convertOff" object:nil];
    
    [self creatUI];
    
    //添加底部视图
    [self.view addSubview:self.cartBar];

    /* RAC  */
    //全选
    [[self.cartBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        
        
        [self.viewModel selectAll:x.selected];
      
        if (self.cartBar.selectAllButton.selected == YES) {
            
            [self.service.goodsSelectArray removeAllObjects];
            
            for (NSMutableArray * array in self.viewModel.cartData) {
                
                for (HDShopCarModel * model in array) {
                    
                    [self.service.goodsSelectArray addObject:model];
                    
                }
            }
           
        }else {
            
            
          [self.service.goodsSelectArray removeAllObjects];
                
        }

    }];
    //删除
    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    //结算
    [[self.cartBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
        if (self.service.storesSelectArray.count > 1) {
            
            [self showStaus:@"不能跨店铺购买"];
            
        } else {
            //订单填写界面
            WriteOrderViewController * writeOrderVC = [[WriteOrderViewController alloc] init];
            //传值到下个界面
            
            for (HDShopCarModel * model in self.service.goodsSelectArray) {
                
                if (model.isSelect) {
                    [writeOrderVC.ImageArray addObject:model];
                    //数量
                    writeOrderVC.count = model.count;
                    writeOrderVC.shopCarNumber = writeOrderVC.shopCarNumber + model.count;
                    
                    [writeOrderVC.goodIdaArray addObject:[NSString stringWithFormat:@"%ld",(long)model.p_id]];
                    writeOrderVC.vendor = model.vendor;
                }
                
            }
            
            //价格
            writeOrderVC.totalPrice =  self.cartBar.money;
            //积分
            writeOrderVC.totalIntegral = self.cartBar.integral;
            //订单类型
            writeOrderVC.type = 2;
            //从购物车进入
            writeOrderVC.shopCartype = 1;//1
            //填写订单
            [self.navigationController pushViewController:writeOrderVC animated:YES];
        }
         
    }];
    /* 观察价格属性 */
    WEAK
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        STRONG
        self.cartBar.money = x.floatValue;
    }];
    
    [RACObserve(self.viewModel, allIntegrals) subscribeNext:^(NSNumber *x) {
        STRONG
        self.cartBar.integral = x.floatValue;
    }];
    
    /* 全选 状态 */
    RAC(self.cartBar.selectAllButton,selected) = RACObserve(self.viewModel, isSelectAll);
    
    
}
#pragma amrk ---购物车列表请求
-(void)firstLoad{
    
   [self getData];

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
#pragma mark - make data

- (void)getData{
    
    //数据请求
    __weak typeof(self)weakself = self;
    
    [weakself POST:integralListUrl parameters:nil success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        int i = [responseObject[@"code"] intValue];
        if ([str intValue] == 1) {
            //停止动画
            
            weakself.storeCartArray = responseObject[@"result"];//[@"cart"];
            if (_storeCartArray.count) {
                
                NSInteger allCount = weakself.storeCartArray.count;
                NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:allCount];
                NSMutableArray *shopSelectAarry = [NSMutableArray arrayWithCapacity:allCount];

                //创造店铺数据
                for (int i = 0; i<allCount; i++) {
                    
                    //创造店铺下商品数据
                    NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
                    NSArray * integralArray = weakself.storeCartArray[i][@"cart"];
                    for (int j = 0; j < integralArray.count; j ++) {
                        
                        HDShopCarModel *cartModel = [[HDShopCarModel alloc] init];
                        NSDictionary * goodsDic = integralArray[j];
                        cartModel.p_id =[goodsDic[@"id"] longLongValue];
                        cartModel.ig_goods_integral =[goodsDic[@"price"] integerValue];
                        cartModel.ig_goods_name = goodsDic[@"goods"][@"ig_goods_name"];
                        cartModel.goodsId = [goodsDic[@"goods"][@"goodsId"] longLongValue];
                        cartModel.logo = goodsDic[@"goods"][@"logo"];
                        cartModel.count = [goodsDic[@"count"] integerValue];
                        cartModel.price = [goodsDic[@"cashPrice"] doubleValue];
                        cartModel.goodsSpecifications = goodsDic[@"spec"];
                        cartModel.cash = [goodsDic[@"cashPrice"] doubleValue];
                        cartModel.vendor =weakself.storeCartArray[i][@"vendor"];
                        
                        [goodsArray addObject:cartModel];
                    }
                    
                    [storeArray addObject:goodsArray];
                    [shopSelectAarry addObject:@(NO)];
                    
                    

                }
                weakself.viewModel.storeArray = self.storeCartArray;
                
                self.viewModel.cartData = storeArray;
                
                self.viewModel.shopSelectArray = shopSelectAarry;
                
            }else{
                //购物车为空
                CGFloat imageW = 120;
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageW)];
                UILabel * label  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH/ 2.0f, ScreenW, 20)];
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
            if (weakself.storeCartArray.count < 5 && self.storeCartArray.count >0) {
                //数据全部请求完毕
                weakself.cartTableView.mj_footer.hidden = YES;
                
            }else if (self.storeCartArray.count == 0){
                
                [weakself.cartTableView.mj_footer endRefreshing];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.cartTableView reloadData];
            });
            
        }

    } failure:^(NSError *error) {
        

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
    
//    RAC(edictAllSelectBtn, selected) = [RACSignal combineLatest:RACObserve(self.cartBar.selectAllButton,selected) reduce:^id (NSNumber *isSelect){
//        return @(isSelect.boolValue);
//    }];
    RAC(edictAllSelectBtn,selected) = RACObserve(self.viewModel, isSelectAll);

    edictAllSelectBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [edictAllSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    edictAllSelectBtn.tag = 12;
    [edictAllSelectBtn setBackgroundImage:[UIImage imageNamed:@"btn_shopcart_radio_off@3x"] forState:UIControlStateNormal];
    [edictAllSelectBtn setBackgroundImage:[UIImage imageNamed:@"dingdan_chenggong@3x"] forState:UIControlStateSelected];
    
    UILabel * edictAllSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 40, 20)];
    
    [edictAllSelectedLabel setText:@"全选"];
    edictAllSelectedLabel.font = [UIFont systemFontOfSize:W2];
    edictAllSelectedLabel.textColor = [UIColor blackColor];
    
    /* 背景 */
    //模糊效果
    
     self.edictBotomView.backgroundColor = [UIColor clearColor];
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
   [self.view addSubview: self.edictBotomView];
}
#pragma mark ---跳转到详情
-(void)jumpWriteShopDetailVC:(NSNotification * ) cation{
    
    NSString * str = cation.userInfo[@"textOne"];
    
    [User defalutManager].selectedGoodsID = str;
    
    CovertGoodsViewController * goodsVC = [[CovertGoodsViewController alloc] init];
    [self.navigationController pushViewController:goodsVC animated:YES];
    
}
-(void)bottomAction:(UIButton *)sender{
    //删除
    if (sender.tag == buttonTag ) {
        
        if (self.service.goodsSelectArray.count > 0) {
            
            [self requestDeleteData:sender];

        }else{
            [self showStaus:@"请选择你要删除的商品"];
        }
    }else if (sender.tag == buttonTag + 1){
        
        
        if (self.service.goodsSelectArray.count == 1) {
            
            [self requestCollectedData:sender];
            
        }else if (self.service.goodsSelectArray.count > 1){
            
            [self collectManyGoods:sender];
            
        }else{
            
            [self showStaus:@"请选择收藏的商品"];
        }
    }
}
#pragma mark --- 收藏
-(void)requestCollectedData:(UIButton *)sender{
    
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
    param[@"type"] = @"3";
    [weakself POST:batchAddFavoriteUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                
            });
        }

    } failure:^(NSError *error) {

    }];


}
#pragma mark ---收藏多个商品
-(void)collectManyGoods:(UIButton *)sender{
    
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
    param[@"type"] = @"3";
    [weakself POST:batchAddFavoriteUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                
            });
        }
        
    } failure:^(NSError *error) {
        
    }];
    

}
#pragma mark  ---- 删除
-(void)requestDeleteData:(UIButton *)sender{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSMutableString * goodsID = [NSMutableString string];

    
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
    param[@"ids"] = goodsID;
    
    [weakself POST:removeIntegralsUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [weakself showStaus:@"删除商品成功"];
            
            [weakself.service.goodsSelectArray removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                [weakself.cartTableView reloadData];
                [weakself getData];
                
                [User defalutManager].shopcart = [responseObject[@"result"][@"cartGoodsSize"] integerValue];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteConvertOK" object:nil];
                /* 观察价格属性 */
                WEAK
                [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
                    STRONG
                    self.cartBar.money = 0;
                }];
                
                [RACObserve(self.viewModel, allIntegrals) subscribeNext:^(NSNumber *x) {
                    STRONG
                    self.cartBar.integral = 0;
                }];
                UIButton *btn = [self.view viewWithTag:12];
                btn.selected = NO;
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_shopcart_radio_off@3x"] forState:UIControlStateNormal];
//                
//                /* 全选 状态 */
//                RAC(self.cartBar.selectAllButton,selected) = RACObserve(self.viewModel, isSelectAll);
            });

        }
     
        
    } failure:^(NSError *error) {
        

    }];
  
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"购物车"];
    
    [self addBackBarButtonItem];
    
    [self addBarButtonItemWithTitle:@"编辑" image:nil target:self action:@selector(edict:) isLeft:NO];
    
    
}

-(void)edict:(UIButton *)sender{
    
    if (sender.selected == YES) {
    
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.cartBar.frame = CGRectMake(0, screenH -50, ScreenW, 50);
            
            self.edictBotomView.frame = CGRectMake(0 , screenH , ScreenW, 50);
        }];
        sender.selected = NO;
    } else{
        
        [sender setTitle:@"完成" forState:UIControlStateNormal];;
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.cartBar.frame = CGRectMake(0, screenH , ScreenW, 50);
            
            self.edictBotomView.frame = CGRectMake(0, screenH -50, ScreenW, 50);
        }];
        sender.selected = YES;
    }

}
#pragma mark - lazy load

- (HDCarViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[HDCarViewModel alloc] init];
        
        _viewModel.cartVC = self;
        _viewModel.cartTableView  = self.cartTableView;
    }
    return _viewModel;
}


- (HDCarService *)service{
    
    if (!_service) {
        _service = [[HDCarService alloc] init];
        _service.viewModel = self.viewModel;
    }
    return _service;
}


-(UITableView *)cartTableView{
    
    if (!_cartTableView) {
        
        _cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, ScreenW, screenH - 156) style:UITableViewStyleGrouped];

        [_cartTableView registerNib:[UINib nibWithNibName:@"ShopBagTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"ShopBagTableViewCell"];
        [_cartTableView registerClass:NSClassFromString(@"HDFooterView") forHeaderFooterViewReuseIdentifier:@"HDFooterView"];
        [_cartTableView registerClass:NSClassFromString(@"HDHeaderView") forHeaderFooterViewReuseIdentifier:@"HDHeaderView"];
        
        _cartTableView.dataSource = self.service;
        _cartTableView.delegate   = self.service;
        
        _cartTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
        
        _cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        
    }
    return _cartTableView;
}

- (HDCarBar*)cartBar{
    
    if (!_cartBar) {
        
        _cartBar = [[HDCarBar alloc] initWithFrame:CGRectMake(0, screenH- 156-self.StatusBarHeight-3-self.TabbarHeight, ScreenW, 50)];
        _cartBar.selectAllButton.hidden = YES;
    }
    return _cartBar;
}
//
//- (UILabel *)readLabel{
//    
//    if (!_readLabel) {
//        
//        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 3, 1)];
//        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
//        
//    }
//    return _readLabel;
//}
//
//-(OnlineShopCsarController *)onlineCarVC{
//    if (!_onlineCarVC) {
//        _onlineCarVC = [[OnlineShopCsarController alloc] init];
//        _onlineCarVC.view.frame = CGRectMake(0, 0 , ScreenW, screenH );
//        
//        [self addChildViewController:_onlineCarVC];
//    }
//    return _onlineCarVC;
//}
//-(GroupShopCarController *)groupCarVC{
//    if (!_groupCarVC) {
//        _groupCarVC =[[GroupShopCarController alloc] init];
//        
//        _groupCarVC.view.frame = CGRectMake(ScreenW, 0, ScreenW, screenH );
//        
//        [self addChildViewController:_groupCarVC];
//    }
//    return _groupCarVC;
//}
//
//
//- (void)addCategoryButton{
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 65, ScreenW, 40)];
//    
//    view.backgroundColor = [UIColor whiteColor];
//    for (int i = 0; i< 3; i++) {
//        
//        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/3.0f, 0, ScreenW/3.0f, 40)];
//        button.tag = buttonTag + i;
//        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
//        NSArray * array = @[@"线上",@"线下",@"兑换"];
//        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        [button setTitle:array[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//        [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
//        if (i == 0) {
//            
//            button.selected = YES;
//        }
//        [view addSubview:button];
//    }
//    
//    [view addSubview:self.readLabel];
//    
//    
//    [self.view addSubview:view];
//    
//
//}
//
//#pragma mark ---子视图控制器切换
//- (void)switchDetailView:(UIButton *)sender{
//    
//    UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
//    btnSelected.selected=NO;
//    
//    sender.selected=YES;
//    _index = sender.tag - buttonTag;
//    if (_index == 0) {
//        sender.selected = YES;
//        _VCScrollView.contentOffset = CGPointMake(0, 0);
//        
//        [UIView animateWithDuration:0.4 animations:^{
//            self.readLabel.frame= CGRectMake(0, sender.frame.size.height, sender.frame.size.width, 1);
//        }];
//        [_VCScrollView addSubview:self.onlineCarVC.view];
//        
//    } else if (_index ==1){
//        
//        sender.selected = YES;
//        
//        _VCScrollView.contentOffset = CGPointMake(ScreenW, 0);
//        
//        [UIView animateWithDuration:0.4 animations:^{
//            
//            self.readLabel.frame= CGRectMake(ScreenW/3.0f, sender.frame.size.height, sender.frame.size.width, 1);
//            
//        }];
//        [_VCScrollView addSubview:self.groupCarVC.view];
//        
//    }else if (_index == 2){
//        
//        _VCScrollView.contentOffset = CGPointMake(ScreenW * 2, 0);
//        
//        [UIView animateWithDuration:0.4 animations:^{
//            
//            self.readLabel.frame= CGRectMake(ScreenW/3 * 2.0f, sender.frame.size.height, sender.frame.size.width, 1);
//        }];
//        [_VCScrollView addSubview:self.cartTableView];
//
//    }
//    
//    
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    CGPoint offset = scrollView.contentOffset;
//    CGFloat x  = offset.x / 3;
//    
//    if (x >= 0 && x < scrollView.frame.size.width) {
//        
//        CGRect frame = self.readLabel.frame;
//        frame.origin.x = x;
//        self.readLabel.frame = frame;
//    }
//    
//    NSInteger currenPage =  scrollView.contentOffset.x /ScreenW;
//    
//    UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
//    
//    btnSelected.selected=NO;
//    
//    UIButton * button = [self.view viewWithTag:buttonTag + currenPage];
//    
//    button.selected=YES;
//    
//    _index = button.tag - buttonTag;
//    if (_index == 0) {
//        
//        [_VCScrollView addSubview:self.onlineCarVC.view];
//        
//    }else if (_index ==1){
//        
//        [_VCScrollView addSubview:self.groupCarVC.view];
//        
//    }else if (_index == 2){
//        
//        [_VCScrollView addSubview:self.cartTableView];
//    }
//    
//}
//
//#pragma mark -- 创建子视图控制器
//-(void)creatChildrenController{
//    
//    _VCScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 106, ScreenW, screenH )];
//    
//    //设置scrollView的代理
//    _VCScrollView.delegate = self;
//    //scrollview翻页设置
//    _VCScrollView.pagingEnabled = YES;
//    
//    _VCScrollView.contentSize = CGSizeMake(ScreenW * 3, screenH );
//    
//    [self.view addSubview:_VCScrollView];
//    
//    
//    //线上
//    [_VCScrollView addSubview:self.onlineCarVC.view];
//    
//    //    if (_ordrType == 1 || _ordrType == 0) {
//    //
//    //        _VCscrollView .contentOffset = CGPointMake(0 , 0);
//    //    }
//    //    else  if (self.ordrType == 2 ) {
//    //
//    //        _VCscrollView .contentOffset = CGPointMake(ScreenW , 0);
//    //
//    //    }else if(self.ordrType == 3){
//    //
//    //        _VCscrollView .contentOffset = CGPointMake(ScreenW * 2, 0);
//    //
//    //    }else{
//    //
//    //        _VCscrollView .contentOffset = CGPointMake(ScreenW * 3, 0);
//    //
//    //    }
//}


//移除观察者
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

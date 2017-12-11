//
//  CoverDetailViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CoverDetailViewController.h"
#import "ConvertGoodsCellModel.h"
#import "CovertDetailTableViewCell.h"
#import "CovertDetailTVCell.h"
#import "SearchCovertGoodsViewController.h"
#import "CovertDetailSelectViewController.h"
#import "ConvertVCViewController.h"
#import "HaiDuiMenu.h"
NSString * const CoverDeatailIdertifer = @"CovertDetailTableViewCell";
NSString * const CoverDeatailIdertifer3 = @"CovertDetailTVCell";
@interface CoverDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LrdSuperMenuDelegate,LrdSuperMenuDataSource>
@property(nonatomic,assign)NSInteger page;
@property(nonatomic ,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * allCategoryArray;
@property (nonatomic ,strong)NSMutableArray * allCategoryChildArray;

@property(nonatomic ,assign)NSInteger orderBy;
@property(nonatomic ,assign)NSInteger screenOrderBy;
@property (nonatomic ,assign)NSUInteger goodsClassId;
@property (nonatomic ,strong)UIView * tapBgView;
//
@property (nonatomic ,copy)NSString * lowPrice;
@property (nonatomic ,copy)NSString * highPrice;

@property (nonatomic ,strong)HaiDuiMenu * menu;
@property (nonatomic,strong)CovertDetailSelectViewController * goodsDetailSelectVC;
@property (nonatomic, strong) NSArray *classify;
@property (nonatomic ,copy)NSString * priceType;
@end

@implementation CoverDetailViewController{
    
    NSInteger _selectIndex;
    UIView * bgViewBtn;
    UITableView * _covervtTableView;
    //    用于记录，由于滑动每次都会叠加
    CGFloat _curX;
    CGFloat _width;
    UIImageView * _nullImageView;
    UILabel * _nullLabel;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)allCategoryArray{
    if (!_allCategoryArray) {
        _allCategoryArray = [[NSMutableArray alloc] init];
    }
    return _allCategoryArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSomethings:) name:@"orderBy" object:nil];
  //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSomethingsAbout:) name:@"priceDesc" object:nil];
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBgView) name:@"removeView" object:nil];
    //初始化页数和选着按钮的下标
    _page = 0;
    _selectIndex = 0;
    _orderBy = 1;
    _lowPrice = @"0";
    //列表头
    _menu = [[HaiDuiMenu alloc] initWithOrigin:CGPointMake(0, KNAV_TOOL_HEIGHT+1) andHeight:40 andClassName:_className];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self creatPrimateNavgationBar];

    
    [self creatTablewView];
    
    //第一次加载
    [self firstLoad];
    
    //初始化子视图控制器
    [self configHomeViewController];

   
}
//通知方法实现
-(void)doSomethings:(NSNotification *)cation{
    NSString * str = cation.userInfo[@"one"];
    if ([str integerValue] == 4) {
        
        [self doAnimate:ScreenW/2.0f];;
    }else{
        
    _orderBy = [str integerValue];
    _priceType = @"1";
        
    _page = 0;
    [_covervtTableView.mj_header beginRefreshing];
        
    }
}

-(void)doSomethingsAbout:(NSNotification *)cation{
    
    _priceType  = cation.userInfo[@"one"];;
 
}
-(void)removeBgView{
    
    _goodsDetailSelectVC.view.frame = CGRectMake(ScreenW, 0, ScreenW, screenH-self.TabbarHeight);
    _tapBgView.frame = CGRectMake(ScreenW, screenH, 0, 0);
}
-(void)firstLoad{
    //刷新
    _page = 0;
    [_covervtTableView.mj_header beginRefreshing];
 
}

#pragma mark -----商品详情数据请求
-(void)requestDataWithPage:(NSInteger)page{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"orderBy"] =[NSString stringWithFormat:@"%ld",_orderBy];
    
    param[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    
    param[@"integralGoodsClassId"] = _idName;
    
     param[@"isDesc"] = _priceType;
    

    
    if ([_lowPrice isEqualToString:@"0"] == NO) {
        
        param[@"miniPrice"] = _lowPrice;
        param[@"maxPrice"] = _highPrice;
    }

    
    [weakself.httpManager POST:integralGoodsCategoryUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        //状态码。呵呵感觉很s
        int i = [responseObject[@"code"] intValue];
        _nullLabel.hidden= YES;
        _nullImageView.hidden = YES;
        _covervtTableView.hidden = NO;
        
        if ([str intValue] == 1) {
            if (page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            
            NSArray * array = responseObject[@"result"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ConvertGoodsCellModel class] json:array];
            
            [weakself.dataArray addObjectsFromArray:modelArray];

        }
        [_covervtTableView.mj_header endRefreshing];
        [_covervtTableView.mj_footer endRefreshing];
        
        _covervtTableView.mj_header.hidden = NO;
        _covervtTableView.mj_footer.hidden = NO;
        if(i == 7030){
            
            //没有更多数据
            [_covervtTableView.mj_footer endRefreshingWithNoMoreData];
           
        }else if (i == 7230){
             //没有数据
            [self.dataArray removeAllObjects];
            _covervtTableView.hidden = YES;
            
            _nullImageView.hidden = NO;
            _nullLabel.hidden = NO;
            _nullImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 20);
            _nullLabel.frame = CGRectMake(0, screenH/ 2.0f + 60, ScreenW, 20);

        }
        //小于5条数据
        if (self.dataArray.count < 5) {
            //数据全部请求完毕
            _covervtTableView.mj_footer.hidden = YES;
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [_covervtTableView reloadData];
//        });
        [_covervtTableView reloadData];

      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [_covervtTableView.mj_header endRefreshing];
        [_covervtTableView.mj_footer endRefreshing];

    }];


}
#pragma mark  --- 请求全部分类数据
-(void)requestAllCategoryData{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"isNeedChildClass"] = @"1";

    [weakself.httpManager POST:integerGoodsSortUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            weakself.allCategoryArray = responseObject[@"result"];
    
    
            dispatch_async(dispatch_get_main_queue(), ^{
        
                _menu = [[HaiDuiMenu alloc] initWithOrigin:CGPointMake(0, 65) andHeight:40 andClassName:_className];
                _menu.delegate = self;
                _menu.dataSource = self;

            });
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    
}];
    
}
-(void)creatPrimateNavgationBar{
    //隐藏导航条
    self.navigationController.navigationBarHidden = YES;
    
   UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    
   UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 17+self.StatusBarHeight, 60, 50)];
   [returnButton setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];
   [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:8];
   [returnButton setTitle:@"返回" forState:UIControlStateNormal];
   [returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   returnButton.titleLabel.font = [UIFont systemFontOfSize:W2];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
   [bgView addSubview:returnButton];

    EasySearchBar * searchBar = [[EasySearchBar alloc] initWithFrame:CGRectMake(70, 26+self.StatusBarHeight, ScreenW - 80, 32)];
     searchBar.easyBackgroundColor = [UIColor colorWithHexString:BackColor];
    [bgView addSubview:searchBar];
    
    searchBar.easySearchBarPlaceholder= @"输入商品名称、品名" ;
    searchBar.searchField.delegate = self;
    [self.view addSubview:bgView];

}
//返回
-(void)returnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnBack{
   
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- tableViewDelegate
-(void)creatTablewView{
    
    _covervtTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106+self.StatusBarHeight, ScreenW, screenH - 106) style:UITableViewStylePlain];
    _covervtTableView.separatorStyle = NO;
    _covervtTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:_covervtTableView];
    [_covervtTableView registerNib:[UINib nibWithNibName:@"CovertDetailTableViewCell" bundle:nil] forCellReuseIdentifier:CoverDeatailIdertifer];
    [_covervtTableView registerNib:[UINib nibWithNibName:@"CovertDetailTVCell" bundle:nil] forCellReuseIdentifier:CoverDeatailIdertifer3];
    _covervtTableView.delegate = self;
    _covervtTableView.dataSource = self;
    
    //上拉下载
    __weak typeof(self)weakself = self;
    _covervtTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _covervtTableView.mj_footer.hidden = YES;
        _page = 0;
        [self requestAllCategoryData];

        [self requestDataWithPage:weakself.page];
        
    }];
    //下拉加载
    _covervtTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.page ++;
        [weakself requestDataWithPage:weakself.page];
        //加载全部分类数据
        
    }];
    //商品列表为空
     CGFloat imageW = 120;
    _nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
    _nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
    _nullLabel.text = @"商品列表为空";
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.textAlignment = 1;
    
    [_nullImageView setImage:[UIImage imageNamed:@"shangpin_kong@2x"]];
    [self.view addSubview:_nullImageView];
    [self.view addSubview:_nullLabel];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CovertDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CoverDeatailIdertifer3 forIndexPath:indexPath];
    cell.gspDetailLabel.hidden = YES;
    ConvertGoodsCellModel * model = self.dataArray[indexPath.row];
    cell.convertModel = model;
    return cell;
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}

#pragma mark ---初始化选择价格区间视图控制器and orderByBlock的回调
- (void)configHomeViewController {
    
    __weak typeof(self)weakself = self;
    
    //添加点击手势
    _tapBgView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW, 0, 40, screenH)];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOff:)];
    [_tapBgView addGestureRecognizer:tapGesture];
    _tapBgView.backgroundColor = [UIColor blackColor];
    _tapBgView.alpha = 0.6;
    [self.view addSubview:_tapBgView];

    _goodsDetailSelectVC = [[CovertDetailSelectViewController alloc] init];
    _goodsDetailSelectVC.view.frame = CGRectMake(ScreenW + 40, 0, ScreenW, screenH);
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_goodsDetailSelectVC.view addGestureRecognizer:pan];


    //选择区间回调
     _goodsDetailSelectVC.priceBlock = ^(NSString * lowPrice,NSString * highPrice){
         
         weakself.tapBgView.frame = CGRectMake(ScreenW, screenH, 0, 0);
         weakself.goodsDetailSelectVC.view.frame = CGRectMake(0, -screenH, ScreenW, screenH);
         _lowPrice = lowPrice;
         _highPrice = highPrice;
         _priceType = @"0";
         _orderBy = 3;
         [weakself firstLoad];

    };
    
    [self.view addSubview:_goodsDetailSelectVC.view];
}

#pragma mark ---选择价格区间
- (void)doAnimate:(CGFloat)x{
    
    [UIView animateWithDuration:0.4 animations:^{
   
        _tapBgView .frame = CGRectMake(0, 0,40, screenH);
         _goodsDetailSelectVC.view.frame = CGRectMake(40, 0, ScreenW - 40, screenH);
        [self.view bringSubviewToFront:_goodsDetailSelectVC.view];
        [self.view bringSubviewToFront:_tapBgView];
        
    } completion:nil];
    
    
}
-(void)swipeOff:(UISwipeGestureRecognizer *)gesutre{
    
   _goodsDetailSelectVC.view.frame = CGRectMake(ScreenW, 0, ScreenW, screenH);
    _tapBgView.frame = CGRectMake(ScreenW, screenH, 0, 0);
}
#pragma mark ----侧滑
-(void)pan:(UIPanGestureRecognizer *)panRecongnizer {
    CGFloat x=[panRecongnizer translationInView:self.view].x;
    NSLog(@"%lf",x);
//   _goodsDetailSelectVC.view.frame = CGRectMake(x, 0, ScreenW, screenH);
//    if (x > 40) {
//        
//        _tapBgView.frame = CGRectMake(ScreenW, screenH, 0, 0);
//        _goodsDetailSelectVC.view.frame = CGRectMake( -ScreenW, 0, ScreenW, screenH);
//
//    }
}
#pragma mark ----商品搜索
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    SearchCovertGoodsViewController * covertVC = [[SearchCovertGoodsViewController alloc] init];
    [self.view endEditing:YES];
    
    [self.navigationController pushViewController:covertVC animated:YES];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConvertGoodsCellModel * model = self.dataArray[indexPath.row];
    [User defalutManager].selectedGoodsID =[NSString stringWithFormat:@"%ld",model.id];
    
    ConvertVCViewController * goodsVC = [[ConvertVCViewController alloc] init];
    goodsVC.model = model;
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (NSInteger)numberOfColumnsInMenu:(HaiDuiMenu *)menu {
    
    return 4;
}

- (NSInteger)menu:(HaiDuiMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    return self.allCategoryArray.count;
    
}

- (NSString *)menu:(HaiDuiMenu *)menu titleForRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    if (indexPath.column == 0) {
        
        if (self.allCategoryArray.count) {
            
            return self.allCategoryArray[indexPath.row][@"className"];
            
        }else{
            return @"全部";
        }
        
        
    }else if(indexPath.column == 1) {
       
            return @"销量";
        
        
    }else if(indexPath.column == 2) {
        
        return @"价格";
    }else{
        return @"筛选";
    }
    return 0;
    
}


- (NSInteger)menu:(HaiDuiMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    if (column == 0) {
        if (self.allCategoryArray.count) {
            
            NSArray * array = self.allCategoryArray[row][@"childs"];
            
            return array.count;
            
        }
    }
    return 0;
}

- (NSString *)menu:(HaiDuiMenu *)menu titleForItemsInRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        NSArray * array = self.allCategoryArray[indexPath.row][@"childs"];

        return array[indexPath.item][@"className"];
    }
    return nil;
}

- (void)menu:(HaiDuiMenu *)menu didSelectRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        
        NSArray * array = self.allCategoryArray[indexPath.row][@"childs"];
        if (array.count) {
            
            _idName =  array[indexPath.item][@"id"];
            //重置下拉刷新开始的页数
            _page = 0;
            [_covervtTableView.mj_header beginRefreshing];
            
        }else{
            _idName  = self.allCategoryArray[indexPath.row][@"id"];
            _page = 0;
            [_covervtTableView.mj_header beginRefreshing];
        }
        
    }
}


#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

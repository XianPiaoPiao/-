//
//  CoverDetailViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDCoverDetailViewController.h"
#import "ConvertGoodsCellModel.h"
#import "CovertDetailTableViewCell.h"
#import "SearchCovertGoodsViewController.h"
#import "ConvertVCViewController.h"
#import "CovertDetailSelectViewController.h"
#import "HaiDuiMenu.h"
NSString * const CoverDeatailIdertifer2 = @"CovertDetailTableViewCell";
@interface HDCoverDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LrdSuperMenuDataSource,LrdSuperMenuDelegate>
@property(nonatomic,assign)NSInteger page;
@property(nonatomic ,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * allCategoryArray;
@property (nonatomic ,strong)NSMutableArray * allCategoryChildArray;

@property(nonatomic ,assign)NSInteger orderBy;
@property(nonatomic ,assign)NSInteger screenOrderBy;
@property (nonatomic ,assign)NSUInteger goodsClassId;
@property (nonatomic ,strong)UIView * tapBgView;
@property (nonatomic ,strong)HaiDuiMenu * menu;
@property (nonatomic,strong)CovertDetailSelectViewController * goodsDetailSelectVC;
@property (nonatomic, strong) NSArray *classify;

@end

@implementation HDCoverDetailViewController{
    NSInteger _selectIndex;
    UIView * bgViewBtn;
    UITableView * _covervtTableView;
    //用于记录，由于滑动每次都会叠加
    CGFloat _curX;
    CGFloat _width;
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
  
    //初始化页数和选着按钮的下标
    _page = 0;
    _selectIndex = 0;
    _orderBy = 1;
    _curX=self.view.center.x;
    _width= ScreenW;
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self creatPrimateNavgationBar];

//    [self creatOtherButton];
//    
//    [self creatTablewView];
//    
//    //
//    [self firstLoad];
    
   
}

-(void)firstLoad{
    
    [_covervtTableView.mj_header beginRefreshing];
    
    [self configHomeViewController];

    [self requestAllCategoryData];
 
}

//数据请求
-(void)requestDataWithPage:(NSInteger)page{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderBy"] =[NSString stringWithFormat:@"%ld",_orderBy];
    param[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    param[@"integralGoodsClassId"] = _idName;
    if (_screenOrderBy >0) {
        
    param[@"screen"] = [NSString stringWithFormat:@"%ld",_screenOrderBy];

    }
    
[weakself POST:integralGoodsCategoryUrl parameters:param success:^(id responseObject) {
    if (page == 0) {
        
        [weakself.dataArray removeAllObjects];
    }
    
    NSArray * array = responseObject[@"result"];
    
    NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ConvertGoodsCellModel class] json:array];
    
    [weakself.dataArray addObjectsFromArray:modelArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_covervtTableView reloadData];
    });
    
    [_covervtTableView.mj_header endRefreshing];
    [_covervtTableView.mj_footer endRefreshing];
} failure:^(NSError *error) {
    
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
     //   _menu = [[HaiDuiMenu alloc] initWithOrigin:CGPointMake(0, 65) andHeight:40 andClassName:_];
        _menu.delegate = self;
        _menu.dataSource = self;
        [self.view addSubview:_menu];

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
   [returnButton setImage:[UIImage imageNamed:@"s011"] forState:UIControlStateNormal];
   [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:4];
   [returnButton setTitle:@"返回" forState:UIControlStateNormal];
   [returnButton setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
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
#pragma mark ---创建分栏按钮
-(void)creatOtherButton{
    

    
    NSArray * array = @[@"销量",@"价格",@"删选"];
  
    
    NSArray * imageArray =@[@"icon-bottom-arrow-off",@"",@"exchange_icon_price_top_arrow@2x",@"exchange_icon_screen@2x"];
    NSArray * imageSelecArray = @[@"icon-top-arrow-on@2x",@"",@"exchange_icon_price_bottom_arrow@3x",@"exchange_icon_screen_on"];
    bgViewBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 65+self.StatusBarHeight, ScreenW, 40)];
    //设置背景颜色
    bgViewBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgViewBtn];
    
    for (int i =0; i< 3; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW /4.0f + i*(ScreenW/4.0f), 0, ScreenW/4.0f, 40)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageSelecArray[i]] forState:UIControlStateSelected];
        [button setImagePositionWithType:SSImagePositionTypeRight spacing:5];
       
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(CovertGoodsOnClicked:) forControlEvents:UIControlEventTouchDown];
        [bgViewBtn addSubview:button];
        //创建分割线
        UIView * stringView = [[UIView alloc] initWithFrame:CGRectMake((i+1) * ScreenW/4.0f, 5 , 2, 30)];
        stringView.backgroundColor = [UIColor colorWithHexString:BackColor];
        [bgViewBtn addSubview:stringView];
        

}

}
-(void)returnBack{
   
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- tableViewDelegate
-(void)creatTablewView{
    
    _covervtTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106, ScreenW, screenH - 106) style:UITableViewStylePlain];
    _covervtTableView.separatorStyle = NO;
    [self.view addSubview:_covervtTableView];
    [_covervtTableView registerNib:[UINib nibWithNibName:@"CovertDetailTableViewCell" bundle:nil] forCellReuseIdentifier:CoverDeatailIdertifer2];
    _covervtTableView.delegate = self;
    _covervtTableView.dataSource = self;
    
    //上拉下载
    __weak typeof(self)weakself = self;
    _covervtTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestDataWithPage:weakself.page];
        
    }];
    //下拉加载
    _covervtTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestDataWithPage:weakself.page];
        //加载全部分类数据
        
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        CovertDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CoverDeatailIdertifer2 forIndexPath:indexPath];
    ConvertGoodsCellModel * model = self.dataArray[indexPath.row];
    cell.convertModel = model;
    return cell;
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}
//button点击事件
-(void)CovertGoodsOnClicked:(UIButton *)button{
    
   UIButton * btnSelect = [bgViewBtn viewWithTag:_selectIndex + buttonTag];
        btnSelect.selected = NO;
        button.selected = YES;
    _selectIndex = button.tag - buttonTag;
    if (_selectIndex == 0) {
        
        _tapBgView .frame = CGRectMake(screenH, 0,40, screenH);

        [self firstLoad];

        button.selected = YES;
        _orderBy = _selectIndex + 1;
        
  
    }else if ( _selectIndex == 1){
        _tapBgView .frame = CGRectMake(screenH, 0,40, screenH);

        _orderBy = _selectIndex + 2;
        [self firstLoad];
        button.selected = YES;
    }
    else if (_selectIndex ==2){
        
        _tapBgView .frame = CGRectMake(screenH, 0,40, screenH);

        button.selected = YES;
        
        [self doAnimate:ScreenW/2.0f];;
        //筛选
    }

}
#pragma mark ---初始化视图控制器and orderByBlock的回调
- (void)configHomeViewController {
    
    __weak typeof(self)weakself = self;
    _goodsDetailSelectVC = [[CovertDetailSelectViewController alloc] init];
    _goodsDetailSelectVC.view.frame = CGRectMake(ScreenW, -0, ScreenW, screenH-self.TabbarHeight);
    
     _goodsDetailSelectVC.block = ^(NSString * str){
         weakself.tapBgView.frame = CGRectMake(ScreenW, screenH, 0, 0);

         _screenOrderBy = [str integerValue];
         
         weakself.goodsDetailSelectVC.view.frame = CGRectMake(0, -screenH, ScreenW, screenH);

         [weakself firstLoad];
        
     };
    
    [self.view addSubview:_goodsDetailSelectVC.view];
}


- (void)doAnimate:(CGFloat)x{
    
    [UIView animateWithDuration:0.4 animations:^{

        _goodsDetailSelectVC.view.frame = CGRectMake(40, 0, ScreenW - 40, screenH);
        _tapBgView .frame = CGRectMake(0, 0,40, screenH);
   
    } completion:nil];
    
    
}
-(void)swipeOff:(UITapGestureRecognizer *)tapgesure{
    
    _tapBgView.frame = CGRectMake(ScreenW, 0, 0, 0);
    _goodsDetailSelectVC.view.frame = CGRectMake(ScreenW, 0, 0, 0);
    
}
//跳转到搜索商品
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    SearchCovertGoodsViewController * covertVC = [[SearchCovertGoodsViewController alloc] init];
    [self.view endEditing:YES];
    
    [self.navigationController pushViewController:covertVC animated:YES];
    
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConvertGoodsCellModel * model = self.dataArray[indexPath.row];
    [User defalutManager].selectedGoodsID =[NSString stringWithFormat:@"%ld",model.id];
    
    ConvertVCViewController * goodsVC = [[ConvertVCViewController alloc] init];
    goodsVC.model = model;
    [self.navigationController pushViewController:goodsVC animated:YES];
}
- (NSInteger)numberOfColumnsInMenu:(HaiDuiMenu *)menu {
    
    return 1;
}

- (NSInteger)menu:(HaiDuiMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return self.allCategoryArray.count;
    
}

- (NSString *)menu:(HaiDuiMenu *)menu titleForRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    
    return self.allCategoryArray[indexPath.row][@"className"];
    
}

- (NSString *)menu:(HaiDuiMenu *)menu imageNameForRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    if (indexPath.column == 0 || indexPath.column == 1) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(HaiDuiMenu *)menu imageForItemsInRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(HaiDuiMenu *)menu detailTextForRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    if (indexPath.column < 2) {
        return [@(arc4random()%1000) stringValue];
    }
    return nil;
}

- (NSString *)menu:(HaiDuiMenu *)menu detailTextForItemsInRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    return [@(arc4random()%1000) stringValue];
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
  //  NSInteger row = indexPath.row;
    if (indexPath.column == 0) {
        
        NSArray * array = self.allCategoryArray[indexPath.row][@"childs"];
        
        return array[indexPath.item][@"className"];
    }
    return nil;
}

- (void)menu:(HaiDuiMenu *)menu didSelectRowAtIndexPath:(HaiDuiIndexPath *)indexPath {
    
   // NSLog(@"===========%@",self.allCategoryArray);
   // NSArray * arrray = self.allCategoryArray[indexPath.row][@"childs"];
    
    NSLog(@"===%ld ,%ld",indexPath.item,indexPath.row);
    if (indexPath.column == 0) {
        
        
        NSArray * arrray = self.allCategoryArray[indexPath.row][@"childs"];
        if (arrray.count) {
            
            _idName =  arrray[indexPath.item][@"id"];
            //重置下拉刷新开始的页数
            _page = 0;
            [self requestDataWithPage:_page];
        }else{
            
            _idName  = self.allCategoryArray[indexPath.row][@"id"];
            _page = 0;
            [self requestDataWithPage:_page];
        }
        
    }
    
}

@end

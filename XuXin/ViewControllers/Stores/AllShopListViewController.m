//
//  AllShopViewController.m
//  meituanListTest
//
//  Created by xuxin on 16/9/8.
//  Copyright © 2016年 xuxin. All rights reserved.
//

#import "AllShopListViewController.h"
#import "LrdSuperMenu.h"
#import "AllShopTableViewCell.h"
#import "shopListDetailModel.h"
#import "MuchStoreMapViewController.h"
#import "SearchShopViewController.h"
#import "ShopDetailViewController.h"

NSString * const allshopTableListIndertifer = @"AllShopTableViewCell";
@interface AllShopListViewController ()<LrdSuperMenuDataSource, LrdSuperMenuDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property(nonatomic ,strong) LrdSuperMenu * meanu;

@property (nonatomic, strong) NSArray *choose;

@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger  page;
@property (nonatomic ,assign)NSInteger OrderByclass;

@property (nonatomic ,copy)NSString * currentLocation;
@property (nonatomic ,copy)NSString * currentCity;
@property (nonatomic ,copy)NSString * classId;
@property (nonatomic ,copy)NSString * className;

@property (nonatomic ,copy)NSString * adressStr;

@property (nonatomic ,strong)UILabel * currentPositonLabel;

@property(nonatomic ,strong)NSMutableArray * cityArray;
@property (nonatomic ,strong)NSMutableArray * allClassArray;
@property (nonatomic ,strong) UITableView * shopTableView;


//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end

@implementation AllShopListViewController{
    
    UIImageView * _nullImageView;
    UILabel * _nullLabel;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)allClassArray{
    if (!_allClassArray) {
        _allClassArray = [[NSMutableArray alloc] init];
    }
    return _allClassArray;
}
-(NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [MTA trackPageViewBegin:@"AllShopListViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"AllShopListViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //初始化属性
    _page = 0;
    _currentCity = [User defalutManager].selectedCityID;

    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
   //注册通知
    //改变地址
    [self configLocationManager];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeClassName:) name:@"className" object:nil];
    //改变所选城市
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedId:) name:@"selectdCity" object:nil];
 
    
    
    [self creatShopTableView];
    
    self.choose = @[@"智能排序", @"好评优先", @"离我最近", @"人均最低",];
    //菜单
    _meanu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40 andClassName:_className];
    
    [self.view addSubview:_meanu];
    
    _meanu.delegate = self;
    
    _meanu.dataSource = self;
    
    //第一次进入页面加载数据
    [self firstLoad];
    

}
#pragma mark  ----定位成功
#pragma mark ---个人定位
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self initCompleteBlock];
    
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
    //设置允许在后台定位
    //[self.locationManager setAllowsBackgroundLocationUpdates:YES];
}

- (void)initCompleteBlock
{
    __weak typeof(self)weakself = self;
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error，则不进行annotation的添加
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //得到定位信息，添加annotation
        if (location)
        {
            
            [User defalutManager].userLocation = location;
            [weakself requestData:weakself.page];
            //定位成功
            if (regeocode)
            {
                
                NSString * addressStr = [NSString stringWithFormat:@"%@", regeocode.formattedAddress];
                
                weakself.currentPositonLabel.text = addressStr;
                
                NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:addressStr,@"textOne", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"locationed" object:nil userInfo:dic];
                
            }
            else
            {
          
                [weakself requestData:weakself.page];

            }
            
        }
    };
}


-(void)creatNavgationBar{
    

    UIView * navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenW, 44)];
    navBgview.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:navBgview];
    
    UIButton * messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 40, 10, 30, 30)];
    [messageBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchDown];
    [messageBtn setImage:[UIImage imageNamed:@"shangjia_sousuo@3x"] forState:UIControlStateNormal];
    [navBgview addSubview:messageBtn];
    
    
    UIButton * placeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [placeBtn addTarget:self action:@selector(place) forControlEvents:UIControlEventTouchDown];
    [placeBtn setImage:[UIImage imageNamed:@"shangjia_dingwei@3x"] forState:UIControlStateNormal];
    [navBgview addSubview:placeBtn];
    
    UILabel  * tittleLbel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    tittleLbel.center = CGPointMake(ScreenW/2.0f, 26);
    tittleLbel.text = @"全部商家";
    tittleLbel.textAlignment = 1;
    tittleLbel.textColor = [UIColor blackColor];
    [navBgview addSubview:tittleLbel];
    tittleLbel.font = [UIFont systemFontOfSize:16];

}
//第一次加载
-(void)firstLoad{
    
     _page = 0;
    
    [self requestCountryData];
    
    [self requestAllClassData];
    
    [_shopTableView.mj_header beginRefreshing];

}
//通知方法实现
-(void)changeClassName:(NSNotification *)cation{
    
    _classId = cation.userInfo[@"text"];
    _className = cation.userInfo[@"textTwo"];
    
    //第一次加载数据
    [self firstLoad];
}
-(void)changeSelectedId:(NSNotification *)cation{
    
    _currentCity = [User defalutManager].selectedCityID;
    [self firstLoad];
}

#pragma 加载城市分类数据
-(void)requestCountryData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"cityId"] = [User defalutManager].selectedCityID;
    
    param[@"type"] = @"0";
    
    [self.httpManager POST:countrysUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"];
            weakself.cityArray = [NSMutableArray arrayWithArray:array];
        }
      
       
        //更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            //创建菜单栏
            [weakself.shopTableView reloadData];

        });

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma 全部分类数据加载
-(void)requestAllClassData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"isNeedChildClass"] = @"1";
    param[@"isCommend"] = @"0";
     param[@"type"] = @"0";
    [self.httpManager POST:storeClassUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * array = responseObject[@"result"];
        weakself.allClassArray = [NSMutableArray arrayWithArray:array];
        //更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            //创建对象
            _meanu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40 andClassName:_className];
            [self.view addSubview:_meanu];
            
            _meanu.delegate = self;
            _meanu.dataSource = self;
          
    });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        _meanu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40 andClassName:_className];
//        [self.view addSubview:_meanu];
//        _meanu.delegate = self;
//        _meanu.dataSource = self;
        
    }];


}
//数据加载
-(void)requestData:(NSInteger)page{
    
    __weak typeof(self)weakself= self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    param[@"storeClassId"] = _classId;
    param[@"areaId"] =_currentCity;
    
    param[@"orderBy"] =[NSString stringWithFormat:@"%ld", _OrderByclass];
    param[@"longitude"] =[NSString stringWithFormat:@"%f",[User defalutManager].userLocation.coordinate.longitude];
    param[@"latitude"] =[NSString stringWithFormat:@"%f",[User defalutManager].userLocation.coordinate.latitude];
    

    [weakself.httpManager POST:storeListUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        int i = [responseObject[@"code"] intValue];
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            _nullLabel.hidden = YES;
            _nullImageView.hidden = YES;
            if (page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            NSArray * array = responseObject[@"result"];
            NSArray * shoplistArray = [NSArray yy_modelArrayWithClass:[shopListDetailModel class] json:array];
            [weakself.dataArray addObjectsFromArray:shoplistArray];
            
        }
        
        //更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.shopTableView reloadData];
            //把参数设为空
            
        });
        [weakself.shopTableView.mj_header endRefreshing];
        [weakself.shopTableView.mj_footer endRefreshing];
        weakself.shopTableView.mj_header.hidden = NO;
        weakself.shopTableView.mj_footer.hidden = NO;
        
        if(i == 7030){
            
            //没有更多数据
            [weakself.shopTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
         else  if (i == 7230){
            //没有数据
            [weakself.dataArray removeAllObjects];
            _shopTableView.mj_footer.hidden = YES;
            _nullImageView.hidden = NO;
            _nullLabel.hidden = NO;
            _nullImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 70);
            _nullLabel.frame = CGRectMake(0, screenH/ 2.0f + 20, ScreenW, 20);
            
         }else if (i == 7253){
             
             [weakself showStaus:@"请选择城市"];
         }
        
        //小于5条数据
        if (weakself.dataArray.count < 5 && weakself.dataArray.count >0) {
            //数据全部请求完毕
            weakself.shopTableView.mj_footer.hidden = YES;
            
        }else if (weakself.dataArray.count == 0){
            
            [weakself.shopTableView.mj_footer endRefreshing];
            
        }
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self showStaus:@"网络错误"];
        [weakself.shopTableView.mj_header endRefreshing];
        [weakself.shopTableView.mj_footer endRefreshing];
        //将自增的page减下来
        if(weakself.page > 0){
            weakself.page--;
        }
    }];
    
    
}
#pragma mark ---- 地图定位
-(void)place{
    
    MuchStoreMapViewController * mapVC =[[MuchStoreMapViewController alloc] init];
    mapVC.userLocation = [User defalutManager].userLocation;
    //商家地址
    
    [self.navigationController pushViewController:mapVC animated:YES];
}
//搜索
-(void)search{
    
    SearchShopViewController * searchVC = [[SearchShopViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
//创建商家tableView
-(void)creatShopTableView{
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0,  0 , 0, 40  )];
    [self.view addSubview:bgView];
    _currentPositonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 40 , 40 )];
   
    [_currentPositonLabel setText:@"正在定位中..."];
    
    [_currentPositonLabel setTextColor:[UIColor colorWithHexString:WordDeepColor]];
    [_currentPositonLabel setFont:[UIFont systemFontOfSize:14]];
    
    UIButton * buton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 40 * ScreenScale, 0 , 36 , 40)];
    [buton setImage:[UIImage imageNamed:@"bus-icon-refurbish@2x"] forState:UIControlStateNormal];
    [bgView addSubview:_currentPositonLabel];
    [bgView addSubview:buton];
    bgView.backgroundColor = [UIColor colorWithHexString:BackColor];
  
    _shopTableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 104, ScreenW, screenH - 104 - 49) style:UITableViewStylePlain];
    _shopTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    //上拉下载
    __weak typeof(self)weakself = self;
    _shopTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //  加载全部分类数据
      //  [weakself requestAllClassData];
        //  加载城市分类数据
    //    [weakself requestCountryData];
       _shopTableView.mj_footer.hidden = YES;

        weakself.page = 0;
        [weakself requestData:weakself.page];
     
    }];
    //下拉加载
    _shopTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        

        weakself.page ++;
        [weakself requestData:weakself.page];
   
    }];
    _shopTableView.tableHeaderView = bgView;
    [self.view addSubview:_shopTableView];
    
    //去掉分给线
    _shopTableView.separatorStyle = NO;
    _shopTableView.delegate = self;
    _shopTableView.dataSource =self;
    [_shopTableView registerNib:[UINib nibWithNibName:@"AllShopTableViewCell" bundle:nil] forCellReuseIdentifier:allshopTableListIndertifer];
    //没有商家
    CGFloat imageW = 120;
    _nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
    _nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
    _nullLabel.text = @"没有更多商家";
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.textAlignment = 1;
    
    [_nullImageView setImage:[UIImage imageNamed:@"shangjia_kong@2x"]];
    [_shopTableView addSubview:_nullImageView];
    [_shopTableView addSubview:_nullLabel];
}
#pragma ------------- UitableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllShopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:allshopTableListIndertifer forIndexPath:indexPath];
    cell.selectionStyle = NO;
    
    cell.model = self.dataArray[indexPath.row];
       return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140 ;
}

#pragma mark ---- 点击cell跳转详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    shopListDetailModel * model = self.dataArray[indexPath.row];
    
    [User defalutManager].selectedShop = [NSString stringWithFormat:@"%ld", model.idName];
    
    UIStoryboard * storybord =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController * MyVC = [storybord instantiateViewControllerWithIdentifier:@"ShopDetailViewController"] ;
    
    [self.navigationController pushViewController:MyVC animated:YES];
    
    
}
//设置菜单
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    
    return 3;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        
        if (self.allClassArray.count) {
            
            return self.allClassArray.count;

    }

}
    else if(column == 1) {
        
        if (self.cityArray.count) {
            
    return self.cityArray.count;

}
        
 }else {
       
        return self.choose.count;
    }
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
        

        
        if (self.allClassArray.count) {
            
           
        return self.allClassArray[indexPath.row][@"className"];
        
        }else{
            
            return @"全部";
            
        }
        
        
    }else if(indexPath.column == 1) {
        if (self.cityArray.count) {
            
            return self.cityArray[indexPath.row][@"areaName"];

        }else{
            
            return @"全城";
        }
        
    }else {
        
        return self.choose[indexPath.row];
    }
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageNameForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 || indexPath.column == 1) {
        return nil;
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return nil;
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForRowAtIndexPath:(LrdIndexPath *)indexPath {

    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    
    return nil;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    if (column == 0) {
     
        if (self.allClassArray.count) {
        NSArray * array = self.allClassArray[row][@"childs"];

            return array.count;

        }
      
        
    } else if (column ==1){
        return 0;
}
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
   
    if (indexPath.column == 0) {
        
    NSArray * array = self.allClassArray[indexPath.row][@"childs"];
    
        return array[indexPath.item][@"className"];
        
    } else if (indexPath.column == 1){
        return nil;
    }
    return nil;
}
//分类列表点击事件
- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
        
      NSArray * arrray = self.allClassArray[indexPath.row][@"childs"];
        if (arrray.count) {
            
            _classId =  arrray[indexPath.item][@"id"];
            //重置下拉刷新开始的页数
            _page = 0;
            
            [_shopTableView.mj_header beginRefreshing];
            
        }else{
            
            _classId  = self.allClassArray[indexPath.row][@"id"];
             _page = 0;
            [_shopTableView.mj_header beginRefreshing];
        }

    
    }else if (indexPath.column == 1){
        
        _currentCity = self.cityArray[indexPath.row][@"id"];
         _page = 0;
        [_shopTableView.mj_header beginRefreshing];
  
    }
    else {
        
         _OrderByclass = indexPath.row ;
         _page = 0;
        [_shopTableView.mj_header beginRefreshing];
    }
}

//移除观察者
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

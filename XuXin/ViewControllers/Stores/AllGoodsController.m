//
//  AllGoodsController.m
//  XuXin
//
//  Created by xuxin on 17/3/23.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "AllGoodsController.h"
#import "LrdSuperMenu.h"
#import "CovertDetailTableViewCell.h"
#import "OnlineGoodsModel.h"
#import "ShopsGoodsBaseController.h"
NSString * const goodsListCellIndeifer = @"CovertDetailTableViewCell";
@interface AllGoodsController ()<LrdSuperMenuDataSource, LrdSuperMenuDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property(nonatomic ,strong) LrdSuperMenu * meanu;

@property (nonatomic, strong) NSArray *choose;
@property (nonatomic ,strong)NSArray * saleArray;
@property (nonatomic ,strong)NSArray * priceArray;

@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger  page;
//
@property (nonatomic ,assign)NSInteger OrderByclass;
@property (nonatomic ,assign)NSInteger priceBy;

@property (nonatomic ,copy)NSString * classId;
@property (nonatomic ,copy)NSString * className;

@property (nonatomic ,copy)NSString * adressStr;

@property (nonatomic ,strong)UILabel * currentPositonLabel;

@property(nonatomic ,strong)NSMutableArray * cityArray;

@property (nonatomic ,strong)NSMutableArray * allClassArray;

@property (nonatomic ,assign)NSInteger isSale;
//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic ,strong)UITableView * goodsListTableView;
@end

@implementation AllGoodsController{
    
//显示图片
    UIImageView * _nullImageView;
    UILabel * _nullLabel;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //初始化属性
    _page = 0;
    //
    self.choose = @[@"价格筛选", @"0-100", @"101-500", @"501-1000",@"1001-5000",@"5000以上"];
    self.saleArray = @[@"销量筛选",@"从高到低",@"从低到高"];
   // self.priceArray = @[@"价格",@"从高到低",@"从低到高"];
    
    self.classId = @"0";
    
    _priceBy = 0;
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    //注册通知
    //个人定位
 //  [self configLocationManager];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(located:) name:@"locationed" object:nil];
    
    [self creatShopTableView];
 
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
            
            if (regeocode)
            {
                
                NSString * addressStr = [NSString stringWithFormat:@"%@", regeocode.formattedAddress];
                
                weakself.currentPositonLabel.text = addressStr;
                
            }
            
            
        }
    };
}


//第一次加载
-(void)firstLoad{
    
    _page = 0;
    
    //加载全部分类
    [self requestAllClassData];
    
    [_goodsListTableView.mj_header beginRefreshing];
    
}
//通知方法实现
-(void)located:(NSNotification *)cation{
    
    _currentPositonLabel.text = cation.userInfo[@"textOne"];
    
}

#pragma 全部分类数据加载
-(void)requestAllClassData{
    
    __weak typeof(self)weakself = self;
   // NSMutableDictionary * param = [NSMutableDictionary dictionary];
  
    [self.httpManager POST:onlineGoodsClassUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
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

        
    }];
    
    
}
//数据加载
-(void)requestData:(NSInteger)page{
    
    __weak typeof(self)weakself= self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    
    param[@"goodsClassId"] = _classId;
    
    param[@"order"]  = [NSString stringWithFormat:@"%ld",_isSale];

    
    param[@"Desc"] = [NSString stringWithFormat:@"%ld",_OrderByclass];
    
    param[@"screen"] = [NSString stringWithFormat:@"%ld",_priceBy];
    
    param[@"type"] = @"1";
    
    [weakself.httpManager POST:goodsListUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
            NSArray * shoplistArray = [NSArray yy_modelArrayWithClass:[ONLINEgoodsModel class] json:array];
            
            [weakself.dataArray addObjectsFromArray:shoplistArray];
            
        }
        
        //更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.goodsListTableView reloadData];
            //把参数设为空
            
        });
        [weakself.goodsListTableView.mj_header endRefreshing];
        [weakself.goodsListTableView.mj_footer endRefreshing];
        weakself.goodsListTableView.mj_header.hidden = NO;
        weakself.goodsListTableView.mj_footer.hidden = NO;
        
        if(i == 7030){
            
            //没有更多数据
            [weakself.goodsListTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        else  if (i == 7230){
            //没有数据
            [weakself.dataArray removeAllObjects];
            weakself.goodsListTableView.mj_footer.hidden = YES;
            
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
            weakself.goodsListTableView.mj_footer.hidden = YES;
            
        }else if (weakself.dataArray.count == 0){
            
            [weakself.goodsListTableView.mj_footer endRefreshing];
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self showStaus:@"网络错误"];
        [weakself.goodsListTableView.mj_header endRefreshing];
        [weakself.goodsListTableView.mj_footer endRefreshing];
        //将自增的page减下来
        if(weakself.page > 0){
            weakself.page--;
        }
    }];
    
    
}

//创建商家tableView
-(void)creatShopTableView{
    
//    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0,  0 , 0, 40  )];
//    [self.view addSubview:bgView];
//    _currentPositonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 40 , 40 )];
//
//    [_currentPositonLabel setText:@"正在定位中..."];
//
//    [_currentPositonLabel setTextColor:[UIColor colorWithHexString:WordDeepColor]];
//    [_currentPositonLabel setFont:[UIFont systemFontOfSize:14]];
    
//    UIButton * buton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 40 * ScreenScale, 0 , 36 , 40)];
//    [buton setImage:[UIImage imageNamed:@"bus-icon-refurbish@2x"] forState:UIControlStateNormal];
//    [bgView addSubview:_currentPositonLabel];
//    [bgView addSubview:buton];
//    bgView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _goodsListTableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 104, ScreenW, screenH - 104 - 49) style:UITableViewStylePlain];
    _goodsListTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    //上拉下载
    __weak typeof(self)weakself = self;
    _goodsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //  加载全部分类数据
      //  [weakself requestAllClassData];
        
        weakself.goodsListTableView.mj_footer.hidden = YES;
        
        _page = 0;
        [weakself requestData:weakself.page];
        
    }];
    //下拉加载
    _goodsListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        weakself.page ++;
        [weakself requestData:weakself.page];
        
    }];
//    _goodsListTableView.tableHeaderView = bgView;
    [self.view addSubview:_goodsListTableView];
    
    //去掉分给线
    weakself.goodsListTableView.separatorStyle = NO;
    weakself.goodsListTableView.delegate = self;
    weakself.goodsListTableView.dataSource =self;
    
    [weakself.goodsListTableView registerNib:[UINib nibWithNibName:@"CovertDetailTableViewCell" bundle:nil] forCellReuseIdentifier:goodsListCellIndeifer];
    //没有商家
    CGFloat imageW = 120;
    _nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
    _nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
    _nullLabel.text = @"没有更多商品";
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.textAlignment = 1;
    
    [_nullImageView setImage:[UIImage imageNamed:@"shangjia_kong@2x"]];
    [weakself.goodsListTableView addSubview:_nullImageView];
    [weakself.goodsListTableView addSubview:_nullLabel];
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
    
    CovertDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsListCellIndeifer forIndexPath:indexPath];
    cell.selectionStyle = NO;
    
    ONLINEgoodsModel * model = self.dataArray[indexPath.row];
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    cell.goodNumberLabel.text = [NSString stringWithFormat:@"%ld人付款",model.goods_salenum];
    
    cell.goodsDescribeLabel.text = model.goods_name;
    cell.saleNumberLabel.text = [NSString stringWithFormat:@"￥%.2f",model.goods_price];
    cell.saleNumberLabel.textColor = [UIColor colorWithHexString:MainColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105 ;
}

#pragma mark ---- 点击cell跳转详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ONLINEgoodsModel * model = self.dataArray[indexPath.row];
    
    
    ShopsGoodsBaseController * goodsVC =  [[ShopsGoodsBaseController alloc] init];
    goodsVC.goodsId = model.id;
    goodsVC.goodsType = 1;
    
    [self.navigationController pushViewController:goodsVC animated:YES];
    
    
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
        
        if (self.saleArray.count) {
            
        return self.saleArray.count;
            
        }
        
    }
    else {
        
        return self.choose.count;
    }
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
        
        
        
        if (self.allClassArray.count) {
            
            
            return self.allClassArray[indexPath.row][@"className"];
            
        }else{
            
            return @"分类";
            
        }
        
        
    }else if(indexPath.column == 1) {
        
        return self.saleArray[indexPath.row];
        
    }
    else {
        
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

-(NSString *)menu:(LrdSuperMenu *)menu titleForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    
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
            
            [_goodsListTableView.mj_header beginRefreshing];
            
        }else{
            
            _classId  = self.allClassArray[indexPath.row][@"id"];
            _page = 0;
            [_goodsListTableView.mj_header beginRefreshing];
        }
        
        
    }else if (indexPath.column == 1){
        
        if (indexPath.row == 1 || indexPath.row == 0) {
            
            _OrderByclass = 1 ;
            //销量
            _isSale = 1;
         
            
        }else if (indexPath.row ==2){
            
            _OrderByclass = 0;
            //销量
            _isSale = 1;

        }

        _page = 0;
        [_goodsListTableView.mj_header beginRefreshing];

    }
//    else if (indexPath.column == 2){
//        if (indexPath.row == 1 || indexPath.row == 0) {
//            
//            _OrderByclass = 1 ;
//            //销量
//            _isSale = 2;
//            
//            
//        }else if (indexPath.row ==2){
//            
//            _OrderByclass = 0;
//            //销量
//            _isSale = 2;
//            
//        }
//        
//        _page = 0;
//        
//        [_goodsListTableView.mj_header beginRefreshing];
//        
//        
//    
//    }
    else{
    
        //价格选择
        _isSale = 2;
        
        _priceBy =10 * indexPath.row ;
        
        _page = 0;
        

        [_goodsListTableView.mj_header beginRefreshing];
    }
}

//移除观察者
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

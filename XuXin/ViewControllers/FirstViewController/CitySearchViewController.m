//
//  CitySearchViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CitySearchViewController.h"
#import "CityListTableViewCell.h"
#import "CityListHeaderVIew.h"
#import "CityListModel.h"
#import "CitySmallListTableViewCell.h"
NSString * cityListTableIndertifer = @"CityListTableViewCell";
NSString * cityListSmallIndertfier = @"CitySmallListTableViewCell";
@interface CitySearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * leastCityArray;
@property (nonatomic ,strong)NSMutableArray * allCityArray;

@property (nonatomic ,copy)NSString * cityName;
@property (nonatomic ,copy)NSString * cityId;

@end

@implementation CitySearchViewController{
    
    UITableView * _tabbleViw;
    UIButton * _selfPlaceBtn;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self creatNavgationBar];
    
    [self creatUI];
    
    [self firstLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelfPlace) name:@"loctionedCity" object:nil];

}

-(void)updateSelfPlace{
    
     _cityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfLocationCityId"];
    
     _cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfLocationName"];
    
     [_selfPlaceBtn setTitle:_cityName forState:UIControlStateNormal];

}
-(NSMutableArray *)leastCityArray{
    
    if (!_leastCityArray) {
        
        _leastCityArray = [[NSMutableArray alloc] initWithCapacity:6];
     
    }
    return _leastCityArray;
}

-(NSMutableArray *)allCityArray{
    
    if (!_allCityArray) {
        
        _allCityArray = [[NSMutableArray alloc] init];
    }
    return _allCityArray;
}

-(void)creatNavgationBar{
    //状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBegView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.center = CGPointMake(ScreenW/2.0f, 42);
    label.textAlignment = 1;
    [label setText:@"全城"];
    
    UIButton * button= [[UIButton alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 60, 44)];
    
    [button setImagePositionWithType:SSImagePositionTypeLeft spacing:6];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    //添加点击事件
    [button addTarget:self action:@selector(returnMainVC) forControlEvents:UIControlEventTouchDown];
    [navBegView addSubview:label];
    [navBegView addSubview:button];
    [self.view addSubview:navBegView];
   
}
//
-(void)firstLoad{
    
    [self requestData];
 
}

-(void)returnMainVC{

    [self dismissViewControllerAnimated:YES completion:nil];
}
//数据请求
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    [weakself POST:openCityListUrl parameters:nil success:^(id responseObject) {
        
        NSArray * array = responseObject[@"result"];
        
        
        NSArray * cityListModelArray = [NSArray yy_modelArrayWithClass:[CityListModel class] json:array];
        
        weakself.allCityArray = [NSMutableArray arrayWithArray:cityListModelArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tabbleViw reloadData];
            //刷新UI
        });

    } failure:^(NSError *error) {
        

    }];
 
    
}
-(void)creatUI{
    
    _tabbleViw = [[UITableView alloc] initWithFrame:CGRectMake(0, 65+self.StatusBarHeight, ScreenW, screenH - 65-self.TabbarHeight-self.StatusBarHeight ) style:UITableViewStyleGrouped];
    [_tabbleViw registerNib:[UINib nibWithNibName:@"CityListTableViewCell" bundle:nil] forCellReuseIdentifier:cityListTableIndertifer];
    [_tabbleViw registerNib:[UINib nibWithNibName:@"CitySmallListTableViewCell" bundle:nil] forCellReuseIdentifier:cityListSmallIndertfier];
   
    _tabbleViw.delegate = self;
    _tabbleViw.dataSource = self;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20,  40)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"当前城市:";
    label.textColor = [UIColor blackColor];
    [headerView addSubview:label];
 
    _tabbleViw.sectionFooterHeight = 0;
    _tabbleViw.tableHeaderView = headerView;
    [self.view addSubview:_tabbleViw];
}
#pragma mark --TableViewDelegate;
//设置section的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
  if (section == 0) {

        CityListHeaderVIew * sectionView = [[CityListHeaderVIew alloc] init];
        [sectionView addTitle:@"定位城市"];
        sectionView.backgroundColor = [UIColor colorWithHexString:BackColor];
        return sectionView;
      
    } else if (section ==1){
        
        CityListHeaderVIew * sectionView = [[CityListHeaderVIew alloc] init];
        [sectionView addTitle:@"可选城市"];
        sectionView.backgroundColor = [UIColor colorWithHexString:BackColor];
        
        return sectionView;
        
    }
     return 0;
}
//设置section的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (section > 0) {
            
    return self.allCityArray.count;
     
    }
 
 
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        CityListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cityListTableIndertifer forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:BackColor];
        CGFloat btnW = (ScreenW -40)/3.0f;
        _selfPlaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 , 5, btnW, 30)];
        _selfPlaceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_selfPlaceBtn setImage:[UIImage imageNamed:@"shangjia_dizhi@3x"] forState:UIControlStateNormal];
        [_selfPlaceBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:6];
        
        _cityName = @"重庆市";
         _cityId = @"4524461";
        
        [_selfPlaceBtn setTitle:_cityName forState:UIControlStateNormal];
        
        _selfPlaceBtn.backgroundColor = [UIColor whiteColor];
        
        [_selfPlaceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selfPlaceBtn addTarget:self action:@selector(selfLocated) forControlEvents:UIControlEventTouchDown];
        
      
        [cell.contentView addSubview:_selfPlaceBtn];
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        CitySmallListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cityListSmallIndertfier forIndexPath:indexPath];
        CityListModel * model = self.allCityArray[indexPath.row];
        cell.textLabel.text = model.name;
      
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        return cell;
   
    }
    return 0;
    
}
#pragma mark ---选择定位位置
-(void)selfLocated{

    [User defalutManager].selectedCityID = _cityId;
    [User defalutManager].selectedCityName = _cityName;
    //保存到本地
    [[NSUserDefaults standardUserDefaults] setObject:_cityId forKey:@"currentCityId"];
    [[NSUserDefaults standardUserDefaults] setObject:_cityName forKey:@"currentCityName"];
    
    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectdCity" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
   if (indexPath.section == 1) {
 
        CityListModel * model = self.allCityArray[indexPath.row];
        
        [User defalutManager].selectedCityID = model.idName;
        //保存到本地
        [[NSUserDefaults standardUserDefaults] setObject:model.idName forKey:@"currentCityId"];
        [[NSUserDefaults standardUserDefaults] setObject:model.name forKey:@"currentCityName"];
        //通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectdCity" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark --移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

//
//  HDMainViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDMainViewController.h"
#import "CitySearchViewController.h"
#import "AllStoreAndGoodsBaseController.h"
#import "XXUiNavigationController.h"
//cell
//#import "RecommodMarkCell.h"
#import "AllShopTableViewCell.h"
#import "CovertDetailTableViewCell.h"

#import "ShopDetailViewController.h"
#import "SpecialTableViewCell.h"
#import "AllShopListViewController.h"
#import "MessageViewController.h"
#import "SearchShopViewController.h"
#import "RecomodRankBaseViewController.h"
#import "AllStoreAndGoodsBaseController.h"
//三方
#import "HDConvertButton.h"
#import <AVFoundation/AVFoundation.h>
#import "UIButton+WebCache.h"
#import "ZenKeyboard.h"
#import "RegisterField.h"
#import "ScanQrcodeController.h"
#import "LoLStoreViewController.h"
#import "HtmWalletPaytypeController.h"
//model
#import "AdervertModel.h"
#import "recmondShopModel.h"
#import "StoreClassModel.h"
#import "ONLINEgoodsModel.h"

#import "CordChargeViewController.h"
#import "ReconmendFriendsViewController.h"
#import "RecommondStoreBaseController.h"
#import "JionHaiduiBeforeController.h"
#import "YwywViewController.h"
#import "LandingViewController.h"
#import "ShopsGoodsBaseController.h"
NSString * const ReconmendGoodIndertfier2 = @"AllShopTableViewCell";//@"RecommodMarkCell";
NSString * const recomondGoodsIndertifer = @"CovertDetailTableViewCell";
@interface HDMainViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate,AMapLocationManagerDelegate,UIAlertViewDelegate,UITabBarControllerDelegate>

@property(nonatomic ,strong)UITableView * mainTableView;
@property (nonatomic ,strong)UIScrollView * imageScrollView;
@property (nonatomic ,strong)NSMutableArray * dataArray;

@property (nonatomic ,strong)NSMutableArray * recomondGoodsShopaArray;

@property (nonatomic ,strong)NSMutableArray * recomondShopaArray;
@property (nonatomic ,strong)NSMutableArray * shopCategoryArray;
@property (nonatomic ,strong)NSMutableArray * scrollImageArray;
@property (nonatomic ,strong)NSMutableArray * normalImages;
@property (nonatomic ,strong)NSMutableArray * refreshImages;

@property (nonatomic ,copy)NSString * cityName;
@property (nonatomic ,copy)NSString * locationCity;
@property (nonatomic ,copy)NSString * cityID;

@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,strong)UILabel * readLabel;

@property (nonatomic ,assign)NSInteger categoryPage;
@property (nonatomic ,assign)NSInteger imagePage;

@property (nonatomic ,assign)NSInteger tapIndex;


//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end

@implementation HDMainViewController{
    //轮播
    NSTimer * _timer;
    UIPageControl * _pageControl;
    UIPageControl * _categoryControl;
    //扫描
    AVCaptureSession * _session;
    AVCaptureVideoPreviewLayer * _layer;
    
    RegisterField * _moneytextField;
    //城市定位
    UIButton * _placeBtn;
    
    ZenKeyboard * _keyboardView;
    
    UIScrollView * _categorySrollView;
    
    UIButton * _messageBtn;
}
#pragma mark --- 懒加载
- (UILabel *)readLabel{
    
    if (!_readLabel) {
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 2, 1)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)recomondShopaArray{
    if (!_recomondShopaArray) {
        
        _recomondShopaArray = [[NSMutableArray alloc] init];
    }
    return _recomondShopaArray;
}
-(NSMutableArray *)recomondGoodsShopaArray{
    if (!_recomondGoodsShopaArray) {
        
        _recomondGoodsShopaArray = [[NSMutableArray alloc] init];
    }
    return _recomondGoodsShopaArray;
}
-(NSMutableArray *)shopCategoryArray{
    if (!_shopCategoryArray) {
        
        _shopCategoryArray =[[ NSMutableArray alloc] init];
    }
    return _shopCategoryArray;
}
-(NSMutableArray *)ScrollImageArray{
    if (!_scrollImageArray) {
        
        _scrollImageArray = [[NSMutableArray alloc] init];
    }
    return _scrollImageArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.view.window.backgroundColor = [UIColor whiteColor];
    
//    self.view.backgroundColor = [UIColor colorWithHexString:MainColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    [UIApplication sharedApplication].statusBarHidden = NO;

    //角标
    [User defalutManager].bage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"badge"] integerValue];
    
    if ([User defalutManager].bage > 0) {
        
        
        [_messageBtn setImage:[UIImage imageNamed:@"Red-Icon-2"] forState:UIControlStateNormal];
        
    }else{
        
         [_messageBtn setImage:[UIImage imageNamed:@"XX@2x.png"] forState:UIControlStateNormal];
        
    }
    
    [MTA trackPageViewBegin:@"HDMainViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [MTA trackPageViewEnd:@"HDMainViewController"];
}

-(void)viewDidLoad{
    
    self.tabBarController.delegate = self;
    //个人定位
    [self configLocationManager];
    
    //设置导航栏
    [self creatNavigationBar];
    
    
    [self creatUI];
    
    //本地数据
    [self loadLocalData];
    
    //去调用登录，登录成功再去加载数据。不然自动登录不起，后台说的。


    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]){
        
        [self land];

    }else{
        
        [self firstLoad];
    }
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityName) name:@"selectdCity" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageComing) name:@"messageComing" object:nil];
  
    
    //轮播图
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(slider) userInfo:nil repeats:YES];
    //加到runloop里面
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

-(BOOL)fd_prefersNavigationBarHidden {
    
    return YES;
}
//图片滚动
-(void)slider{
    
    _pageControl.currentPage = _imagePage;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _imageScrollView.contentOffset = CGPointMake((_imagePage+1)*ScreenW, 0);
    }];
    if (_imagePage> self.scrollImageArray.count) {
        
        _imageScrollView.contentOffset = CGPointMake(ScreenW, 0);
    }
}

#pragma mrak  ----scrollViewwDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //开起定时器
    if (scrollView == _imageScrollView) {
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
           [_timer setFireDate:[NSDate distantPast]];
            
        });

    }
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _imageScrollView) {
        
        CGPoint point = scrollView.contentOffset;
        
        
        NSUInteger currentPage = point.x/_imageScrollView.frame.size.width;
        if (_imagePage> self.scrollImageArray.count) {
            
            _imageScrollView.contentOffset = CGPointMake(ScreenW, 0);
        }
        
        _pageControl.currentPage = currentPage;
        
        _imagePage = currentPage;
        
    }else  if (scrollView == _categorySrollView) {
        
        CGPoint point = scrollView.contentOffset;
        NSUInteger currentPage = point.x/_categorySrollView.frame.size.width;
        _categoryControl.currentPage = currentPage;
        _categoryPage = currentPage;
        
    }

}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _imageScrollView) {
        
        [_timer setFireDate:[NSDate distantFuture]];

    }

}
-(void)chagePage:(UIPageControl *)page{
    
    float x= page.currentPage * _imageScrollView.frame.size.width;
    [_imageScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}
#pragma mark ---加载本地数据
-(void)loadLocalData{
    
    NSDictionary * dic = [HaiduiArchiverTools unarchiverObjectByKey:@"storeClassCache" WithPath:@"storeClass.plist"];
    
    if (dic) {
        
        NSArray * array = dic[@"result"];
        
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[StoreClassModel class] json:array];
        
        self.shopCategoryArray = [NSMutableArray arrayWithArray:modelArray];
        
    }
}
//进入界面刷新
-(void)firstLoad{
    
    [self.mainTableView.mj_header beginRefreshing];

}

#pragma mark ---登录

-(void)land{
    
   
        NSMutableDictionary * param =[NSMutableDictionary dictionary];
    
        param[@"userName"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
      
        NSString * sString = [[NSUserDefaults standardUserDefaults] objectForKey:@"userSecret"];
        
        NSString * secString = sString;
        
        param[@"password"] = secString;

    [self POST:landUrl parameters:param success:^(id responseObject) {
           
            [self firstLoad];
           

           NSString * str = responseObject[@"isSucc"];
           
           if ([str intValue] == 1) {
               
               NSDictionary * dic = responseObject[@"result"][@"user"];
               
               //兑换
               [User defalutManager].shopcart = [dic[@"ig_count"] integerValue];
               //线上
               [User defalutManager].lineShopCart = [dic[@"shopcart"] integerValue];
               
               [User defalutManager].integral  = [dic[@"integral"] integerValue];
               
               [User defalutManager].preDeposit = [dic[@"preDeposit"] floatValue];
               //用户id
               [User defalutManager].id = dic[@"id"];
               
               [User defalutManager].balance = [dic[@"balance"] floatValue];
               //红包
               [User defalutManager].redPacket = [dic[@"redPacket"] integerValue];
               
               [User defalutManager].userName = dic[@"userName"];
               
               NSString * birthday = dic[@"birthday"];
               
               if(birthday != nil)
               {
                   
                [User defalutManager].birthday = [dic[@"birthday"] longLongValue];
               };
               
               [User defalutManager].sex = [dic[@"sex"] integerValue];
               
               [User defalutManager].photo = dic[@"photo"];
               
               NSString * str = responseObject[@"result"][@"hasReceiveAddress"];
               
               [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"hasAddress"];
           
       }
           
    } failure:^(NSError *error) {
        
            [self firstLoad];

    }];
      
}


-(void)creatNavigationBar{
    
    UIView * navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBgview.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.view addSubview:navBgview];
    
    _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 40, 25+self.StatusBarHeight, 30, 30)];
    [_messageBtn addTarget:self action:@selector(messageVC) forControlEvents:UIControlEventTouchDown];
    [_messageBtn setImage:[UIImage imageNamed:@"XX@2x.png"] forState:UIControlStateNormal];
    [navBgview addSubview:_messageBtn];
    
    //二维码扫描
    UIButton * scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW -80, 25+self.StatusBarHeight, 30, 30)];
    [scanBtn setImage:[UIImage imageNamed:@"SM@2x"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanErque) forControlEvents:UIControlEventTouchDown];
    [navBgview addSubview:scanBtn];
    
    //城市定位
     _placeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 25+self.StatusBarHeight, 60, 30)];
    
    [_placeBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    
    //
    NSString * cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityName"];
    
    if (cityName == nil) {
        
         [_placeBtn setTitle:@"重庆市" forState:UIControlStateNormal];
         [[NSUserDefaults standardUserDefaults] setObject:@"重庆市" forKey:@"currentCityName"];
         [[NSUserDefaults standardUserDefaults] setObject:@"4524461" forKey:@"currentCityId"];
          [User defalutManager].selectedCityID = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityId"];
    }else{
        
        [_placeBtn setTitle:cityName forState:UIControlStateNormal];
        
         [User defalutManager].selectedCityID = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityId"];
    }
    
    NSString * cityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityId"];
    
    if (cityId == nil) {
        
        [User defalutManager].selectedCityID = @"4524461";
    }
     _placeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_placeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //添加点击事件
    [_placeBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchDown];
    
    //创建图片
    UIImageView * cityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 37+self.StatusBarHeight, 12, 8)];
    cityImageView.image = [UIImage imageNamed:@"D@2x"];
    
    [navBgview addSubview:cityImageView];
    
    [navBgview addSubview:_placeBtn];
    
    //搜索框
    EasySearchBar * searchBar = [[EasySearchBar alloc] initWithFrame:CGRectMake(80, 26+self.StatusBarHeight, ScreenW - 170 , 32)];
    
    searchBar.searchField.delegate = self;
    
    [navBgview addSubview:searchBar];
    searchBar.easySearchBarPlaceholder = @"输入商家、商品";
    
}

-(void)creatUI{
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.StatusBarHeight+64,ScreenW , screenH -64 -49) style:UITableViewStyleGrouped];
    
    _mainTableView.separatorStyle = NO;
    _mainTableView.sectionHeaderHeight = 4;
    _mainTableView.sectionFooterHeight = 4;
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [_mainTableView registerNib:[UINib nibWithNibName:@"CovertDetailTableViewCell" bundle:nil] forCellReuseIdentifier:recomondGoodsIndertifer];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"AllShopTableViewCell" bundle:nil] forCellReuseIdentifier:ReconmendGoodIndertfier2];
    
    __weak typeof(self)weakself = self;
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //图片
        [weakself requestImageData];
        //推荐商家
        [weakself requestData];
        //分类
        [weakself requestShopCategoryData];
        
    }];
}

#pragma mark ---通知
-(void)messageComing{
    
    MessageViewController * messageVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:NO];
    
}
#pragma mark ----二维码扫描
-(void)scanErque{
    
        ScanQrcodeController * scanQrcodeVC =[[ScanQrcodeController alloc] init];
        scanQrcodeVC.priceValue = _moneytextField.text;

        [self.navigationController pushViewController:scanQrcodeVC animated:YES];
  
}
#define mark -- 获取首页轮播图
-(void)requestImageData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"value"] = @"1";
    
    [weakself POST:advertsUrl parameters:param success:^(id responseObject) {
        
        NSArray * array = responseObject[@"result"];
        NSArray * recomondModelArray = [NSArray yy_modelArrayWithClass:[AdervertModel class] json:array];
        
        //加载时让它替换掉数据源
        weakself.scrollImageArray = [NSMutableArray arrayWithArray:recomondModelArray];
        
        //到主线程刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            //推荐商家
            [weakself.mainTableView reloadData];
            
        });
        
        [weakself.mainTableView.mj_header endRefreshing];

        
    } failure:^(NSError *error) {
        
        //推荐商家
        [weakself.mainTableView.mj_header endRefreshing];

    }];

    
}
#pragma mark  ---- 首页定位

#pragma mark ---个人定位
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置不允许系统暂停定位
  //  [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
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
            
            //拿到个人位置经纬度再去请求推荐商家

            [weakself requestData];
            
            if (regeocode)
            {
                
                NSString * addressStr = [NSString stringWithFormat:@"%@", regeocode.formattedAddress];
                
                [User defalutManager].selfLocation = addressStr;
                
                
                if (regeocode.city == nil) {
                    
                    weakself.locationCity = regeocode.province;

                }else if(regeocode.city){
                    
                    weakself.locationCity = regeocode.city;
                }
                //获取城市ID
                    [weakself getUserCityId];
                
                }
            else
            {
              //拿到个人位置经纬度再去请求推荐商家
                
                [weakself requestData];

                
            }
            
        }
    };
}



#pragma mark ----推荐商家数据
-(void)requestGoodsData{
    
    __weak typeof(self)weakself = self;
    
    [weakself POST:recommendGooodsUrl parameters:nil success:^(id responseObject) {
        
        NSString * str  = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            
            NSArray * array = responseObject[@"result"];
            
            NSArray * recomondModelArray = [NSArray yy_modelArrayWithClass:[ONLINEgoodsModel class] json:array];
            
            //加载时让它替换掉数据源
            weakself.recomondGoodsShopaArray = [NSMutableArray arrayWithArray:recomondModelArray];
            //到主线程刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.mainTableView reloadData];
                
            });
            
        }else{
            
            [weakself.recomondGoodsShopaArray removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.mainTableView reloadData];
                
            });
        }
        
        [weakself.mainTableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.mainTableView.mj_header endRefreshing];
        
    }];
    

    
}
-(void)requestData{

    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"isCommend"] = @"1";
    param[@"areaId"] =  [User defalutManager].selectedCityID;
    
    param[@"longitude"] =[NSString stringWithFormat:@"%f",[User defalutManager].userLocation.coordinate.longitude];
    
    param[@"latitude"] =[NSString stringWithFormat:@"%f",[User defalutManager].userLocation.coordinate.latitude];
  
  
    [weakself.httpManager POST:storeListUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str  = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            
            NSArray * array = responseObject[@"result"];
            
            NSArray * recomondModelArray = [NSArray yy_modelArrayWithClass:[recmondShopModel class] json:array];
            
            //加载时让它替换掉数据源
            weakself.recomondShopaArray = [NSMutableArray arrayWithArray:recomondModelArray];
            //到主线程刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.mainTableView reloadData];
                
            });
            
        }else{
            
        [weakself.recomondShopaArray removeAllObjects];
            
        dispatch_async(dispatch_get_main_queue(), ^{
                
        [weakself.mainTableView reloadData];
                
            });
        }
        
        [weakself.mainTableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakself.mainTableView.mj_header endRefreshing];

    }];
    
}
#pragma mark---分类请求
-(void)requestShopCategoryData{
    
    __weak typeof(self)weakself = self;
    
  //  NSMutableDictionary * param = [NSMutableDictionary dictionary];
  //  param[@"isCommend"] = @"1";
    
    [self POST:appHomeNavigationUrl parameters:nil success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
        
                    //归档
        [HaiduiArchiverTools archiverObject:responseObject ByKey:@"storeClassCache" WithPath:@"storeClass.plist"];
        
        NSArray * array = responseObject[@"result"];
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[StoreClassModel class] json:array];
        
        weakself.shopCategoryArray = [NSMutableArray arrayWithArray:modelArray];
                    //到主线程刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
                        
            [weakself.mainTableView reloadData];
        });
        
    }
        
        
    } failure:^(NSError *error) {
        

    }];
  
}


#pragma 通知方法
-(void)changeCityName{
    
    [_placeBtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityName"] forState:UIControlStateNormal];
    
    [_placeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self requestData];
}
#pragma mark--tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 3) {
        
        if (_index == 0) {
            
            return self.recomondShopaArray.count;

        }else{
            
            return self.recomondGoodsShopaArray.count;

        }
    }
    return 1;
}
//创建sectionHeaderView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        
        view.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i< 2; i++) {
            
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/2.0f, 0, ScreenW/2.0f, 40)];
            button.tag = buttonTag + i;
            [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
            NSArray * array = @[@"推荐商家",@"推荐商品"];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];

            [view addSubview:button];
        }
        
        //tableview滑动保持状态
        
        if (_index == 0) {
            
            UIButton * btn = [view viewWithTag:buttonTag];
            btn.selected = YES;
            
        }else{
            
            UIButton * btn = [view viewWithTag:buttonTag + 1];
            btn.selected = YES;
        }
        
        [view addSubview:self.readLabel];
        
        UIView * stringView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenW , 1)];
        stringView.backgroundColor = [UIColor colorWithHexString:BackColor];
        [view addSubview:stringView];
        
        return view;

    }
    return 0;
}
//创建sectionFootView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
        
        bgView.backgroundColor = [UIColor colorWithHexString:BackColor];
        UIButton * AllShopButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, ScreenW -40, 50)];
        
        AllShopButton.layer.cornerRadius = 25;
        AllShopButton.backgroundColor = [UIColor colorWithHexString:MainColor];
        if (_index == 0) {
            
            [AllShopButton setTitle:@"查看全部线下商家" forState:UIControlStateNormal];
            [AllShopButton addTarget:self action:@selector(jumpShopListVC:) forControlEvents:UIControlEventTouchDown];
         
        }else{
            
            [AllShopButton setTitle:@"查看全部线上商品" forState:UIControlStateNormal];
            
            [AllShopButton addTarget:self action:@selector(jumpGoodsListVC:) forControlEvents:UIControlEventTouchDown];
     
        }
   
          AllShopButton.titleLabel.font = [UIFont systemFontOfSize:14];
         [AllShopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

         [bgView addSubview:AllShopButton];
        return bgView;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.01;
        
    }else if (section ==1){
        
        return 0.01;
    }else if (section == 3){
        
        return 40;
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
        
    }else if (section ==2){
        
        return 8;
    }else if (section == 3){
        
        return 80;
    }
   
    return 0;
}
#pragma mark ---界面布局
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 136 * ScreenScale;
        
    }else if (indexPath.section ==1){
        
        return 150;
        
    }else if (indexPath.section ==2){
        
        return 80 ;
        
    }else if (indexPath.section ==3){
        
        return 140;
    }
    return 0;
}
#pragma mark --界面布局
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        CGFloat imageH = 136 * ScreenScale;
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenW, imageH)];
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, imageH)];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.delegate = self;

        for (int i = 0; i< self.scrollImageArray.count; i++) {
            
            AdervertModel * model = self.scrollImageArray[i];
            
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake((i +1)*ScreenW, 0, ScreenW, imageH)];
            
            [button sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:BigbgImage]];
            button.tag = model.id;
            
            [_imageScrollView addSubview:button];
     
        }
        
        UIButton * lastbButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, imageH)];
        recmondShopModel * model = self.scrollImageArray[self.scrollImageArray.count -1];
        [lastbButton sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:BigbgImage]];
        [_imageScrollView addSubview:lastbButton];
            
        
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.contentSize = CGSizeMake((self.scrollImageArray.count +1) *ScreenW, 0);
            
        //创建pagecontrol
        _pageControl = [[UIPageControl alloc] init];
        [cell addSubview:_imageScrollView];
        [cell addSubview:_pageControl];
            //创建约束
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageScrollView.mas_left);
            make.right.equalTo(_imageScrollView.mas_right);
            make.bottom.equalTo(_imageScrollView.mas_bottom);
            make.height.equalTo(@20);
        }];
        _pageControl.numberOfPages = self.scrollImageArray.count;
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:MainColor]];
        
        [_pageControl addTarget:self action:@selector(chagePage:) forControlEvents:UIControlEventValueChanged];
        
    //tableView滑动时保持状态
    _imageScrollView.contentOffset = CGPointMake(ScreenW * _imagePage, 0);
    _pageControl.currentPage = _imagePage;
        

    return cell;
        
    } else if (indexPath.section ==1){
    
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
    
       _categorySrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150 )];
       [cell.contentView addSubview:_categorySrollView];
    
        _categorySrollView.delegate = self;
        _categorySrollView.pagingEnabled = YES;
        _categorySrollView.showsHorizontalScrollIndicator = NO;
 
        cell.selectionStyle = NO;
        _categorySrollView.backgroundColor = [UIColor whiteColor];
    
        //添加分类pagecontrol
        _categoryControl = [[UIPageControl alloc] init];
        [cell.contentView addSubview:_categoryControl];
      //创建约束
        [_categoryControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_categorySrollView.mas_left);
        make.right.equalTo(_categorySrollView.mas_right);
        make.bottom.equalTo(_categorySrollView.mas_bottom);
        make.height.equalTo(@20);
        }];
    
        if (self.shopCategoryArray.count % 8 == 0) {
        
        _categoryControl.numberOfPages = self.shopCategoryArray.count / 8 ;
        _categorySrollView.contentSize = CGSizeMake(ScreenW * (self.shopCategoryArray.count / 8), 0);
        
        }else{
            _categoryControl.numberOfPages = self.shopCategoryArray.count / 8 + 1;
            _categorySrollView.contentSize = CGSizeMake(ScreenW * (self.shopCategoryArray.count / 8 + 1), 0);
        }
        [_categoryControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:MainColor]];
        _categoryControl.pageIndicatorTintColor = [UIColor colorWithHexString:BackColor];
        //保持tableView滑动时
        _categoryControl.currentPage = _categoryPage;
        _categorySrollView.contentOffset = CGPointMake(ScreenW * _categoryPage, 0);
    
        CGFloat buttonW = ScreenW/4 ;
        CGFloat buttonH = 55;
    
        if(self.shopCategoryArray.count > 0){
        
            for (int i = 0; i<self.shopCategoryArray.count; i++) {
            
                StoreClassModel  * model = self.shopCategoryArray[i];
                if (i < 8) {
                
                    HDConvertButton * button =[[HDConvertButton alloc] initWithFrame:CGRectMake((i%4)*buttonW,10 +buttonH*(i/4) + 10 *(i/4) , buttonW , buttonH )];
                
                    button.titleLabel.textAlignment = 1;
                
                    [button sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal placeholderImage:nil];//
                
                    [button setTitle:model.name forState:UIControlStateNormal];
                
                    //设置tag值
                    button.tag = buttonTag + i;
                
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    //添加点击事件
                    [button addTarget:self action:@selector(jumpDetailVC:) forControlEvents:UIControlEventTouchDown];
                    [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
                    [button setImagePositionWithType:SSImagePositionTypeTop spacing:2];
                    [_categorySrollView addSubview:button];
                

                }else  if (i >= 8) {
            
                    HDConvertButton * button =[[HDConvertButton alloc] initWithFrame:CGRectMake((i%4)*buttonW + ScreenW, 10 +buttonH*(i/4 - 2) + 10 *(i/4 - 2), buttonW , buttonH )];
                    //字体居中
                    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
                    //跳转下一个界面
                    [button addTarget:self action:@selector(jumpDetailVC:) forControlEvents:UIControlEventTouchDown];
                    [button setTitle:model.name forState:UIControlStateNormal];
                
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                    [button sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal placeholderImage:nil];//[UIImage imageNamed:@""]
                
                    //设置button的tag值
                    button.tag = buttonTag + i;
                
                    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    [button setImagePositionWithType:SSImagePositionTypeTop spacing:5];
                
                    [_categorySrollView addSubview:button];
                
                }

            }
        
        }
        return cell;

    
    } else if (indexPath.section ==2){
        
        UITableViewCell * cell =[[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        
        CGFloat textFieldH = 40;
        _moneytextField = [[RegisterField alloc] initWithFrame:CGRectMake(40, 20, ScreenW - 80, textFieldH)];
        _moneytextField.layer.cornerRadius = textFieldH/2.0f;
        _moneytextField.layer.borderWidth = 1;
        _moneytextField.layer.borderColor = [UIColor colorWithHexString:@"#46c6fb"].CGColor;
        [_moneytextField setKeyboardType:UIKeyboardTypeDecimalPad];
        
        _moneytextField.placeholder = @"请输入消费金额";
        UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [rightBtn setTitle:@"扫码支付" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn addTarget:self action:@selector(scanErque) forControlEvents:UIControlEventTouchDown];
        
        rightBtn.backgroundColor = [UIColor colorWithHexString:@"#46c6fb"];
        
        rightBtn.layer.cornerRadius = textFieldH/2.0f;
        
        [_moneytextField setRightViewMode:UITextFieldViewModeAlways];
        _moneytextField.font = [UIFont systemFontOfSize:14];
        _moneytextField.rightView = rightBtn;
        
        [cell.contentView addSubview:_moneytextField];

        return cell;


    } else if (indexPath.section ==3){
        if (_index == 0) {
            
//            RecommodMarkCell * cell = [tableView dequeueReusableCellWithIdentifier:ReconmendGoodIndertfier2 forIndexPath:indexPath];
//            cell.selectionStyle = NO;
//
//            recmondShopModel * model = self.recomondShopaArray[indexPath.row];
//
//            cell.model = model;
//
//            return cell;
            AllShopTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:ReconmendGoodIndertfier2 forIndexPath:indexPath];
            cell.selectionStyle = NO;
            recmondShopModel * model = self.recomondShopaArray[indexPath.row];
            cell.recmondModel = model;
            
            return cell;
            
            
        }else{
            
            CovertDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:recomondGoodsIndertifer forIndexPath:indexPath];
            cell.selectionStyle = NO;
            
            
            ONLINEgoodsModel * model = self.recomondGoodsShopaArray[indexPath.row];
            
            
            [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
            
            cell.goodNumberLabel.text = [NSString stringWithFormat:@"%ld人付款",model.goods_salenum];
            
            cell.goodsDescribeLabel.text = model.goodsName;
            
            cell.saleNumberLabel.text = [NSString stringWithFormat:@"价格:%.2f",model.goods_price];
            cell.saleNumberLabel.textColor = [UIColor colorWithHexString:MainColor];
            
            return cell;
            
        }

    }
    return 0;
}

#pragma mark ----跳转到商家详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        
     
        if (_index == 0) {
            
            recmondShopModel * model = self.recomondShopaArray[indexPath.row];
            
            [User defalutManager].selectedShop = [NSString stringWithFormat:@"%ld", (long)model.idName];
            
            UIStoryboard * storybord =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            UIViewController * MyVC = [storybord instantiateViewControllerWithIdentifier:@"ShopDetailViewController"] ;
            
            
            [self.navigationController pushViewController:MyVC animated:YES];
            
        }else{
            
            ONLINEgoodsModel * model = self.recomondGoodsShopaArray[indexPath.row];
            
            
            ShopsGoodsBaseController * goodsVC =  [[ShopsGoodsBaseController alloc] init];
            goodsVC.goodsId = model.id;
            goodsVC.goodsType = 1;
            
            [self.navigationController pushViewController:goodsVC animated:YES];
            
        }
        
    }
    
}
#pragma mark -----跳转到商家分类
-(void)jumpDetailVC:(UIButton *)btn{
    
    if (btn.tag == buttonTag ) {
        
        XXUiNavigationController * nav =  [self.tabBarController.viewControllers objectAtIndex:1]  ;
        AllStoreAndGoodsBaseController * allGoodsVC =  nav.viewControllers[0];
        allGoodsVC.type = 1;
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        
  
        
    }else if (btn.tag == buttonTag + 1){
        
        XXUiNavigationController * nav =  [self.tabBarController.viewControllers objectAtIndex:1]  ;
        AllStoreAndGoodsBaseController * allGoodsVC =  nav.viewControllers[0];
        allGoodsVC.type = 2;
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        
        
    }else if (btn.tag == buttonTag + 2){
        
         self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4];
        
    }else if (btn.tag == buttonTag + 3){
        
         self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
        
    }else if (btn.tag == buttonTag + 4){
        
        JionHaiduiBeforeController * lolVC =[[JionHaiduiBeforeController alloc] init];
        [self.navigationController pushViewController:lolVC animated:YES];
        
    }else if (btn.tag == buttonTag + 5){
        
        HtmWalletPaytypeController * delegateVC = [[HtmWalletPaytypeController alloc] init];
        delegateVC.requestUrl = agreementHtmUrl;
        delegateVC.htmlType = delegateHtmlType;
        [self.navigationController pushViewController:delegateVC animated:YES];
        
    }else if (btn.tag == buttonTag + 6){
        
        ReconmendFriendsViewController * reconmendFrendsVC = [[ReconmendFriendsViewController alloc] init];
        [self.navigationController pushViewController:reconmendFrendsVC animated:YES];
    }else if (btn.tag == buttonTag + 7){
        
        CordChargeViewController * cordChargeVC = [[CordChargeViewController alloc] init];
        [self.navigationController pushViewController:cordChargeVC animated:YES];
        
    }else if (btn.tag == buttonTag + 8){
        
        RecommondStoreBaseController * recmondStoresVC =[[RecommondStoreBaseController alloc] init];
        [self.navigationController pushViewController:recmondStoresVC animated:YES];
        
    }else if (btn.tag == buttonTag + 9){
        
        YwywViewController * ywywVC =[[YwywViewController alloc] init];
        [self.navigationController pushViewController:ywywVC animated:YES];
        
    }else if (btn.tag == buttonTag + 10){
        
    }else if (btn.tag == buttonTag + 11){
        
    }else if (btn.tag == buttonTag + 12){
        
    }
    
}
-(void)jumpShopListVC:(UIButton *)sender{
    
    XXUiNavigationController * nav =  [self.tabBarController.viewControllers objectAtIndex:1]  ;
    AllStoreAndGoodsBaseController * allGoodsVC =  nav.viewControllers[0];
    allGoodsVC.type = 2;
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    

}
-(void)jumpGoodsListVC:(UIButton *)sender{
    
    XXUiNavigationController * nav =  [self.tabBarController.viewControllers objectAtIndex:1]  ;
    AllStoreAndGoodsBaseController * allGoodsVC =  nav.viewControllers[0];
    allGoodsVC.type = 1;
    
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    
    
}

#pragma mark ---选择城市
-(void)selectCity{
    
    
    CitySearchViewController * cityVC = [[CitySearchViewController alloc] init];

    
    [self presentViewController:cityVC animated:YES completion:nil];
    
}
#pragma mark ----消息中心
-(void)messageVC{
    
    MessageViewController * messageVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
}
#pragma mark ---- UITextFieldDelegate方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _moneytextField ) {
        
        [_moneytextField  becomeFirstResponder];

    }else{
        
       SearchShopViewController * searchShopVC = [[SearchShopViewController alloc] init];
        
      [self.navigationController pushViewController:searchShopVC animated:YES];
      [self.view endEditing:YES];
        
  }
    
}

#pragma mark ---uitabbarDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if(tabBarController.selectedIndex == 0)    //"我的账号"
    {
        _mainTableView.contentOffset = CGPointMake(0, 0);
    }
    return YES;
}

#pragma mark ----第一次进入获取用户城市ID
-(void)getUserCityId{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"name"] = weakself.locationCity;
    
    [weakself POST:findAreaByNameUrl parameters:param success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] ==1) {
            
            _cityID = responseObject[@"result"][0][@"id"];
            //设置定位城市
            [[NSUserDefaults standardUserDefaults] setObject:self.locationCity forKey:@"selfLocationName"];
        
            [[NSUserDefaults standardUserDefaults] setObject:_cityID forKey:@"selfLocationCityId"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loctionedCity" object:nil];
            
            //判断定位城市和所选城市是否一致
            NSString * cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityName"];
            
            if ([cityName isEqualToString:self.locationCity] == NO) {
                
                UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否切换到定位城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                
                [alterView show];
            }
    
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
      
        [User defalutManager].selectedCityID = _cityID;
        
        [User defalutManager].selectedCityName = self.locationCity;
        
        [[NSUserDefaults standardUserDefaults] setObject:self.locationCity forKey:@"currentCityName"];
        
        [[NSUserDefaults standardUserDefaults] setObject:_cityID forKey:@"currentCityId"];
        
        [_placeBtn setTitle:self.locationCity forState:UIControlStateNormal];
        //刷新推荐商家
        [self requestData];
        
        //通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectdCity" object:nil];

    }
}

#pragma mark --- 注销通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark ---子视图控制器切换
- (void)switchDetailView:(UIButton *)sender{
    
    UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
    btnSelected.selected=NO;
    
    sender.selected=YES;
    _index = sender.tag - buttonTag;
    
    if (_index == 0) {
        
        sender.selected = YES;
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_mainTableView reloadData];

            });
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.readLabel.frame= CGRectMake(0, sender.frame.size.height, sender.frame.size.width, 1);
        }];
        
    } else if (_index ==1){
        
        sender.selected = YES;
        
        if (!self.recomondGoodsShopaArray.count) {
            
            [self requestGoodsData];
            
        }else{
            
            [_mainTableView reloadData];

        }
        
        [UIView animateWithDuration:0.4 animations:^{
            
        self.readLabel.frame= CGRectMake(ScreenW/2.0f, sender.frame.size.height, sender.frame.size.width, 1);
            
        }];
        
    }
        
}
@end

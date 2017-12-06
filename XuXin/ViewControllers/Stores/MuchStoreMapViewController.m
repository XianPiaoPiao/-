//
//  MuchStoreMapViewController.m
//  XuXin
//
//  Created by xuxin on 16/12/2.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MuchStoreMapViewController.h"
#import "JXMapNavigationView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "MyAnnoation.h"
#import "recmondShopModel.h"
static NSString *pointReuseIndetifier = @"pointReuseIndetifier";

@interface MuchStoreMapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic ,strong)MAMapView * mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic ,strong)NSMutableArray * pointArray;
@property (nonatomic ,strong)NSMutableArray * storeAarray;

@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong)JXMapNavigationView * mapNavigationView;

@property (nonatomic ,strong)recmondShopModel * model;

@end

@implementation MuchStoreMapViewController{
    UILabel * _storeNameLabel;
    UILabel * _addressLabel;
    CGFloat storeLat;
    CGFloat stroreLong;
    NSString * _storeId;
    UIView * _toolBarView;
}


//懒加载
-(NSMutableArray *)storeAarray{
    if (!_storeAarray) {
        _storeAarray = [[NSMutableArray alloc] init];
    }
    return _storeAarray;
}
- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}

- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        
        _pointArray = [[NSMutableArray alloc] init];
    }
    return _pointArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [MTA trackPageViewBegin:@"MuchStoreMapViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MuchStoreMapViewController"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    

    [self creatNavgationBar];
    
    
    [self configLocationManager];
    
    //数据请求
    [self requestAroundStore];
    
 //   [self initToolBar];

}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"附近商家"];
    
    [self addBackBarButtonItem];

}

#pragma mark ---初始化商家详情
-(void)initToolBar{
    
    _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH , ScreenW, 80)];
    _toolBarView.backgroundColor = [UIColor whiteColor];
    [_toolBarView bringSubviewToFront:self.view];
   _storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 60, 40)];
    _storeNameLabel.text = self.model.store_name;
    _storeNameLabel.font = [UIFont systemFontOfSize:18];
    [_toolBarView addSubview:_storeNameLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenW - 140, 40)];;
    _addressLabel.text = self.model.store_address;
    _addressLabel.font = [UIFont systemFontOfSize:14];
    [_toolBarView addSubview:_addressLabel];
    //导航
    UIButton  * btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 130, 50, 60, 20)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"导航" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImagePositionWithType:SSImagePositionTypeLeft spacing:4];
    
    [btn setImage:[UIImage imageNamed:@"daohang"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(userThirdParty) forControlEvents:UIControlEventTouchDown];
    [_toolBarView addSubview:btn];
    
    UIButton * detailBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 60, 50, 60, 20)];
    [detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    detailBtn.titleLabel.font  =[UIFont systemFontOfSize:15];
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    //详情
    [detailBtn setImage:[UIImage imageNamed:@"xiangqing"] forState:UIControlStateNormal];
    
    [detailBtn addTarget:self action:@selector(detailVC) forControlEvents:UIControlEventTouchDown];
    [detailBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:4];

    [_toolBarView addSubview:detailBtn];
    
    [self.view addSubview:_toolBarView];
    //个人所在在位置
    UIButton * selfLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 60, screenH -140, 50, 50)];
    selfLocationBtn.layer.cornerRadius = 6;
    selfLocationBtn.backgroundColor = [UIColor blackColor];
    selfLocationBtn.alpha = 0.5;
    [selfLocationBtn addTarget:self action:@selector(startedLoaction) forControlEvents:UIControlEventTouchUpInside];
    
    [selfLocationBtn setImage:[UIImage imageNamed:@"position@2x"] forState:UIControlStateNormal];
    [self.view addSubview:selfLocationBtn];
}
#pragma mark ---回到个人位置
-(void)startedLoaction{
    
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
}
#pragma mark ---跳转到商家详情
-(void)detailVC{
    
    [User defalutManager].selectedShop = [NSString stringWithFormat:@"%@", _storeId];
    
    UIStoryboard * storybord =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController * MyVC = [storybord instantiateViewControllerWithIdentifier:@"ShopDetailViewController"] ;
    
    
    [self.navigationController pushViewController:MyVC animated:YES];
    
}
#pragma mark ----跳转到第三方
-(void)userThirdParty{
    
    [self.mapNavigationView showMapNavigationViewFormcurrentLatitude:_userLocation.coordinate.latitude currentLongitute:_userLocation.coordinate.longitude TotargetLatitude:storeLat  targetLongitute:stroreLong toName:_storeNameLabel.text];
    
    [self.view addSubview:_mapNavigationView];
}

#pragma mark ----附近商家数据请求
-(void)requestAroundStore{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"latitude"] =[NSString stringWithFormat:@"%f", _userLocation.coordinate.latitude];
    param[@"longitude"] = [NSString stringWithFormat:@"%f", _userLocation.coordinate.longitude];
    
    [self.httpManager GET:aroundStoreListUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * array = responseObject[@"result"];
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[recmondShopModel class] json:array];
        
        for (recmondShopModel * model in modelArray) {
            //百度转高德
            if ([model.map_type isEqualToString:@"baidu"] == YES) {
                
                CLLocationCoordinate2D c2d = CLLocationCoordinate2DMake(model.store_lat  , model.store_lng);
                
                CLLocationCoordinate2D c3d =  AMapCoordinateConvert(c2d, AMapCoordinateTypeBaidu);
                model.store_lng = c3d.longitude;
                model.store_lat = c3d.latitude;
            }
           
          [weakself.storeAarray addObject:model];
            
        }
     
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself initMapView];
            [weakself initToolBar];
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


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
    //  __weak MapLocationViewController *weakSelf = self;
    __weak typeof(self)weakself = self;
    weakself.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
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
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            [annotation setCoordinate:location.coordinate];
            
            if (regeocode)
            {
                
                //    NSString * addressStr = [NSString stringWithFormat:@"%@", regeocode.formattedAddress];
                
            }
            else
            {
                [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
                [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
            }
            
        }
    };
}


#pragma mark ----跳转到第三方
//-(void)userThirdParty{
//    
//    [self.mapNavigationView showMapNavigationViewFormcurrentLatitude:_currentLocation.coordinate.latitude currentLongitute:_currentLocation.coordinate.longitude TotargetLatitude:self.model.store_lat  targetLongitute:self.model.store_lng toName:self.model.store_name];
//    
//    [self.view addSubview:_mapNavigationView];
//}


#pragma mark - 初始化地图

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = 1;
        
        [_mapView setZoomLevel:15.1 animated:YES];

        [self.view addSubview:self.mapView];

        //是否显示比例尺
        
        //添加大头针
        for (int i = 0; i< self.storeAarray.count; i++) {
      
            recmondShopModel * model = self.storeAarray[i];
            CLLocationCoordinate2D c2d = CLLocationCoordinate2DMake(model.store_lat,model.store_lng );
            //3.把xy转换成经纬度
            //4.关键点，创建模型
            MyAnnoation *annocation = [[MyAnnoation alloc] init];
            annocation.coordinate = c2d;
            annocation.title = model.store_name;
            annocation.subtitle = model.store_address;
            annocation.lat = model.store_lat;
            annocation.longTiude = model.store_lng;
            annocation.storeId =[NSString stringWithFormat:@"%ld", model.idName];
            //5.将大头针标注信息添加在地图上
            [self.mapView addAnnotation:annocation];
            
        }
        
        
    }
    
}




#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MyAnnoation class]])
    {
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = YES;
        annotationView.image            = [UIImage imageNamed:@"dingwei_two@3x"];
        
        return annotationView;
    }
    
    return nil;
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"点击了查看详情");
}
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        
        view.canShowCallout = NO;
        
    }else{
      
        MyAnnoation * annocation = view.annotation;
        annocation.isSelected = YES;
        view.image = [UIImage imageNamed:@"dingwei_one@3x"];
        
//       NSArray * array = [mapView annotations];
    
//        for (id annocation in array) {
//            
//            MyAnnoation * ation =  (MyAnnoation *)annocation;
//            
//         if (ation.isSelected == NO) {
//                
//             view.image = [UIImage imageNamed:@"dingwei_two@3x"];
//
//            }
//        }
        
        _storeNameLabel.text =  annocation.title;
        _addressLabel.text = annocation.subtitle;
        storeLat = annocation.lat;
        stroreLong = annocation.longTiude;
        _storeId = annocation.storeId;
        
        [UIView animateWithDuration:0.4 animations:^{
            
        _toolBarView.frame = CGRectMake(0, screenH - 80, ScreenW, 80);
            
        }];
        
    }
    
}
-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    
     view.image = [UIImage imageNamed:@"dingwei_two@3x"];

}


@end

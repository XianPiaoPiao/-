//
//  MapLocationViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MapLocationViewController.h"
#import "JXMapNavigationView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "MyAnnoation.h"

@interface MapLocationViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic ,strong)MAMapView * mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic ,strong)NSMutableArray * pointArray;
@property (nonatomic ,strong)NSMutableArray * storeAarray;
@property (nonatomic, strong) MAPointAnnotation * pointAnnotaiton;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;

@end

@implementation MapLocationViewController{
    
    CLLocation * _currentLocation;
    

    
}
//懒加载
- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}
-(recmondShopModel * )model{
    if (!_model) {
        _model = [[recmondShopModel alloc] init];
    }
    return _model;
}
- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [[NSMutableArray alloc] init];
    }
    return _pointArray;
}
-(NSMutableArray *)storeAarray{
    if (!_storeAarray) {
        _storeAarray = [[NSMutableArray alloc] init];
    
    }
    return _storeAarray;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    self.navigationController.navigationBarHidden = NO;

    
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"商家位置"];
    
    [self addBackBarButtonItem];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //添加到数组
 
    
    if ([self.model.map_type isEqualToString:@"baidu"] == YES) {
        //百度转高德
        CLLocationCoordinate2D c2d = CLLocationCoordinate2DMake(_model.store_lat  , _model.store_lng);
        
        CLLocationCoordinate2D c3d =  AMapCoordinateConvert(c2d, AMapCoordinateTypeBaidu);
        self.model.store_lng = c3d.longitude;
        self.model.store_lat = c3d.latitude;
        
    }
    [self.storeAarray addObject:self.model];

    [self configLocationManager];

    [self initMapView];
    
    
    [self initToolBar];
    
    [self creatNavgationBar];

}



-(void)initToolBar{
    
    UIView * toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH - 80-self.TabbarHeight, ScreenW, 80)];
    toolBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolBarView];
    UILabel * storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenW - 60, 40)];
    storeNameLabel.text = self.model.store_name;
    storeNameLabel.font = [UIFont systemFontOfSize:18];
    [toolBarView addSubview:storeNameLabel];
    
    UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenW - 60, 40)];;
    addressLabel.text = self.model.store_address;
    addressLabel.font = [UIFont systemFontOfSize:14];
    [toolBarView addSubview:addressLabel];
    
    UIButton  * btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 60, 20, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"jiantou@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(userThirdParty) forControlEvents:UIControlEventTouchDown];
    [toolBarView addSubview:btn];
    
    //个人初始位置
    UIButton * selfLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 60, screenH -140, 50, 50)];
    selfLocationBtn.layer.cornerRadius = 6;
    selfLocationBtn.backgroundColor = [UIColor blackColor];
    selfLocationBtn.alpha = 0.5;
    [selfLocationBtn addTarget:self action:@selector(startedLoaction) forControlEvents:UIControlEventTouchUpInside];
    
    [selfLocationBtn setImage:[UIImage imageNamed:@"position@2x"] forState:UIControlStateNormal];
    [self.view addSubview:selfLocationBtn];
    
    [self.view addSubview:toolBarView];
}
-(void)startedLoaction{
    
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
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
-(void)userThirdParty{
    
    [self.mapNavigationView showMapNavigationViewFormcurrentLatitude:_currentLocation.coordinate.latitude currentLongitute:_currentLocation.coordinate.longitude TotargetLatitude:self.model.store_lat  targetLongitute:self.model.store_lng toName:self.model.store_name];
    
    [self.view addSubview:_mapNavigationView];
}

#pragma mark - Initialization

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = 1;
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];


        [self.view addSubview:self.mapView];
                    //隐藏状态栏
//      [UIApplication sharedApplication].statusBarHidden = YES;
                    //是否显示比例尺

                  self.navigationController.navigationBarHidden = YES;
        
                  [_mapView setZoomLevel:13.1 animated:YES];
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
        
            //5.将大头针标注信息添加在地图上
            [self.mapView addAnnotation:annocation];
            
            self.mapView.centerCoordinate = c2d;
        }
      
        
    }
    
}




#pragma mark - MAMapView Delegate
-(void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view{
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MyAnnoation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
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


@end

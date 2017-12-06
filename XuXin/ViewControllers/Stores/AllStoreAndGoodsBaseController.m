//
//  AllStoreAndGoodsBaseController.m
//  XuXin
//
//  Created by xuxin on 17/3/23.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "AllStoreAndGoodsBaseController.h"
#import "XXSegementControl.h"
#import "SearchShopViewController.h"
#import "MuchStoreMapViewController.h"
#import "AllShopListViewController.h"
#import "AllGoodsController.h"
@interface AllStoreAndGoodsBaseController ()<UIScrollViewDelegate>

@property (nonatomic ,strong)UILabel * readLabel;
@property (nonatomic ,strong)AllShopListViewController * allShopVC;
@property (nonatomic ,strong)AllGoodsController * allGoodsVC;

@end

@implementation AllStoreAndGoodsBaseController{
    
    UIScrollView * _VCscrollView;
    XXSegementControl * _segementControl;

}
-(AllShopListViewController *)allShopVC{
    if (!_allShopVC) {
        _allShopVC = [[AllShopListViewController alloc] init];
        [self addChildViewController: _allShopVC];
        _allShopVC.view.frame = CGRectMake(0, -64, ScreenW, screenH);
    }
    return _allShopVC;
}
-(AllGoodsController *)allGoodsVC{
    if (!_allGoodsVC) {
        _allGoodsVC = [[AllGoodsController alloc] init];
        [self addChildViewController:_allGoodsVC];
        _allGoodsVC.view.frame = CGRectMake(ScreenW,-64, ScreenW, screenH);
    }
    return _allGoodsVC;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [UIApplication sharedApplication].statusBarHidden = NO;
 
    [MTA trackPageViewBegin:@"AllStoreAndGoodsBaseController"];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (_type == 1) {
        
        [self exchangeScrollview];
        
    }else{
        
        [self exchangeStoreScrollview];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"AllStoreAndGoodsBaseController"];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    //初始化type

    [self creatNavgationBar];

    [self creatUI];
    
    
}
-(void)exchangeStoreScrollview{
    
    _segementControl.selectedSegmentIndex = 0;
    
    _VCscrollView.contentOffset = CGPointMake(0, 0);
    
    [_VCscrollView addSubview:self.allShopVC.view];
    
    _type = 0;
}
-(void)exchangeScrollview{
    
    _segementControl.selectedSegmentIndex = 1;
    
    _VCscrollView.contentOffset = CGPointMake(ScreenW, 0);
    
    [_VCscrollView addSubview:self.allGoodsVC.view];
    
    _type = 1;

}
-(void)creatNavgationBar{
    
    
    UIView * navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBgview.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:navBgview];
    
    UIButton * messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 40, 20+self.StatusBarHeight, 44, 44)];
    [messageBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchDown];
    [messageBtn setImage:[UIImage imageNamed:@"shangjia_sousuo@3x"] forState:UIControlStateNormal];
    [navBgview addSubview:messageBtn];
    
    
    UIButton * placeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20+self.StatusBarHeight, 44, 44)];
    [placeBtn addTarget:self action:@selector(place) forControlEvents:UIControlEventTouchDown];
    [placeBtn setImage:[UIImage imageNamed:@"shangjia_dingwei@3x"] forState:UIControlStateNormal];
    [navBgview addSubview:placeBtn];
    
    _segementControl = [[XXSegementControl alloc]initWithItems:@[@"线下商家",@"线上商品"]];
    
    _segementControl.frame = CGRectMake(60, 27+self.StatusBarHeight, 220 * ScreenScale, 30);
    _segementControl.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    
  //  _segementControl.selectedSegmentIndex = 0;
    
    _segementControl.tintColor = [UIColor colorWithHexString:MainColor];
    
    [_segementControl addTarget:self action:@selector(segmentIndexChange:)];
    
    [navBgview addSubview:_segementControl];
    
}

-(void)creatUI{
    
    _VCscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+self.StatusBarHeight, ScreenW, screenH)];
    //设置scrollView的代理
    _VCscrollView.delegate = self;
    //scrollview翻页设置
    _VCscrollView.pagingEnabled = YES;
    
    _VCscrollView.contentSize = CGSizeMake(ScreenW * 2, screenH);
    
    [self.view addSubview:_VCscrollView];
    
    [_VCscrollView addSubview:self.allShopVC.view];
    

}
- (void)segmentIndexChange:(UISegmentedControl *)segement{
    
    
    if (segement.selectedSegmentIndex == 0) {
        
        _VCscrollView.contentOffset = CGPointMake(0, 0);
        
        [_VCscrollView addSubview:self.allShopVC.view];
        
        _type = 0;

        
    }else{
        
        _VCscrollView.contentOffset = CGPointMake(ScreenW, 0);
        [_VCscrollView addSubview:self.allGoodsVC.view];
        
        _type = 1;

    }
    
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
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x ==  ScreenW) {
        
        _segementControl.selectedSegmentIndex = 1;
        [_VCscrollView addSubview:self.allGoodsVC.view];
        _type = 1;

        
    }else{
        
        _segementControl.selectedSegmentIndex = 0;
        [_VCscrollView addSubview:self.allShopVC.view];
        _type = 0;

    }

}


@end

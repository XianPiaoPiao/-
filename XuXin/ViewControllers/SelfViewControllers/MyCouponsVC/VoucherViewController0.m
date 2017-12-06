//
//  VoucherViewController0.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "VoucherViewController0.h"
#import "VoucherViewController.h"
#import "VoucherViewController2.h"
#import "HtmWalletPaytypeController.h"
#import "XXSegementControl.h"
@interface VoucherViewController0 ()<UIScrollViewDelegate>{
    
    UIScrollView * _bgScrollView ;
    XXSegementControl * _segmentedControl;
}

@end

@implementation VoucherViewController0
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden= NO;
    [MTA trackPageViewBegin:@"VoucherViewController0"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"VoucherViewController0"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAnother) name:@"addCouponSuccess" object:nil];
    
    [self navigationItemSettings];

    
    [self creatUI];
    
}

-(void)scrollAnother{
    
    _bgScrollView.contentOffset = CGPointMake(ScreenW, 0);
    _segmentedControl.selectedSegmentIndex = 1;
    
}
- (void)navigationItemSettings{
    
    self.navigationController.navigationBarHidden = NO;
    [self addBackBarButtonItem];
    [self addTitleView];

    
    //    创建导航栏右边的item
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"规则" style:UIBarButtonItemStylePlain target:self action:@selector(theRulesOnClicked)];
    [rightButtonItem setTintColor:UIColorFromHexValue(0x0b86d7)];
    [rightButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHexValue(0x0b86d7),NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
}
- (void)addTitleView{
    
    _segmentedControl = [[XXSegementControl alloc]initWithItems:@[@"新劵录入排队",@"报销进度查询"]];
    _segmentedControl.frame = CGRectMake(60, 27, 220 * ScreenScale, 30);
    _segmentedControl.center = CGPointMake(ScreenW/2.0f, 42);
    
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = [UIColor colorWithHexString:MainColor];

    [_segmentedControl addTarget:self action:@selector(segmentIndexChange:)];

    [self.navigationItem setTitleView:_segmentedControl];
}

- (void)creatUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    VoucherViewController * voucherVC1 = [[VoucherViewController alloc]init];
    
    VoucherViewController2 * voucherVC2 = [[VoucherViewController2 alloc]init];
    
    [self addChildViewController:voucherVC1];
    [self addChildViewController:voucherVC2];
    
    
    _bgScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    
    voucherVC1.view.frame = CGRectMake(0, 0, ScreenW, screenH);
    voucherVC2.view.frame = CGRectMake(ScreenW, 0, ScreenW, screenH);
    
    
    [_bgScrollView addSubview:voucherVC1.view];
    [_bgScrollView addSubview:voucherVC2.view];
    
    _bgScrollView.pagingEnabled = YES;
    
//    设置scrollView内容大小
    _bgScrollView.contentSize = CGSizeMake(ScreenW * 2, screenH);
    
    _bgScrollView.delegate = self;
    
}
#pragma mark - ACTIONS

- (void)segmentIndexChange:(UISegmentedControl *)segement{
    
    
    if (segement.selectedSegmentIndex == 0) {
        
        _bgScrollView.contentOffset = CGPointMake(0, 0);
        [self packUpTheVC2Menu];

    }else{
        
        _bgScrollView.contentOffset = CGPointMake(ScreenW, 0);
        
    }
    
}
- (void)popToVC{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//规则
- (void)theRulesOnClicked{
    
    HtmWalletPaytypeController * htmWalletVC =[[HtmWalletPaytypeController alloc] init];
    htmWalletVC.requestUrl =couponRuleHtmUrl;
    htmWalletVC.htmlType = couponRulerType;
    [self.navigationController pushViewController:htmWalletVC animated:YES];
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat currentX = scrollView.contentOffset.x;
    
    
    
    if (currentX > 0) {
        
        _segmentedControl.selectedSegmentIndex = 1;
        
        
    }else{
        _segmentedControl.selectedSegmentIndex = 0;
        
     //   [self packUpTheVC2Menu];
        
    }
    
    
}


//收起vc2 的下拉菜单
- (void)packUpTheVC2Menu{
    
    VoucherViewController2 * vc2 = (VoucherViewController2 *) self.childViewControllers.lastObject;
    [vc2 packUpButton];
    
}

//注销观察者
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

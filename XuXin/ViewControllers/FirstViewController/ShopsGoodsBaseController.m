//
//  ShopsGoodsBaseController.m
//  XuXin
//
//  Created by xuxin on 17/3/8.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ShopsGoodsBaseController.h"
#import "XXSegementControl.h"
#import "SupendPayView.h"
#import "UserCommentsCell.h"
#import "StoresLocatedCell.h"
#import "StarsView.h"
#import "GroupGoodsMOdel.h"
#import "GoodsStoreModel.h"
#import "goodsCell.h"
#import "UserCommentsModel.h"
#import "OnlineOrderController.h"
#import "groupGoodsController.h"
#import "HDCarNumberCOunt.h"
#import "ChoseView.h"
#import "LandingViewController.h"
#import "HDshopCarBaseController.h"
#import "AllCommnetsController.h"
#import "AllStoresGoodsController.h"
#import "MapLocationViewController.h"
#import "StorecouponView.h"
//友盟分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

#import "recmondShopModel.h"
#import "CouponsViewController.h"

#define kHeadH 140.0f //头视图的高度
#define kHeadMinH 64.0f //状态栏高度20 + 导航栏高度44
#define kBarH 58.0f//头视图下边支付View的高度

NSString * const storesLocateCellIndertfier = @"StoresLocatedCell";
NSString * const userCommentInderfer = @"UserCommentsCell";
NSString * const goodsCellIndertifer = @"goodsCell";

@interface ShopsGoodsBaseController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic ,strong)GroupGoodsMOdel * goodsModel;
@property (nonatomic ,strong)recmondShopModel * storeModel;
@property(nonatomic ,strong)NSMutableArray * commentsArray;
@property (nonatomic ,strong)NSMutableArray * moreGoodsArray;

@property(nonatomic ,strong)UIWebView * pictureWebView;
@property(nonatomic ,strong)UITableView * tableView;

@property (nonatomic ,assign)NSInteger goodsCount;

@property (nonatomic ,strong)NSMutableArray * relevantGoodsRecommendArray;

@property (nonatomic ,copy)NSString * favoriteId;

@property (nonatomic ,assign) NSInteger favoriteStatus;

@property (nonatomic ,assign) NSInteger evaluates_count;


@property (nonatomic ,strong)NSMutableArray * meatureArray;
@property (nonatomic ,strong)NSMutableArray * stockArray;//商品库存量

//1是购买 2 是添加购物车
@property (nonatomic ,assign)NSInteger isAddOrBuy;
//@property (nonatomic ,strong)NSDictionary * stockdic;//商品库存量

//@property(nonatomic ,strong)NSMutableDictionary * metureDic;

@property (nonatomic, strong) CouponsViewController *couponVC;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation ShopsGoodsBaseController{
    
    XXSegementControl * _segementControl;
    
    UIScrollView * _vcScrollView;
    
    UserCommentsCell * _commentCell;
    
    HDCarNumberCOunt * _countView;
    
    //规格
    ChoseView * _choseView;
    
    CGPoint center;
   
    
    int goodsStock;
    
    UILabel * _shopCartNumberLbel;
    //收藏
    UIButton * _collectBtn;
}

-(NSMutableArray *)meatureArray{
    
    if (!_meatureArray) {
        
        _meatureArray = [[NSMutableArray alloc] init];
    }
    return _meatureArray;
}
-(NSMutableArray *)stockArray{
    if (!_stockArray) {
        
        _stockArray = [[NSMutableArray alloc] init];
    }
    return _stockArray;
}

-(NSMutableArray *)commentsArray{
    if (!_commentsArray) {
        
        _commentsArray = [[NSMutableArray alloc] init];
    }
    return _commentsArray;
}
-(NSMutableArray *)moreGoodsArray{
    if (!_moreGoodsArray) {
        _moreGoodsArray = [[NSMutableArray alloc] init];
    }
    return _moreGoodsArray;
}
-(NSMutableArray *)relevantGoodsRecommendArray{
    if (_relevantGoodsRecommendArray) {
        
        _relevantGoodsRecommendArray = [[NSMutableArray alloc] init];
    }
    return _relevantGoodsRecommendArray;
}
-(GroupGoodsMOdel *)goodsModel{
    if (!_goodsModel) {
        
        _goodsModel = [[GroupGoodsMOdel alloc] init];
    }
    return _goodsModel;
}
-(recmondShopModel *)storeModel{
    if (!_storeModel) {
        
        _storeModel = [[recmondShopModel alloc] init];
    }
    return _storeModel;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    [MTA trackPageViewBegin:@"ShopGoodsBaseController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [MTA trackPageViewBegin:@"ShopGoodsBaseController"];
    [super viewWillDisappear:animated];
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化
    _goodsCount= 1;
    
    [self settingUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //线上商品
    if (_goodsType == 1) {
        
        [self initTabbar];

    }
    
    [self creatNavgatonBar];
    
    [self creatTableView];
    
    //数据请求
    [self requestGoodsData];
    
    //规格数据请求
    [self requestMetureData];
    // Do any additional setup after loading the view.
    
    
    [self createCouponView];

    
    //
    [self settingPictureUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeShopcartNumber) name:@"deleteConvertOK" object:nil];
    
}
-(void)changeShopcartNumber{
    
    [self initTabbar];
}
#pragma mark ----图文详情
-(void)settingPictureUI{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"id"] = self.goodsId;
    
    [weakself POST:graphicDetailsUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];

        if ([str integerValue] == 1) {
            //加载
            NSString * contentHtml = responseObject[@"result"][@"goods_details"];
            
            weakself.pictureWebView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenW,  64, ScreenW , screenH - 114)];
            
            //不能滑
            //  self.pictureWebView.scrollView.bouncesZoom = NO;
            //  self.pictureWebView.scrollView.bounces = NO;//不允许漏出空白背景
            //不能点
            //  self.pictureWebView.multipleTouchEnabled=NO;
            
            [_vcScrollView addSubview:self.pictureWebView];
            
            [weakself.pictureWebView setScalesPageToFit:YES];
            //   self.pictureWebView.dataDetectorTypes = UIDataDetectorTypeAll;
            
            if(contentHtml != nil){
                
            [weakself.pictureWebView loadHTMLString:contentHtml baseURL:[NSURL URLWithString:Host]];
                
        }
    }
        
} failure:^(NSError *error) {
        
        
    }];
}
#pragma mark ---底部视图
-(void)initTabbar{
    
   UIView * botomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH - 50-self.TabbarHeight, ScreenW, 50)];
    botomView.backgroundColor = [UIColor whiteColor];
    //创建底部视图购物车
    NSInteger shopWalletW = 90;
    
    UIView * shopBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shopWalletW, 50)];
    UIButton * shopWallet = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,shopWalletW, 50)];
    [shopBgView addSubview:shopWallet];
    _shopCartNumberLbel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, shopWalletW/4.0f, 20)];
    _shopCartNumberLbel.font = [UIFont systemFontOfSize:13];
    
    _shopCartNumberLbel.text = [NSString stringWithFormat:@"%ld",[User defalutManager].lineShopCart];
    
    [_shopCartNumberLbel setTextColor:[UIColor redColor]];
    [shopBgView addSubview:_shopCartNumberLbel];
    
    [shopWallet addTarget:self action:@selector(jumpShopCarVC) forControlEvents:UIControlEventTouchDown];
    
    [shopWallet setImage:[UIImage imageNamed:@"exchange_icon_shopping@2x"] forState:UIControlStateNormal];
    [shopWallet setTitle:@"购物车" forState:UIControlStateNormal];
    shopWallet.titleLabel.font = [UIFont systemFontOfSize:12];
    [shopWallet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shopWallet setImagePositionWithType:SSImagePositionTypeTop spacing:5];
    
    UIButton * shopCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(shopWalletW, 0, (ScreenW -shopWalletW)/2.0f, 50)];
    shopCarBtn.backgroundColor = [UIColor redColor];
    [shopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    //加入购物车
    [shopCarBtn addTarget:self action:@selector(addShopCar:) forControlEvents:UIControlEventTouchDown];
    //创建兑换
    UIButton * convertBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - (ScreenW -shopWalletW)/2.0f, 0, (ScreenW -shopWalletW)/2.0f, 50)];
    convertBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    
    [convertBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [convertBtn addTarget:self action:@selector(onlineOrder) forControlEvents:UIControlEventTouchDown];
    [botomView addSubview:shopBgView];
    [botomView addSubview:shopCarBtn];
    [botomView addSubview:convertBtn];
    
    [self.view addSubview:botomView];
    
}
-(void)settingUI{
    
    _vcScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW , screenH )];
    _vcScrollView.backgroundColor = [UIColor whiteColor];
    _vcScrollView.pagingEnabled = YES;
    _vcScrollView.contentSize = CGSizeMake(ScreenW * 2, screenH );
    _vcScrollView.delegate = self;
    
    [self.view addSubview:_vcScrollView];
    
}

- (void)createCouponView{
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor colorWithHexString:WordColor alpha:0.5];
    
    [self.view addSubview:_bgView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH/3, ScreenW, screenH/3*2)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    _couponVC = [[CouponsViewController alloc] init];
    __weak typeof(self)weakself= self;
    _couponVC.finishBtnBlock = ^(BOOL flag) {
        [weakself hiddenOrShowCouponVC:YES];
    };
    [self addChildViewController:_couponVC];
    [self.contentView addSubview:_couponVC.view];
    _bgView.hidden = YES;
    self.contentView.hidden = YES;
    [_bgView setAlpha:0.0f];
    [_contentView setAlpha:0.0f];
}

- (void)hiddenOrShowCouponVC:(BOOL)flag{
    if (flag) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didAfterHidden)];
        [UIView setAnimationDuration:0.5];
        
        [_bgView setAlpha:0.0f];
        [_contentView setAlpha:0.0f];
        
        [UIView commitAnimations];
    }else {
        _bgView.hidden = NO;
        _contentView.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        
        [_bgView setAlpha:1.0f];
        [_contentView setAlpha:1.0f];
        
        [UIView commitAnimations];
    }
    
}
- (void)didAfterHidden{
    _bgView.hidden = YES;
    self.contentView.hidden = YES;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x ==  ScreenW) {
        
        _segementControl.selectedSegmentIndex = 1;
        
    }else{
        
        _segementControl.selectedSegmentIndex = 0;

    }
}
#pragma mark ---数据请求
-(void)requestGoodsData{
    
    [_vcScrollView addSubview:[EaseLoadingView defalutManager]];
    
    [[EaseLoadingView defalutManager] startLoading];
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"id"] = _goodsId;
    
    param[@"longitude"] =[NSString stringWithFormat:@"%f",[User defalutManager].userLocation.coordinate.longitude];
    param[@"latitude"] =[NSString stringWithFormat:@"%f",[User defalutManager].userLocation.coordinate.latitude];
    
    
    [self.httpManager POST:gooodsDetailUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [[EaseLoadingView defalutManager] stopLoading];
        
        NSString * str =responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            NSDictionary * dic = responseObject[@"result"][@"goods"];
            
            //收藏状态
            // _favoriteStatus  = [dic[@"favoriteStatus"] integerValue];
            NSString * favstr  = responseObject[@"result"][@"favoriteStatus"];
            
            
            if ([favstr integerValue] == 1) {
                //收藏状态
            _collectBtn.selected = YES;
            weakself.favoriteId = responseObject[@"result"][@"favoriteId"];
            }
            //评论数
            weakself.evaluates_count = [responseObject[@"result"][@"evaluates_count"] integerValue];
            
            weakself.goodsModel =[GroupGoodsMOdel yy_modelWithDictionary:dic];
            
            NSDictionary * storeDic = responseObject[@"result"][@"goods_store"];
            weakself.storeModel = [recmondShopModel yy_modelWithDictionary:storeDic];
            
            weakself.moreGoodsArray = responseObject[@"result"][@"moreGoods"];
            weakself.relevantGoodsRecommendArray = responseObject[@"result"][@"relevantGoodsRecommend"];
            
            NSArray * array = responseObject[@"result"][@"evaluates"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[UserCommentsModel class] json:array];
            
            weakself.commentsArray = [NSMutableArray arrayWithArray:modelArray];
            
            _couponVC.storeID = self.storeModel.store_id;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[EaseLoadingView defalutManager] stopLoading];

    }];
        
}
-(void)creatTableView{
    
   
   _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, screenH -64 - 50-self.TabbarHeight) style:UITableViewStyleGrouped];

    [_vcScrollView addSubview:_tableView];
    _tableView.separatorStyle = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"StoresLocatedCell" bundle:nil] forCellReuseIdentifier:storesLocateCellIndertfier];
    [_tableView registerNib:[UINib nibWithNibName:@"UserCommentsCell" bundle:nil] forCellReuseIdentifier:userCommentInderfer];
    [_tableView registerNib:[UINib nibWithNibName:@"goodsCell" bundle:nil] forCellReuseIdentifier:goodsCellIndertifer];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
  
    
    UIButton * buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, screenH - 50, ScreenW  , 50)];
    [buyBtn addTarget:self action:@selector(onlineOrder) forControlEvents:UIControlEventTouchDown];
    
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    buyBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    
    if (_goodsType == 2) {
        
        [self.view addSubview:buyBtn];
    }
    
}
- (void)creatNavgatonBar{
    //
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    
    [self addBackBarButtonItem];
    
    [self addTitleView];
    
    //创建导航栏右边的item
     _collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
     _collectBtn.selected = NO;
    
    [_collectBtn setImage:[UIImage imageNamed:@"collection@2x"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"collection2@2x"] forState:UIControlStateSelected];
    
    [_collectBtn addTarget:self action:@selector(collectGoods:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_collectBtn];

    
   UIButton * shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    
    [shareBtn addTarget:self action:@selector(shareGoods) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem * rightButtonShareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
 
    self.navigationItem.rightBarButtonItems =@[rightButtonShareItem,rightButtonItem] ;
    
}
#pragma mark ----收藏
-(void)collectGoods:(UIButton *)sender{
    
    if (sender.selected == NO) {
        
        [self requestCollectGoodsData:(UIButton *)sender];
        
    }else{
        
        [self cancelCollect:(UIButton *)sender];
        
    }
    
}
//收藏
-(void)requestCollectGoodsData:(UIButton *)sender{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"goodsId"] = self.goodsId;
    
    
    [self POST:addFavoriteGoodsAndStoreUrl parameters:param success:^(id responseObject) {
        
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
           weakself.favoriteId = responseObject[@"result"][@"favoriteId"];
           sender.selected = YES;
            
           [weakself showStaus:@"收藏成功"];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
//取消收藏
-(void)cancelCollect:(UIButton *)sender{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"favoriteIds"] = _favoriteId;
    
    [weakself POST:batchDeleteGoodsUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            sender.selected = NO;
            
            [weakself showStaus:@"取消收藏成功"];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)addTitleView{
    
    _segementControl = [[XXSegementControl alloc]initWithItems:@[@"商品详情",@"图文详情"]];
    _segementControl.frame = CGRectMake(60, 27, 220 * ScreenScale, 30);
    _segementControl.center = CGPointMake(ScreenW/2.0f, 42);
    
   // _segementControl.selectedSegmentIndex = 0;
    
    _segementControl.tintColor = [UIColor colorWithHexString:MainColor];
    
    [_segementControl addTarget:self action:@selector(segmentIndexChange:)];
    
    [self.navigationItem setTitleView:_segementControl];
}

- (void)segmentIndexChange:(UISegmentedControl *)segement{
    
    
    if (segement.selectedSegmentIndex == 0) {
        
        _vcScrollView.contentOffset = CGPointMake(0, 0);
        
    }else{
        
        _vcScrollView.contentOffset = CGPointMake(ScreenW, 0);
        
    }
    
}
#pragma mark -----tableViewDelegate
//界面布局
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        CGFloat ImageH =  ScreenW;//160 * ScreenScale;
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        UIScrollView * imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW , ImageH)];
        
        UIImageView * goodsImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ImageH)];
        
            goodsImage.tag = 500;
        
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        [goodsImage setContentMode:UIViewContentModeScaleAspectFill];
        
        goodsImage.contentScaleFactor = [[UIScreen mainScreen] scale];
        
        goodsImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        goodsImage.clipsToBounds = YES;
        [imageScroll addSubview:goodsImage];
        [cell.contentView addSubview:imageScroll];
        
        return cell;
    }else if (indexPath.section == 1){
        
      
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        
        
        UILabel * nameLbael = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, ScreenW - 60, 40)];
        nameLbael.font = [UIFont systemFontOfSize:14];
        nameLbael.numberOfLines = 2;
        nameLbael.textColor = [UIColor blackColor];
        nameLbael.text = [NSString stringWithFormat:@"%@",self.goodsModel.goods_name];
        
        UIImageView *starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-30, 8, 15, 15)];
        [starImgView setImage:[UIImage imageNamed:@"scoring"]];
        [cell.contentView addSubview:starImgView];
        
        UILabel *evaluateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW-40, 25, 40, 20)];
        evaluateLabel.textColor = [UIColor colorWithHexString:MainColor];
        evaluateLabel.font = [UIFont systemFontOfSize:12.0];
        evaluateLabel.textAlignment = NSTextAlignmentCenter;
        evaluateLabel.text = [NSString stringWithFormat:@"%ld分",self.storeModel.store_evaluate];
        [cell.contentView addSubview:evaluateLabel];
        
        UILabel * priceLbael = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 200, 30)];//ScreenW - 110, 8, 100, 30
//        priceLbael.textAlignment = 2;
        priceLbael.textColor = [UIColor colorWithHexString:MainColor];
        priceLbael.font = [UIFont systemFontOfSize:28];
//        priceLbael.text = [NSString stringWithFormat:@"￥%.1f",self.goodsModel.goods_price];
        NSMutableAttributedString *start = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥"]];
        NSMutableAttributedString *end = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",self.goodsModel.goods_price]];
        [start addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, 1)];
        [end addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28.0] range:NSMakeRange(0, start.length)];
        
        [start appendAttributedString:end];
        priceLbael.attributedText = start;
//        StarsView * startView =[[StarsView alloc] initWithFrame:CGRectMake(10, 56, 100, 24)];
//        [cell.contentView addSubview:startView];
        //分割线
        UIView * sptString =[[UIView alloc] initWithFrame:CGRectMake(0, 46, ScreenW, 1)];
        sptString.backgroundColor = [UIColor colorWithHexString:BackColor];
        [cell.contentView addSubview:sptString];
        //
        UILabel * saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 110, 60, 100, 30)];
        saleLabel.textAlignment = 2;
        saleLabel.font = [UIFont systemFontOfSize:13];
        saleLabel.textColor =[UIColor colorWithHexString:WordLightColor];
        saleLabel.text = [NSString stringWithFormat:@"%@人付款",self.goodsModel.goods_salenum];
        
        [cell.contentView addSubview:saleLabel];
        
        [cell.contentView addSubview:nameLbael];
        [cell.contentView addSubview:priceLbael];
        
        return cell;
    }
    else if(indexPath.section == 2){
        
        UITableViewCell * cell =[[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        
        if (_goodsType == 1) {
            _countView =[[HDCarNumberCOunt alloc] initWithFrame:CGRectMake(ScreenW - 100, 4, 90, 32)];
            _countView.layer.borderWidth = 1;
            _countView.layer.borderColor = [UIColor colorWithHexString:BackColor].CGColor;
            _countView.NumberChangeBlock = ^(NSInteger count){
                
                _goodsCount = count;
                
            };
            [cell.contentView addSubview:_countView];
            
            UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
            label.text = @"数量:";
            label.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:label];
            
            StorecouponView *couponView = [[StorecouponView alloc] initWithFrame:CGRectMake(0, 40, ScreenW, 45)];
            UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetCoupons)];
            couponView.tag = 12;
            [couponView addGestureRecognizer:tapges];
            couponView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:BackColor];
            couponView.userInteractionEnabled = YES;
            [cell.contentView addSubview:couponView];
        } else if (_goodsType == 2) {
            StorecouponView *couponView = [[StorecouponView alloc] initWithFrame:CGRectMake(0, 5, ScreenW, 45)];
            UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetCoupons)];
            couponView.tag = 12;
            [couponView addGestureRecognizer:tapges];
            couponView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:BackColor];
            couponView.userInteractionEnabled = YES;
            [cell.contentView addSubview:couponView];
        }
        
        
        return  cell;
        
    }else if (indexPath.section == 3){
        
        StoresLocatedCell * cell = [tableView dequeueReusableCellWithIdentifier:storesLocateCellIndertfier forIndexPath:indexPath];
        cell.selectionStyle = NO;

        cell.storeNameLabel.text = self.storeModel.store_name;
        if (self.storeModel.distance > 1000) {
            
            cell.constantLabel.text= [NSString stringWithFormat:@"距离%.2fkm",self.storeModel.distance/1000];
        }else{
            
            cell.constantLabel.text= [NSString stringWithFormat:@"距离%.2fm",self.storeModel.distance];

        }
        cell.adressLabel.text = self.storeModel.store_address;
        [cell.StoresPhoneBtn addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchDown];
        //
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpStore)];
                                                                                                                  
        [cell.shopNameView addGestureRecognizer:tapGesture];
        
        return cell;
        
    }else if (indexPath.section == 4){
        
        UserCommentsModel * model = self.commentsArray[indexPath.row];
        
        _commentCell = [tableView dequeueReusableCellWithIdentifier:userCommentInderfer forIndexPath:indexPath];
        
        _commentCell.goodsModel = model;
        
        _commentCell.selectionStyle = NO;

        return _commentCell;
       
    }else if (indexPath.section == 5){
        
      
        goodsCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIndertifer forIndexPath:indexPath];
       [cell.goodsImgeVIew sd_setImageWithURL:[NSURL URLWithString:self.relevantGoodsRecommendArray[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        cell.goodsDetailLabel.text = self.relevantGoodsRecommendArray[indexPath.row][@"goods_name"];
//
        CGFloat priceValue = [self.relevantGoodsRecommendArray[indexPath.row][@"goods_price"] floatValue];
       cell.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",priceValue];
        cell.goodsPriceLabel.textColor = [UIColor colorWithHexString:MainColor];
        
        return cell;
        
    }else{
        
        goodsCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIndertifer forIndexPath:indexPath];
        
        [cell.goodsImgeVIew sd_setImageWithURL:[NSURL URLWithString:self.moreGoodsArray[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        cell.goodsDetailLabel.text = self.moreGoodsArray[indexPath.row][@"goods_name"];
        
        CGFloat price  = [self.moreGoodsArray[indexPath.row][@"goods_price"] floatValue];
        cell.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",price] ;
        cell.goodsPriceLabel.textColor = [UIColor colorWithHexString:MainColor];
        
        return cell;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 || section == 2 || section == 3) {
        
        return 1;
        
    }else if (section == 1){
        
        return 1;

    }
    else if (section == 4){
        
        return self.commentsArray.count;
        
    }else if(section == 5){
        
        return self.relevantGoodsRecommendArray.count;
        
    }else{
        
        return self.moreGoodsArray.count;

    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return ScreenW;//160 * ScreenScale;
        
    }else if (indexPath.section == 1){
        //线下
        return 95;

    }
    else if(indexPath.section == 2){
        if (_goodsType == 1) {
            return 40+45;
        } else {
            
            return 45;
        }
    }else if (indexPath.section == 3){
        
        return 100;

        
    }else if (indexPath.section == 4){
        
                if (self.commentsArray.count > 0) {
        
                    UserCommentsModel * model = self.commentsArray[indexPath.row];
        
                    return    [_commentCell getPointCellHeight:model];
                    
                }else{
                    return 0;
                }
        
    }
    else{
        
        return 100;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.01;
        
    }else if (section ==1){
        
        return 3;

    }
    else if (section == 2){
        
        return 3;
        
    }else if (section == 3){
        
        return 6;
    }
    else if(section == 4){
        
        if (self.commentsArray.count > 0) {
            
            return 50;

        }
    }else if (section == 5){
        
        if (self.relevantGoodsRecommendArray.count > 0) {
            
            return 50;

        }else{
            
            return 0.01;
        }
    }else{
        
        if (self.moreGoodsArray.count > 0) {
            
            return 50;

        }else{
            
            return 0.01;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ) {
        
        return 0.01;
        
    }else if (section == 1){
        
        if (_goodsType == 2) {
            
            return 3;
            
        }else{
            
        return 0.01;

}
    }
    else if (section == 2){
        
        return 1;
    }
    else if (section == 3 ){
        
        return 3;
        
    }else if(section == 4){
        
            return 35;

        
    }else if(section == 5){
        
        if (self.relevantGoodsRecommendArray.count > 0) {
            
            return 35;

        }else{
            
            return 0.01;
        }
    }else {
        if (self.moreGoodsArray.count > 0) {
            
            return 35;

        }else{
            
            return 0.01;
        }
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 4) {
        if (self.commentsArray.count > 0) {
            UIView * buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
            
            buttonBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
            //创建BUtton
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW , 40)];
            button.tag = buttonTag + 10;
            //设置字体和圆角
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor whiteColor];
            
            [button setTitle:@"查看更多评论" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
            [buttonBgView addSubview:button];
            [button addTarget:self action:@selector(goTomoreCommnetsVC) forControlEvents:UIControlEventTouchDown];
            
            return buttonBgView;

        }
    }
   else if (section == 5) {
       if (self.relevantGoodsRecommendArray.count > 0) {
           UIView * buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
           
           buttonBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
           //创建BUtton
           UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW , 40)];
           button.tag = buttonTag + 10;
           //设置字体和圆角
           button.titleLabel.font = [UIFont systemFontOfSize:14];
           button.backgroundColor = [UIColor whiteColor];
           
           [button setTitle:@"查看更多相关商品" forState:UIControlStateNormal];
           [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
           [buttonBgView addSubview:button];
           [button addTarget:self action:@selector(goTomoreGoodsVC) forControlEvents:UIControlEventTouchDown];
           
           return buttonBgView;
       }
     
   }else if (section == 6){
       if (self.moreGoodsArray.count) {
           
           UIView * buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
           
           buttonBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
           //创建BUtton
           UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW , 40)];
           button.tag = buttonTag + 10;
           //设置字体和圆角
           button.titleLabel.font = [UIFont systemFontOfSize:14];
           button.backgroundColor = [UIColor whiteColor];
           
           [button setTitle:@"查看全部商品" forState:UIControlStateNormal];
           [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
           [buttonBgView addSubview:button];
           [button addTarget:self action:@selector(goTomoreGoodsVC) forControlEvents:UIControlEventTouchDown];
           
           return buttonBgView;
       }
     
   }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW , 34)];
        UIView * seperateView =[[UIView alloc] initWithFrame:CGRectMake(0, 34, ScreenW, 1)];
        seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
        [bgView addSubview:seperateView];
        [bgView addSubview:label];
        bgView.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text =@"评论";
        [label setTextColor:[UIColor blackColor]];
        
        
        //评论数量
        UILabel * commentsNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 210, 0, 200, 35)];
        commentsNumberLabel.textAlignment = 2;
        commentsNumberLabel.text =[NSString stringWithFormat:@"%ld条",_evaluates_count];
        
        [bgView addSubview:commentsNumberLabel];
        commentsNumberLabel.font = [UIFont systemFontOfSize:15];
        return bgView;

    }
   else if (section == 5) {
       if (self.relevantGoodsRecommendArray.count > 0)  {
           
           UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
           UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW , 34)];
           UIView * seperateView =[[UIView alloc] initWithFrame:CGRectMake(0, 34, ScreenW, 1)];
           seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
           [bgView addSubview:seperateView];
           [bgView addSubview:label];
           bgView.backgroundColor = [UIColor whiteColor];
           label.font = [UIFont systemFontOfSize:15];
           label.text =@"相关商品";
           [label setTextColor:[UIColor blackColor]];
           
           return bgView;
           

       }
        } else if (section == 6) {
            
            if (self.moreGoodsArray.count > 0) {
                
                UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW , 34)];
                UIView * seperateView =[[UIView alloc] initWithFrame:CGRectMake(0, 34, ScreenW, 1)];
                seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
                [bgView addSubview:seperateView];
                [bgView addSubview:label];
                bgView.backgroundColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:15];
                label.text =@"更多商品";
                [label setTextColor:[UIColor blackColor]];
                
                return bgView;
                
            }
      }
    return 0;
}
#pragma mark -----领取优惠券
- (void)GetCoupons{
    [self hiddenOrShowCouponVC:NO];
}
#pragma mark  -----查看更多商品
-(void)goTomoreGoodsVC{
    
        if (self.moreGoodsArray.count > 0) {
            
            AllStoresGoodsController * allShopVC = [[AllStoresGoodsController alloc] init];
            
            allShopVC.type = _goodsType;
            //查看更多商品
            allShopVC.moreGoodsType = 1;
            
            allShopVC.goodsId = [NSString stringWithFormat:@"%@", self.goodsId];
            
            [self.navigationController pushViewController:allShopVC animated:YES];
            
        }
        
    
}
#pragma mark ---查看更多评论
-(void)goTomoreCommnetsVC{
    
    AllCommnetsController * allCommentsVC =[[AllCommnetsController alloc] init];
    //商品评论
    allCommentsVC.storeId = self.goodsModel.goods_id;
    
    allCommentsVC.requestUrl = appGoodsEvaluateListUrl;
    
    allCommentsVC.type = 1;
    
    [self.navigationController pushViewController:allCommentsVC animated:NO];
    
}
//打电话
-(void)phone:(UIButton *)btn{
    
    UIWebView * webVIew = [[UIWebView alloc] init];
    NSString * phoneNumber = self.storeModel.store_telephone;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [webVIew loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webVIew];
    
}
#pragma mark ---立即购买
-(void)onlineOrder{
    
    //线下
    if (_goodsType == 2) {
        
        [SVProgressHUD showWithStatus:@"请稍等"];

        [self buyGoodsAtonce];

    }else{
        //购买
        _isAddOrBuy = 1;
        
        //显示规格，有就显示，没有就不显示
        if (self.meatureArray.count) {
            
            [self initChoseView];
            
            [self show];
        }else{
           //立即跳转
            [self buyGoodsAtonce];
        }
        
    }
}
#pragma mark ---立即购买
-(void)buyGoodsAtonce{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"goodsId"] = self.goodsId;
   
    param[@"count"] = [NSString stringWithFormat:@"%ld",_goodsCount];
    
      [weakself POST:buy_now_orderUrl parameters:param success:^(id responseObject) {
          
          
          NSString * str = responseObject[@"isSucc"];
          
          NSDictionary * dic = responseObject[@"result"];
          
          if ([str integerValue] == 1) {
              
              if (_goodsType == 1) {
                  
                  OnlineOrderController * onlineVC = [[OnlineOrderController alloc] init];
                  [onlineVC.ImageArray addObject:self.goodsModel];
                  onlineVC.goodsCount = _goodsCount;
                  onlineVC.storeId = _storeModel.store_id;
                  onlineVC.storeCartId = dic[@"sotreCartId"];
                  onlineVC.goodsCartId = dic[@"goodsCartId"];
                  onlineVC.amountMoney = dic[@"amountMoney"];
                  onlineVC.userMobile = dic[@"userMobile"];
                  
                  [self.navigationController pushViewController:onlineVC animated:YES];
              }else{
                  
                  groupGoodsController * groupVC =[[groupGoodsController alloc] init];
                  
                  [groupVC.ImageArray addObject:self.goodsModel];
                  groupVC.storeCartId = dic[@"sotreCartId"];
                  groupVC.goodsCartId = dic[@"goodsCartId"];
                  groupVC.amountMoney = dic[@"amountMoney"];
                  groupVC.userMobile = dic[@"userMobile"];
                  
                  groupVC.goodsCount = _goodsCount;

                  [self.navigationController pushViewController:groupVC animated:YES];
              }
              
          }else{
              
              [self showStaus:responseObject[@"msg"]];
          }
  } failure:^(NSError *error) {
      
  }];
}
#pragma mark ---规格相关
-(void)initChoseView
{
    //选择尺码颜色的视图
     _choseView = [[ChoseView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_choseView];
    [_choseView.bt_cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_choseView.bt_sure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    //
    [_choseView initTypeView:self.meatureArray];
    
    [_choseView initContentView:self.stockArray];
    
    //点击黑色透明视图choseView会消失
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_choseView.alphaiView addGestureRecognizer:tap];
    
}
#pragma mark ---尺寸数据请求
-(void)requestMetureData{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"id"] = self.goodsId;
    
    [self.httpManager POST:goodsSpecUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * str = responseObject[@"isSucc"];
        
        if ([str integerValue] == 1) {
            
            NSArray * resltuArray = responseObject[@"result"][@"specs"];
            
            weakself.meatureArray = [NSMutableArray arrayWithArray:resltuArray];
            
            NSString * metureString = responseObject[@"result"][@"goods_inventory_detail"];
            //
            if (metureString != nil) {
                
                NSData * resData = [[NSData alloc] initWithData:[metureString dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSArray * josnArray = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];  //解析
                weakself.stockArray = [NSMutableArray arrayWithArray:josnArray];
            }
            
        }else{
            
              [self showStaus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
             [self showStaus:@"网络错误"];
        
    }];

}

#pragma mark  ----选择商品尺寸

-(void)show
{
    

    center = _vcScrollView.center;
    center.y -= 64;
    
    _tableView.frame = CGRectMake(0, 0, ScreenW, screenH);
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration: 0.35 animations: ^{
        
        _vcScrollView.center = center;
        _vcScrollView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
        
        [_vcScrollView bringSubviewToFront:_choseView];
        _choseView.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height);
        
    } completion: nil];
    
    
}
-(void)dismiss
{
     center.y += 64;
    
     _tableView.frame = CGRectMake(0, 64, ScreenW, screenH - 64);

    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [UIView animateWithDuration: 0.35 animations: ^{
        
    _choseView.frame =CGRectMake(0, self.view.frame.size.height + 200, self.view.frame.size.width, self.view.frame.size.height);
    _vcScrollView.center = center;
    _vcScrollView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
     
    } completion: nil];
    
}
#pragma mark  ----确定购买
-(void)sure
{
    
    
    NSString * priceValue = _choseView.lb_price.text;
    
    if (priceValue.length ) {
        
        NSMutableString * mstring = [NSMutableString stringWithString:priceValue];
        [mstring deleteCharactersInRange:NSMakeRange(0, 1)];
        
        priceValue = [NSMutableString stringWithString:mstring];
    }
 
    
    if ([priceValue floatValue] > 0 && _choseView.stock > 0) {
        
        [self dismiss];
        
        [SVProgressHUD showWithStatus:@"请稍等"];

        NSString  * contentString = _choseView.contentString;
        NSArray * array = [contentString componentsSeparatedByString:@"_"];
        
        NSString * mContentString= [NSString string];
        NSMutableString  * mmmstring = [NSMutableString string];

        for (NSString * str in array) {
            
        mContentString = [mContentString stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
            
      

        }
        mmmstring = [NSMutableString stringWithString:mContentString];
        
        [mmmstring deleteCharactersInRange:NSMakeRange(mContentString.length - 1, 1)];
        _goodsCount = [_choseView.countView.tf_count.text intValue];
        //判断是加入购物车还是立即购买
        if (_isAddOrBuy == 1) {
            
            [self buyAtonceRequest:mmmstring];

        }else{
            
            [self addMetureGoodsShopcar:mmmstring];

        }
        
        
    }else{
    
        // 设置显示文本信息
       [self showStaus:@"请选择正确的规格"];
   
    }
    
    
}
#pragma mark ---立即购买请求
-(void)buyAtonceRequest:(NSString *)string{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"goodsId"] = self.goodsId;
    param[@"gsp"] = string;
    
    param[@"count"] = [NSString stringWithFormat:@"%ld",_goodsCount];
    
    [weakself POST:buy_now_orderUrl parameters:param success:^(id responseObject) {
        
        
        NSString * str = responseObject[@"isSucc"];
        
        NSDictionary * dic = responseObject[@"result"];
        
        if ([str integerValue] == 1) {
            
            if (weakself.goodsType == 1) {
                
                OnlineOrderController * onlineVC = [[OnlineOrderController alloc] init];
                [onlineVC.ImageArray addObject:self.goodsModel];
                
                onlineVC.storeCartId = dic[@"sotreCartId"];
                onlineVC.goodsCartId = dic[@"goodsCartId"];
                onlineVC.amountMoney = dic[@"amountMoney"];
                onlineVC.userMobile = dic[@"userMobile"];
                onlineVC.goodsCount = _goodsCount;
                
                [weakself.navigationController pushViewController:onlineVC animated:YES];
                
            }else{
                
                groupGoodsController * groupVC =[[groupGoodsController alloc] init];
                
                [groupVC.ImageArray addObject:self.goodsModel];
                groupVC.storeCartId = dic[@"sotreCartId"];
                groupVC.goodsCartId = dic[@"goodsCartId"];
                groupVC.amountMoney = dic[@"amountMoney"];
                groupVC.userMobile = dic[@"userMobile"];
                
                groupVC.goodsCount = _goodsCount;
                
                [weakself.navigationController pushViewController:groupVC animated:YES];
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ---添加购物车
-(void)addShopCar:(UIButton *)sender{
    //加入购物车
    _isAddOrBuy = 2;
    //显示规格，有就显示，没有就不显示
    if (self.meatureArray.count) {
        
        [self initChoseView];
        
        [self show];
    }else{
        //立即跳转
        [self addOnlineShopCar];
    }
    
    
}
#pragma mark ---不带规格的请求
-(void)addOnlineShopCar{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        param[@"goodsId"] =self.goodsId;
        
        param[@"count"] = [NSString stringWithFormat:@"%ld",_goodsCount];
        
        param[@"type"] =[NSString stringWithFormat:@"%ld", _goodsType];
        
        [self POST:add_goodsCart_storeCartUrl parameters:param success:^(id responseObject) {
            
            int i = [responseObject[@"isSucc"] intValue];
            
            if (i ==1) {
                
                [User defalutManager].lineShopCart = [User defalutManager].lineShopCart + _goodsCount ;
                
                //改变购物车数量
                
                _shopCartNumberLbel.text =[NSString stringWithFormat:@"%ld", [User defalutManager].lineShopCart];
                
                [weakself showStaus:@"加入购物车成功"];
                
            }
            
        } failure:^(NSError *error) {
            
            
            
        }];
        
        
        
        }else{
        
        LandingViewController * landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }

}
#pragma mark ---带规格的添加购物车请求

-(void)addMetureGoodsShopcar:(NSString *)str{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        param[@"goodsId"] =self.goodsId;
        
        param[@"count"] = [NSString stringWithFormat:@"%ld",_goodsCount];
        
        param[@"type"] =[NSString stringWithFormat:@"%ld", _goodsType];
        param[@"gsp"] = str;
        
        [self POST:add_goodsCart_storeCartUrl parameters:param success:^(id responseObject) {
            
            int i = [responseObject[@"isSucc"] intValue];
            
            if (i ==1) {
                
                [User defalutManager].lineShopCart = [User defalutManager].lineShopCart + _goodsCount ;
                
                //改变购物车数量
                
                _shopCartNumberLbel.text =[NSString stringWithFormat:@"%ld", [User defalutManager].lineShopCart];
                
                [weakself showStaus:@"加入购物车成功"];
                
            }
            
        } failure:^(NSError *error) {
            
            
            
        }];
        
        
        
    }else{
        
        LandingViewController * landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
}
#pragma mark --- 跳转到购物车
-(void)jumpShopCarVC{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        HDshopCarBaseController * shopCar = [[HDshopCarBaseController alloc] init];
        [self.navigationController pushViewController:shopCar animated:YES];
        
    }else{
        
        LandingViewController * landVC =[[LandingViewController alloc] init
                                         ];
        [self.navigationController pushViewController:landVC animated:YES];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        
        
        if (self.storeModel.store_lat > 0 && self.storeModel.store_lng > 0) {
            
            MapLocationViewController * MapVC = [[MapLocationViewController alloc] init];
           MapVC.model = self.storeModel;
            
            [self.navigationController pushViewController:MapVC animated:YES];
            
        }else{
            
            [self showStaus:@"该商家没有设置经纬度"];
        }
    }else  if (indexPath.section == 6) {
        
        
        ShopsGoodsBaseController * goodsVC =[[ShopsGoodsBaseController alloc] init];
        //线下
        goodsVC.goodsType = _goodsType;
        
        goodsVC.goodsId =  self.moreGoodsArray[indexPath.row][@"goods_id"];
        
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}
#pragma mark---跳转到商家
-(void)jumpStore{
    
    [User defalutManager].selectedShop = [NSString stringWithFormat:@"%@", self.storeModel.store_id];
    
    UIStoryboard * storybord =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController * MyVC = [storybord instantiateViewControllerWithIdentifier:@"ShopDetailViewController"] ;
    
    [self.navigationController pushViewController:MyVC animated:YES];
    
}
-(void)shareGoods{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        
        [UMSocialQQHandler setQQWithAppId:@"1105491978" appKey:@"4vcul0EYJddeh32a" url:[NSString stringWithFormat:@"%@?id=%@",wapGoodsByIdUrl,self.goodsId]];
        
        [UMSocialWechatHandler setWXAppId:__WXappID appSecret:__WXappSecret url:[NSString stringWithFormat:@"%@?id=%@",wapGoodsByIdUrl,self.goodsId]];
        
        //分享类型为店铺
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title =self.goodsModel.goods_name;
        [UMSocialData defaultData].extConfig.qqData.title = self.goodsModel.goods_name;
        //分享文字
        NSString * shareText = [NSString stringWithFormat:@"%@",self.goodsModel.goods_name];
        
        // 显示分享界面
        
        UIImageView * imageView =  [self.view viewWithTag:500];
        //分享图片
        UIImage * shareImage = imageView.image;
        
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMSocialAppKey                                      shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone, nil] delegate:nil];
    }else{
        
        [self goLanding];
        
    }

}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end

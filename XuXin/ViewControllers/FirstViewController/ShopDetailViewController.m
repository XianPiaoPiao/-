//
//  ViewController.m
//  WUParallaxView
//
//

#import "ShopDetailViewController.h"
#import "recmondShopModel.h"
#import "RecommodTableViewCell.h"
#import "NeiborTableViewCell.h"
#import "MoreShopTableViewCell.h"
#import "PayViewController.h"
#import "SupendPayView.h"
#import "PhoneTableViewCell.h"
#import "MapLocationViewController.h"
#import "MoreShopimageController.h"
#import "StoresGoodsCellTableViewCell.h"
#import "OnlineGoodsModel.h"
#import "GroupGoodsMOdel.h"
#import "AllStoresGoodsController.h"
#import "AllCommnetsController.h"
#import "UserCommentsCell.h"
//友盟分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

#import "JionHaiduiBeforeController.h"
#import "LandingViewController.h"
#import "OrderCommentsController.h"
#import "ShopsGoodsBaseController.h"
#import "StorecouponView.h"
#import "CouponsViewController.h"

NSString * const userCommentCellIndertifer = @"UserCommentsCell";
NSString * const recommondIdertifer1 = @"RecommodTableViewCell";
NSString * const neiborIndertifer = @"NeiborTableViewCell";
NSString * const MoreShopIndertifer = @"MoreShopTableViewCell";
NSString * const orderFoodIndertifer = @"OrderFoodTableViewCell";
NSString * const orderSiteIndertifer = @"OrderSiteTableViewCell";
NSString * const phoneInderfier = @"PhoneTableViewCell";

NSString * const GroupGoodsIndertifer = @"StoresGoodsCellTableViewCell";
#define kHeadH 140.0f //头视图的高度
#define kHeadMinH 64.0f //状态栏高度20 + 导航栏高度44
#define kBarH 75.0f//头视图下边支付View的高度

@interface ShopDetailViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,copy) NSString * favoriteId;
@property (nonatomic ,assign)NSInteger comentscount;
@property (weak, nonatomic) IBOutlet UINavigationItem *prefixTitle;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;
@property (weak, nonatomic) IBOutlet UIView *supendView;
@property (nonatomic,strong)recmondShopModel * shopModel;

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic ,strong)NSMutableDictionary * dataDic;
//
@property (nonatomic ,strong)NSMutableArray * moreShopDataArray;
@property (nonatomic ,strong)NSMutableArray * imageArray;
@property (nonatomic ,strong)NSMutableArray * groupGoodsArray;
@property (nonatomic ,strong)NSMutableArray * onLineGoodsArray;

@property(nonatomic ,strong)NSMutableArray * commentsArray;

@property (nonatomic, strong) CouponsViewController *couponVC;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;


@end

@implementation ShopDetailViewController{


    UIBarButtonItem * _item;
    UIBarButtonItem * _item2;
    UIBarButtonItem * _ReturnItem;
    
    UIButton * _backBtn;
    UIButton * _backBtn2;
    UIButton * _backBtn3;
    UIView * _navBgview;
    
    SupendPayView * _supView;
    
    UserCommentsCell * _cell;
}

-(NSMutableArray *)moreShopDataArray{
    if (!_moreShopDataArray) {
        _moreShopDataArray = [[NSMutableArray alloc] init];
    }
    return _moreShopDataArray;
}
-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}
-(recmondShopModel *)shopModel{
    if (!_shopModel) {
        
        _shopModel = [[recmondShopModel alloc] init];
    }
    return _shopModel;
}
-(NSMutableArray *)onLineGoodsArray{
    if (!_onLineGoodsArray) {
        _onLineGoodsArray = [[NSMutableArray alloc] init];
    }
    return _onLineGoodsArray;
}
-(NSMutableArray *)groupGoodsArray{
    if (!_groupGoodsArray) {
        _groupGoodsArray = [[NSMutableArray alloc] init];
    }
    return _groupGoodsArray;
}
-(NSMutableArray *)commentsArray{
    if (!_commentsArray) {
        
        _commentsArray = [[NSMutableArray alloc] init];
    }
    return _commentsArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:MainColor];

    [UIApplication sharedApplication].statusBarHidden = NO;
    
     self.navigationController.navigationBarHidden = NO;
    
    [MTA trackPageViewBegin:@"ShopDetailViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MTA trackPageViewEnd:@"ShopDetailViewController"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headViewHeight.constant = 204;
    
    [self.view bringSubviewToFront:self.headView];
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatNavgationBar];
    //让标题等于空
    self.title = @"";
    //数据请求
    [self firstLoad];
    //更多商家数据请求
    [self creatUI];
    
    [self createCouponView];
}

-(BOOL)fd_prefersNavigationBarHidden {
    
    return YES;
}
-(void)creatUI{
    //创建支付view
    _supView = [[SupendPayView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 75)];
    [_supView.payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchDown];

    [self.supendView addSubview:_supView];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //透明度
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.sectionFooterHeight = 4;
    self.tableView.sectionHeaderHeight = 4;
    
    self.tableView.contentInset = UIEdgeInsetsMake(kHeadH + kBarH , 0, 0, 0);
    self.visualEffectView.frame = self.headView.bounds;
    self.tableView.separatorStyle = NO;
   
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpMorePicture)];
    self.headView.userInteractionEnabled = YES;
    [self.headView addGestureRecognizer:tapGesture];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommodTableViewCell" bundle:nil] forCellReuseIdentifier:recommondIdertifer1];
    [self.tableView registerNib:[UINib nibWithNibName:@"NeiborTableViewCell" bundle:nil] forCellReuseIdentifier:neiborIndertifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"MoreShopTableViewCell" bundle:nil] forCellReuseIdentifier:MoreShopIndertifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderFoodTableViewCell" bundle:nil] forCellReuseIdentifier:orderFoodIndertifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderSiteTableViewCell" bundle:nil] forCellReuseIdentifier:orderSiteIndertifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhoneTableViewCell" bundle:nil] forCellReuseIdentifier:phoneInderfier];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoresGoodsCellTableViewCell" bundle:nil] forCellReuseIdentifier:GroupGoodsIndertifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserCommentsCell" bundle:nil] forCellReuseIdentifier:userCommentCellIndertifer];
    //背景图
    UIView * buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 65)];
    
    buttonBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
    //创建BUtton
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenW - 20, 50)];
    //设置字体和圆角
    button.layer.cornerRadius = 25;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor colorWithHexString:MainColor];
    [button setImage:[UIImage imageNamed:@"ruzhu@2x"] forState:UIControlStateNormal];
    [button setTitle:@"撬开门店,立即入驻" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImagePositionWithType:SSImagePositionTypeLeft spacing:10];
    [buttonBgView addSubview:button];
    [button addTarget:self action:@selector(joinHaidui) forControlEvents:UIControlEventTouchDown];
    self.tableView.tableFooterView = buttonBgView;
}

- (void)createCouponView{
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor colorWithHexString:WordColor alpha:0.5];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCouponVC)];
    [_bgView addGestureRecognizer:tapges];
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
- (void)hiddenCouponVC{
    [self hiddenOrShowCouponVC:YES];
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
//        [UIView setAnimationDidStopSelector:@selector(didAfterHidden:)];
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
#pragma mark ---面对面支付
-(void)pay{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        PayViewController * payVC = [[PayViewController alloc] init];
        payVC.storeName = self.shopModel.store_name;
        payVC.storeAdress = self.shopModel.store_address;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
        
    }else{
        LandingViewController * landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
    

}
-(void)firstLoad{
    
    [self requestData];
    //开始动画
    [[EaseLoadingView defalutManager] startLoading];
    
    [self.view addSubview:[EaseLoadingView defalutManager]];
}
#pragma mark ---跳转到更多图片
-(void)jumpMorePicture{
    
    MoreShopimageController * moreShopVC = [[MoreShopimageController alloc] init];
    moreShopVC.imageArray = [NSMutableArray arrayWithArray:self.imageArray];
    
    [self.navigationController pushViewController:moreShopVC animated:YES];
}
#pragma mark ---商家详情
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    //开始加载动画
  
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"storeId"] = [User defalutManager].selectedShop;
    
    [weakself POST:storeDetailUrl parameters:param success:^(id responseObject) {
        
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            //停止动画
            [[EaseLoadingView defalutManager] stopLoading];
            
          
           _shopModel = [recmondShopModel yy_modelWithDictionary:responseObject[@"result"]];

            NSArray  * array = responseObject[@"result"][@"moreStore"];
            //评论数
            _comentscount =  [responseObject[@"result"][@"evaluate_count"] integerValue];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[MoreShopModel class] json:array];
            
            weakself.moreShopDataArray = [NSMutableArray arrayWithArray:modelArray];
            //线上商品
            NSArray * goodsArray = responseObject[@"result"][@"onLine_goods"];
              NSArray * goodsModelArray = [NSArray yy_modelArrayWithClass:[ONLINEgoodsModel class] json:goodsArray];
            
            weakself.onLineGoodsArray = [NSMutableArray arrayWithArray:goodsModelArray];
            //线下商品
            NSArray * groupArray = responseObject[@"result"][@"group_goods"];
              NSArray * groupModelArray = [NSArray yy_modelArrayWithClass:[GroupGoodsMOdel class] json:groupArray];
            weakself.groupGoodsArray = [NSMutableArray arrayWithArray:groupModelArray];
            
            NSArray * commentsArray = responseObject[@"result"][@"evaluate"];
            
            NSArray * commentsModelArray = [NSArray yy_modelArrayWithClass:[UserCommentsModel class] json:commentsArray];
            
            weakself.commentsArray = [NSMutableArray arrayWithArray:commentsModelArray];
            //图片
            weakself.imageArray = responseObject[@"result"][@"slides"];
            
            //赋值
            _favoriteId =[NSString stringWithFormat:@"%ld", weakself.shopModel.favoriteId];
            
            if (weakself.shopModel.favoriteStatus == 1) {
                
                _backBtn.selected = YES;
                
            }else{
                
                _backBtn.selected = NO;
            }
            
            _couponVC.storeID = _shopModel.id;
            
        }
        
        //到主线程刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
            
            _supView.titleLabel.text = self.shopModel.store_name;
            
            if (self.shopModel.store_evaluate == 0) {
                
                _supView.starsView.starValue = 5;
                
            }else{
                
                _supView.starsView.starValue = self.shopModel.store_evaluate;
                
            }
            if (weakself.shopModel.percapita == 0) {
                
                _supView.priceLabel.text = @"人均/￥--";
                
            }else{
                
                _supView.priceLabel.text =[NSString stringWithFormat:@"人均/￥%ld", self.shopModel.percapita];
                
            }
            
            if (weakself.imageArray.count > 0) {

            [weakself.headView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0][@"slide"]] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
                
            }
        });

    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];

    }];
   
  

}

-(void)creatNavgationBar{
  
    //收藏
    UIImage * backImage = [UIImage imageNamed:@"s02@2x"];
    CGRect backframe = CGRectMake(0, 0, 30, 30);
    //已收藏
    
    UIImage * selectBackImage = [UIImage imageNamed:@"collection2@2x"];
    
    _backBtn = [[UIButton alloc] initWithFrame:backframe];
    
    [_backBtn setImage:selectBackImage forState:UIControlStateSelected];
    _backBtn.backgroundColor = [UIColor darkGrayColor];
    [_backBtn addTarget:self action:@selector(collectShop:)
       forControlEvents:UIControlEventTouchUpInside];
    _backBtn.selected = NO;
    
    [_backBtn setImage:backImage forState:UIControlStateNormal];
    _backBtn.layer.cornerRadius = 15;
    _item = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    //分享
    UIImage * backImage2 = [UIImage imageNamed:@"s03@2x"];
    
     _backBtn2 = [[UIButton alloc] initWithFrame:backframe];
    [_backBtn2 addTarget:self action:@selector(shareShop) forControlEvents:UIControlEventTouchUpInside];
    
    _backBtn2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [_backBtn2 setImage:backImage2 forState:UIControlStateNormal];
    _backBtn2.layer.cornerRadius = 15;
    _item2 = [[UIBarButtonItem alloc] initWithCustomView:_backBtn2]
    ;
    //返回
    UIImage * backImage3 = [UIImage imageNamed:@"s01"];
    
    _backBtn3 = [[UIButton alloc] initWithFrame:backframe];
    [_backBtn3 addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    
    _backBtn3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _backBtn3.layer.cornerRadius = 15;
    
    [_backBtn3 setImage:backImage3 forState:UIControlStateNormal];
    _ReturnItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn3];
    _ReturnItem.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.navigationItem.rightBarButtonItems = @[_item2,_item];
    self.navigationItem.leftBarButtonItems = @[_ReturnItem];
    
    

}
//方法实现
-(void)shareShop{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        
      [UMSocialQQHandler setQQWithAppId:@"1105491978" appKey:@"4vcul0EYJddeh32a" url:[NSString stringWithFormat:@"%@?id=%@",store_by_IDUrl,[User defalutManager].selectedShop]];
        
      [UMSocialWechatHandler setWXAppId:__WXappID appSecret:__WXappSecret url:[NSString stringWithFormat:@"%@?id=%@",store_by_IDUrl,[User defalutManager].selectedShop]];

        //分享类型为店铺

        [UMSocialData defaultData].extConfig.wechatSessionData.title =self.shopModel.store_name;
        [UMSocialData defaultData].extConfig.qqData.title = self.shopModel.store_name;
        //分享文字
        NSString * shareText = [NSString stringWithFormat:@"地址:%@",self.shopModel.store_address];
        
        // 显示分享界面
        
        //分享图片
        UIImage * shareImage = self.headView.image;
    
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMSocialAppKey                                      shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone, nil] delegate:nil];
    }else{
        
        [self goLanding];
        
    }
 
    
}
#pragma mark --- 收藏
-(void)collectShop:(UIButton *)btn{
    
    if (btn.selected == NO) {
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"storeId"] = [User defalutManager].selectedShop;
        [weakself POST:addFavoriteGoodsAndStoreUrl parameters:param success:^(id responseObject) {
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
                
                _favoriteId = responseObject[@"result"][@"favoriteId"];
                
                [self showStaus:@"收藏成功"];
                btn.selected = YES;
                
            }

        } failure:^(NSError *error) {
            

        }];


    }else{
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"favoriteIds"] = _favoriteId;
        
        [weakself POST:batchDeleteGoodsUrl parameters:param success:^(id responseObject) {
            
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
                
                [self showStaus:@"取消收藏成功"];
                btn.selected = NO;
                
            }
            
    } failure:^(NSError *error) {

    }];

}
}

-(void)backTo{
 
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        //计算偏移量，默认是-204;
    CGFloat beginOffsetY = -(kHeadH + kBarH);
    CGFloat offsetY = scrollView.contentOffset.y - beginOffsetY;
  //  CGFloat scale = -(scrollView.contentOffset.y / 140.0f);
    //向下拉: offsetY为负值，并且越来越小 这时图片高度需要变大
    //向上拉: offsetY为正值，并且越来越大，这是图片高度需要变小
    
    //所以
    CGFloat height = kHeadH - offsetY ;
    //当向上拖动的时候，头视图会越来越小，为了让选项卡，能够停留在导航栏下方。需要设置图片的最小高度是64。
    if (height < kHeadMinH) {
        height = kHeadMinH;
    }

    self.headView.frame = CGRectMake(-height/2.0f+ 102, -(height - 140)/2.0f, ScreenW + height - 204, height+(height - 140)/2.0f );
    self.supendView.frame = CGRectMake(0, height , ScreenW, 58);
    
   if (height < 204) {
       
       self.headView.frame = CGRectMake(0,  height -  204, ScreenW , 204);
       self.supendView.frame = CGRectMake(0, height , ScreenW, 58);
   }
    // 设置导航条的透明度
    CGFloat alpha = offsetY / (kHeadH - kHeadMinH);
    if (alpha >=1) {
        alpha = 1;
        _backBtn.backgroundColor = [UIColor clearColor];
        _backBtn2.backgroundColor = [UIColor clearColor];
        _backBtn3.backgroundColor = [UIColor clearColor];

        _item.tintColor = [UIColor colorWithHexString:MainColor];
        _item2.tintColor = [UIColor colorWithHexString:MainColor];
        _ReturnItem.tintColor = [UIColor colorWithHexString:MainColor];
    } else{
        _backBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
         _backBtn2.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _backBtn3.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _item.tintColor = [UIColor whiteColor];
        _item2.tintColor = [UIColor whiteColor];
        _ReturnItem.tintColor = [UIColor whiteColor];
    }
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 40+45;
    }else if (indexPath.section == 1){
        return 140;
    }else if (indexPath.section == 2){
        
        return 140;
    }else{
    UserCommentsModel * model = self.commentsArray[indexPath.row];
    
    return [_cell getPointCellHeight:model];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    }
    else if (section == 1){
        //
        return self.onLineGoodsArray.count;;
    }
     else if(section == 2){
         //
         
        return self.groupGoodsArray.count;
         
     }else{
         
         return self.commentsArray.count;
     }

}
//添加组的头视图
#pragma mark --添加头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        if (self.onLineGoodsArray.count > 0) {
            
            UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW , 34)];
            UIView * seperateView =[[UIView alloc] initWithFrame:CGRectMake(0, 34, ScreenW, 1)];
            seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
            [bgView addSubview:seperateView];
            [bgView addSubview:label];
            bgView.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15];
            label.text =@"线上商品";
            [label setTextColor:[UIColor blackColor]];
            return bgView;
        }else{
            
            return 0;
        }
      
    }else if (section == 2){
        if (self.groupGoodsArray.count > 0) {
            UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW , 34)];
            UIView * seperateView =[[UIView alloc] initWithFrame:CGRectMake(0, 34, ScreenW, 1)];
            seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
            [bgView addSubview:seperateView];
            [bgView addSubview:label];
            bgView.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15];
            label.text =@"线下商品";
            [label setTextColor:[UIColor blackColor]];
            return bgView;
        }else{
            
            return 0;
        }
      
    
    }else if (section == 3) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW , 34)];
        UIView * seperateView =[[UIView alloc] initWithFrame:CGRectMake(0, 34, ScreenW, 1)];
        seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
        [bgView addSubview:seperateView];
        [bgView addSubview:label];
        bgView.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text =@"评价";
        [label setTextColor:[UIColor blackColor]];

        
        //评论数量
        UILabel * commentsNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 210, 0, 200, 35)];
        commentsNumberLabel.text = [NSString stringWithFormat:@"%ld条评价",self.comentscount];
        commentsNumberLabel.textAlignment = 2;
        [bgView addSubview:commentsNumberLabel];
        commentsNumberLabel.font = [UIFont systemFontOfSize:15];
        return bgView;
    }
    return 0;
}
#pragma mark ---添组的脚视图

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        //背景图
        if (self.onLineGoodsArray.count > 0) {
            UIView * buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
            
            buttonBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
            //创建BUtton
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW , 40)];
            button.tag = buttonTag + 10;
            //设置字体和圆角
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor whiteColor];
            
            [button setTitle:@"查看全部商品" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:WordLightColor] forState:UIControlStateNormal];
            [buttonBgView addSubview:button];
            [button addTarget:self action:@selector(goToALLGroupVC:) forControlEvents:UIControlEventTouchDown];
            
            return buttonBgView;
            
        }else{
            
            return 0;
        }
      
        
    }else if (section ==2){
        //背景图
        if (self.groupGoodsArray.count > 0) {
            UIView * buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
            
            buttonBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
            //创建BUtton
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, ScreenW , 40)];
            
            button.tag = buttonTag + 11;
            
            //设置字体和圆角
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor whiteColor];
            
            [button setTitle:@"查看全部商品" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:WordLightColor] forState:UIControlStateNormal];
            [buttonBgView addSubview:button];
            [button addTarget:self action:@selector(goToALLGroupVC:) forControlEvents:UIControlEventTouchDown];
            return buttonBgView;
        }else{
            
            return 0;
        }
    }else if(section == 3){
        
        if (self.commentsArray.count > 0) {
            UIView * buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
            
            buttonBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
            //创建BUtton
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, ScreenW , 40)];
            
            button.tag = buttonTag + 11;
            
            //设置字体和圆角
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor whiteColor];
            
            [button setTitle:@"查看全部评论" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:WordLightColor] forState:UIControlStateNormal];
            [buttonBgView addSubview:button];
            [button addTarget:self action:@selector(goToAllCommentsVC) forControlEvents:UIControlEventTouchDown];
            return buttonBgView;

        }else{
            return 0;
        }
    }
        
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 ) {
        if (self.onLineGoodsArray.count > 0) {
            
             return 35;
            
        }else{
            
            return 0.01;
        }
       
    }else if (section == 2){
        
        if (self.groupGoodsArray.count > 0) {
            
            return 35;
            
        }else{
            
            return 0.01;
        }
    }else if (section == 3){
        
        return 35;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return 4;
        
    }else if (section == 1){
        
        if (self.onLineGoodsArray.count > 0) {
            
            return 50;

        }else{
            
            return 0.01;
        }
        
    }else if (section ==2){
        if (self.groupGoodsArray.count > 0) {
            
            return 50;
        }else{
            
            return 0.01;
        }
        
    }else{
        
        return 50;
    }
    return 0;
}
#pragma mark ---跳转到全部商品
-(void)goToALLGroupVC:(UIButton *)sender{
    if (sender.tag == buttonTag + 10) {
        if (self.onLineGoodsArray.count > 0) {
            
            AllStoresGoodsController * allShopVC = [[AllStoresGoodsController alloc] init];
            allShopVC.type = 1;
            allShopVC.storeId =  [User defalutManager].selectedShop;
            [self.navigationController pushViewController:allShopVC animated:YES];

        }
     
    }else{
        
        if (self.groupGoodsArray.count > 0) {
            
            AllStoresGoodsController * allShopVC = [[AllStoresGoodsController alloc] init];
            allShopVC.type = 2;
            allShopVC.storeId =  [User defalutManager].selectedShop;

            [self.navigationController pushViewController:allShopVC animated:YES];

        }
      
    }
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        PhoneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:phoneInderfier forIndexPath:indexPath];
        cell.placeLabel.text = self.shopModel.store_address;
        
        [cell.phoneBtn addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchDown];
        UITapGestureRecognizer * placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeSomeWhere)];
            [cell.placeView addGestureRecognizer:placeTap];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 60, 0, 60, 40)];
        [cell.contentView addSubview:btn];
        [btn addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchDown];
//        UIView * seperateString = [[UIView alloc] initWithFrame:CGRectMake(ScreenW - 60, 6, 1, 28)];
//        seperateString.backgroundColor = [UIColor lightGrayColor];
//        [cell.contentView addSubview:seperateString];
        
        [btn setImage:[UIImage imageNamed:@"shangjia_dianhua@3x"] forState:UIControlStateNormal];
        
        StorecouponView *couponView = [[StorecouponView alloc] initWithFrame:CGRectMake(0, 40, ScreenW, 45)];
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetCoupons)];
        couponView.tag = 12;
        [couponView addGestureRecognizer:tapges];
        couponView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:BackColor];
        couponView.userInteractionEnabled = YES;
        [cell.contentView addSubview:couponView];
        
         return cell;
    }else if (indexPath.section ==1){
        //线上商品
        StoresGoodsCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupGoodsIndertifer forIndexPath:indexPath];
        ONLINEgoodsModel * model = self.onLineGoodsArray[indexPath.row];
        cell.onlineGoodsModel = model;
        
        return cell;
    }else if (indexPath.section ==2){
        //线下商品
        StoresGoodsCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupGoodsIndertifer forIndexPath:indexPath];
        GroupGoodsMOdel * model = self.groupGoodsArray[indexPath.row];
        cell.groupModel = model;
        return cell;
    }
    else if (indexPath.section ==3){
        
        UserCommentsModel * model = self.commentsArray[indexPath.row];
        
        _cell = [tableView dequeueReusableCellWithIdentifier:userCommentCellIndertifer forIndexPath:indexPath];
        _cell.commentsModel = model;
        
        return _cell;

     
    }
    return 0;
}

#pragma mark -----领取优惠券
- (void)GetCoupons{
    NSLog(@"领取优惠券");
    [self hiddenOrShowCouponVC:NO];
}

//打电话
-(void)phone:(UIButton *)btn{
    
    UIWebView * webVIew = [[UIWebView alloc] init];
    NSString * phoneNumber = self.shopModel.store_telephone;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [webVIew loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webVIew];
   
}
//评论
-(void)goComment{
    
    OrderCommentsController * commentVC =[[OrderCommentsController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];
}
#pragma mark --定位
-(void)placeSomeWhere{
    
    if (self.shopModel.store_lat > 0 && self.shopModel.store_lng > 0) {
        
        MapLocationViewController * MapVC = [[MapLocationViewController alloc] init];
        MapVC.model = self.shopModel;
        
        [self.navigationController pushViewController:MapVC animated:YES];
        
    }else{
      
        [self showStaus:@"该商家没有设置经纬度"];
    }

    
    
}
#pragma mark ---全部评论
-(void)goToAllCommentsVC{
    AllCommnetsController * allComentVC =[[AllCommnetsController alloc] init];
    allComentVC.storeId = _shopModel.id;
    //店铺评价
    allComentVC.requestUrl = appStoreEvaluateListUrl;
    [self.navigationController pushViewController:allComentVC animated:NO];
}
#pragma mark ---跳转到商家详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        ONLINEgoodsModel * model = self.onLineGoodsArray[indexPath.row];
        ShopsGoodsBaseController * goodsVC =[[ShopsGoodsBaseController alloc] init];
        goodsVC.goodsId = model.id;
        //线上
        goodsVC.goodsType = 1;
        
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
   else if (indexPath.section == 2) {
        
       GroupGoodsMOdel * model = self.groupGoodsArray[indexPath.row];

       ShopsGoodsBaseController * goodsVC =[[ShopsGoodsBaseController alloc] init];
       //线下
       goodsVC.goodsType = 2;
       
       goodsVC.goodsId = model.id;
        
    [self.navigationController pushViewController:goodsVC animated:YES];
        
    }

}
#pragma  mark --我要加盟
-(void)joinHaidui{
    
    JionHaiduiBeforeController * joinHaiduiVC = [[JionHaiduiBeforeController alloc] init];
    
    [self.navigationController pushViewController:joinHaiduiVC animated:YES];

}

@end

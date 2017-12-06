//
//  CovertGoodsViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/22.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CovertGoodsViewController.h"
#import "CovertDetailTableViewCell.h"
#import "CovertRecordTableViewCell.h"
#import "SelectGoodsTableViewCell.h"
#import "WriteOrderViewController.h"
#import "ConvertPictureDetailViewController.h"
#import "UILabel+Extension.h"
//选择规格视图
#import "ChoseView.h"
//友盟分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

#import "FuntionTableViewCell.h"
#import "HeaderTableViewCell.h"
#import "SectionHeaderView.h"
#import "HDshopCarBaseController.h"
#import "IntergerGoodsDetailModel.h"
#import "MoreRecordController.h"
#import "MoreGoodsViewController.h"
#import "XXSegementControl.h"
#import "LandingViewController.h"
NSString * const convertDindertifer = @"CovertDetailTableViewCell";
NSString * const selectGoodsIndertifer = @"SelectGoodsTableViewCell";
NSString * const covertRecordInderfer = @"CovertRecordTableViewCell";
NSString * const covertHeadIndertifer = @"HeaderTableViewCell";
@interface CovertGoodsViewController ()<UITableViewDataSource ,UITableViewDelegate>

@property(nonatomic ,strong)NSMutableArray * convertDataArray;
@property (nonatomic ,strong)NSMutableArray * moreGoodsArray;
@property(nonatomic ,assign)NSInteger page;
@property (nonatomic ,copy)NSString * favoriteId;
@property (nonatomic ,assign)NSInteger goodsCount;

@property (nonatomic ,strong)NSMutableArray * meatureArray;//积分商品规格
@property (nonatomic ,strong)NSMutableArray * stockArray;//商品库存量
//1是购买 2 是添加购物车
@property (nonatomic ,assign)NSInteger isAddOrBuy;
@end

@implementation CovertGoodsViewController{
    
    CGFloat _curX;
    XXSegementControl * _segement;
    UIView * _botomView;
    UIScrollView * _contentScrollView;
    UITableView * _tableView;
    UILabel * _shopCartNumberLbel;
    //商品图片
    UIImageView * _convertImageView ;
    
    IntergerGoodsDetailModel * _leastGoodsModel;
    UIButton * _collectionButton;
    
    //规格相关
    HDCarNumberCOunt * _countView;
    
    //规格
    ChoseView * _choseView;
    
    CGPoint center;
    
    
    int goodsStock;
}
-(NSMutableArray *)ConvertDataArray{
    if (!_convertDataArray) {
        _convertDataArray = [[NSMutableArray alloc] init];
    }
    return _convertDataArray;
}
-(NSMutableArray *)moreGoodsArray{
    if (!_moreGoodsArray) {
        _moreGoodsArray = [[NSMutableArray alloc] init];
    }
    return _moreGoodsArray;
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
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [MTA trackPageViewBegin:@"CovertGoodsViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"CovertGoodsViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    //初始化商品数量
    _goodsCount = 1;
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumber) name:@"deleteConvertOK" object:nil];
    
    [self creatNavgationBar];
    
    [self creatUI];
    
    [self firstLoad];
    
    //规格数据请求
    [self requestMetureData];
    
}
#pragma mark ---改变购物车数量
-(void)changeNumber{
    
   _shopCartNumberLbel.text = [NSString stringWithFormat:@"%ld",[User defalutManager].shopcart];
}
//创建导航栏
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = YES;
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+self.StatusBarHeight, 60, 30)];
    [returnButton setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    //返回
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    
    [bgView addSubview:returnButton];
    
    NSArray *arr = [[NSArray alloc]initWithObjects:@"兑换商品",@"图文详情", nil];
    _segement = [[XXSegementControl alloc] initWithItems:arr];
    
    _segement.selectedSegmentIndex = 0;
    
    //添加点击事件
    [_segement addTarget:self action:@selector(jump:)];
    
    _segement.frame = CGRectMake(60, 27+self.StatusBarHeight, 210 * ScreenScale, 30);
    _segement.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
  //  [_segement setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor],UITextAttributeFont:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    _segement.tintColor = [UIColor colorWithHexString:MainColor];
    _segement.layer.cornerRadius = 5;
    [bgView addSubview:_segement];
    
    [self.view addSubview:bgView];
    
    _collectionButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 80, 27+self.StatusBarHeight, 30 , 30)];

    [_collectionButton setImage:[UIImage imageNamed:@"collection@2x"] forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"collection2@2x"] forState:UIControlStateSelected];
    _collectionButton.selected = NO;
    
    UIButton * shareBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 40, 27+self.StatusBarHeight, 30, 30)];
    [shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [bgView addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareIntegral) forControlEvents:(UIControlEventTouchDown)];
    
    [_collectionButton addTarget:self action:@selector(collectGoods:) forControlEvents:UIControlEventTouchDown];
    [bgView addSubview:_collectionButton];
    
}

#pragma mark --- 第一次请求

-(void)firstLoad{
    
    //动画
    
    [[EaseLoadingView defalutManager] startLoading];
    [self.view addSubview:[EaseLoadingView defalutManager]];
    
    [self requestGoodsData];
    
    [self requestMetureData];
}

#pragma mark ---商品详情数据请求
-(void)requestGoodsData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"id"] =[User defalutManager].selectedGoodsID;
    
    [weakself POST:integerGooodsDetailUrl parameters:param success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            [[EaseLoadingView defalutManager] stopLoading];
            //
            _leastGoodsModel = [IntergerGoodsDetailModel yy_modelWithDictionary:responseObject[@"result"]];
            
            
            NSArray * array = responseObject[@"result"][@"recommendGoods"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[Recommendgoods class] json:array];
            weakself.moreGoodsArray = [NSMutableArray arrayWithArray:modelArray];
            
            NSArray * array2 = responseObject[@"result"][@"exchangeRecord"];
            NSArray * modelArray2 = [NSArray yy_modelArrayWithClass:[Exchangerecord class] json:array2];
            weakself.convertDataArray = [NSMutableArray arrayWithArray:modelArray2];
            
            _favoriteId =[NSString stringWithFormat:@"%ld", _leastGoodsModel.favoriteId];
            
            if (_leastGoodsModel.favoriteStatus == 1) {
                _collectionButton.selected = YES;
                
            }else{
                
                _collectionButton.selected = NO;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            
            //商品图片赋值
            [_convertImageView sd_setImageWithURL:[NSURL URLWithString:_leastGoodsModel.logo] placeholderImage:[UIImage imageNamed:BigbgImage]];
        });
        
    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
    }];
    
}

#pragma mark ---尺寸数据请求
-(void)requestMetureData{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"id"] =[User defalutManager].selectedGoodsID;
    
    [self.httpManager POST:integralGoodsSpecUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
                //price是积分
                weakself.stockArray = [NSMutableArray arrayWithArray:josnArray];
            }
            
        }else{
            
            [self showStaus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self showStaus:@"网络错误"];
        
    }];
    
}


#pragma mark ---收藏商品
-(void)collectGoods:(UIButton *)btn{
    
    if (btn.selected == NO) {
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"integralGoodsId"] =[NSString stringWithFormat:@"%ld", _leastGoodsModel.id];
        
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
-(void)returnAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//跳转到详情
-(void)morePictureAndContentVC{
    
    _contentScrollView.contentOffset = CGPointMake(ScreenW, 0);
    _segement.selectedSegmentIndex = 1;
}

//更多兑换记录
-(void)jumpMoreRecordVC{
    
    if (self.convertDataArray.count > 0) {
        
        MoreRecordController * moreRecordVC = [[MoreRecordController alloc] init];
        [self.navigationController pushViewController:moreRecordVC animated:YES];
    }else{
        
        [self showStaus:@"没有更多兑换记录了"];
    }
 
}
#pragma mark ---界面布局
-(void)creatUI{
    
    _botomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH - 50-self.TabbarHeight, ScreenW, 50)];
    _botomView.backgroundColor = [UIColor whiteColor];
    //创建底部视图购物车
    NSInteger shopWalletW = 90;
    
    UIView * shopBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shopWalletW, 50)];
    UIButton * shopWallet = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,shopWalletW, 50)];
    [shopBgView addSubview:shopWallet];
    _shopCartNumberLbel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, shopWalletW/4.0f, 20)];
    _shopCartNumberLbel.font = [UIFont systemFontOfSize:13];
    
    _shopCartNumberLbel.text = [NSString stringWithFormat:@"%ld",[User defalutManager].shopcart];
    
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
    
    [convertBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
//    [convertBtn addTarget:self action:@selector(jumpWriteOrderVC) forControlEvents:UIControlEventTouchDown];
    [convertBtn addTarget:self action:@selector(createOrder:) forControlEvents:UIControlEventTouchDown];
    [_botomView addSubview:shopBgView];
    [_botomView addSubview:shopCarBtn];
    [_botomView addSubview:convertBtn];
    
    //轮播图
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH )];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.contentSize = CGSizeMake(ScreenW * 2, screenH );

    _contentScrollView.delegate = self;
    [self.view addSubview:_contentScrollView];
    //添加图片视图控制器
    ConvertPictureDetailViewController * pictureVC = [[ConvertPictureDetailViewController alloc] init];
    pictureVC.view.frame = CGRectMake(ScreenW, 0, ScreenW , screenH - 100);
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH -100-self.TabbarHeight-self.StatusBarHeight) style:UITableViewStyleGrouped];
    
    //设置头视图
    _convertImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW)];//230 * ScreenScale
    [_convertImageView setContentMode:UIViewContentModeScaleToFill];

    _convertImageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    
    _convertImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _convertImageView.clipsToBounds = YES;


    _tableView.tableHeaderView = _convertImageView;
    _tableView.sectionFooterHeight =4;
    _tableView.sectionHeaderHeight =4;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CovertDetailTableViewCell" bundle:nil] forCellReuseIdentifier:convertDindertifer];
    [_tableView registerNib:[UINib nibWithNibName:@"CovertRecordTableViewCell" bundle:nil] forCellReuseIdentifier:covertRecordInderfer];
    
    [_tableView registerNib:[UINib nibWithNibName:@"SelectGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:selectGoodsIndertifer];
    [_tableView registerNib:[UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil] forCellReuseIdentifier:covertHeadIndertifer];

    [_contentScrollView addSubview:_tableView];
    [_contentScrollView addSubview:pictureVC.view];
    [self.view addSubview:_botomView];
    
}
-(void)jump:(UISegmentedControl *)segement{
    
    if (segement.selectedSegmentIndex == 0) {
        
        _contentScrollView.contentOffset = CGPointMake(0, 0);
        
    }else{
        _contentScrollView.contentOffset = CGPointMake(ScreenW, 0);

    }
    
}
#pragma mark --- 跳转到购物车
-(void)jumpShopCarVC{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        HDshopCarBaseController * shopCar = [[HDshopCarBaseController alloc] init];
        //购物车类型
        shopCar.type = 1;
        [self.navigationController pushViewController:shopCar animated:YES];
        
    }else{
        
        LandingViewController * landVC =[[LandingViewController alloc] init
                                         ];
        [self.navigationController pushViewController:landVC animated:YES];
    }

}

#pragma mark --- 更多兑换商品
-(void)jumpMoreGoodsVC{
    
    MoreGoodsViewController * moreGoodsVC = [[MoreGoodsViewController alloc] init];
    moreGoodsVC.ig_goodsClassId = _leastGoodsModel.integralGoodsClassId;
    
    [self.navigationController pushViewController:moreGoodsVC animated:YES];
}

#pragma mark ---添加购物车（有无规格）
-(void)addShopCar:(UIButton *)sender{
    //加入购物车
    _isAddOrBuy = 2;
    //显示规格，有就显示，没有就不显示
    if (self.meatureArray.count) {
        
        [self initChoseView];
        
        [self show];
    }else{
        //立即跳转
        [self addShopCart];
    }
    
}

#pragma mark ---立即购买（有无规格）
- (void)createOrder:(UIButton *)sender{
    _isAddOrBuy = 1;
    
    //显示规格，有就显示，没有就不显示
    if (self.meatureArray.count) {
        
        [self initChoseView];
        
        [self show];
    }else{
        //立即跳转
        [self buyNow];
    }
}

#pragma mark ---添加到购物车（无规格）
- (void)addShopCart{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        param[@"integralId"] =[NSString stringWithFormat:@"%ld",_leastGoodsModel.id];
        param[@"count"] = [NSString stringWithFormat:@"%ld",_goodsCount];
        param[@"vendor"] = [NSString stringWithFormat:@"%@",_leastGoodsModel.vendor];
        
        [weakself POST:addGoodsUrl parameters:param success:^(id responseObject) {
            
            int i = [responseObject[@"isSucc"] intValue];
            
            if (i ==1) {
                
                [User defalutManager].shopcart = [User defalutManager].shopcart + _goodsCount ;
                //改变购物车数量
                
                _shopCartNumberLbel.text =[NSString stringWithFormat:@"%ld", [User defalutManager].shopcart];
                
                [self showStaus:@"加入购物车成功"];
                
            }else{
                
                [self showStaus:responseObject[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        LandingViewController *landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
}

#pragma mark ---添加到购物车（有规格）
- (void)addStopCartWithGsp:(NSString *)gspString{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        param[@"integralId"] =[NSString stringWithFormat:@"%ld",_leastGoodsModel.id];
        param[@"count"] = [NSString stringWithFormat:@"%ld",_goodsCount];
        param[@"vendor"] = [NSString stringWithFormat:@"%@",_leastGoodsModel.vendor];
        param[@"gsp"] = gspString;
        [weakself POST:addGoodsUrl parameters:param success:^(id responseObject) {
            
            int i = [responseObject[@"isSucc"] intValue];
            
            if (i ==1) {
                
                [User defalutManager].shopcart = [User defalutManager].shopcart + _goodsCount ;
                //改变购物车数量
                
                _shopCartNumberLbel.text =[NSString stringWithFormat:@"%ld", [User defalutManager].shopcart];
                
                [self showStaus:@"加入购物车成功"];
                
            }else{
                
                [self showStaus:responseObject[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        LandingViewController *landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
}

#pragma mark ---立即兑换（无规格）
- (void)buyNow{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        param[@"goodsId"] =[NSString stringWithFormat:@"%ld",_leastGoodsModel.id];
        param[@"count"] = [NSString stringWithFormat:@"%ld",_goodsCount];
        param[@"vendor"] = [NSString stringWithFormat:@"%@",_leastGoodsModel.vendor];
        [weakself POST:buyNowUrl parameters:param success:^(id responseObject) {
            
            int i = [responseObject[@"isSucc"] intValue];
            
            if (i ==1) {
                
                NSInteger cid = [responseObject[@"result"][@"cartId"] integerValue];
                [self jumpWriteOrderVC:cid];
                
            }else{
                
                [self showStaus:responseObject[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        LandingViewController *landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
}

#pragma mark ---立即兑换（有规格）
- (void)buyNowWithGspString:(NSString *)gspString{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        param[@"goodsId"] =[NSString stringWithFormat:@"%ld",_leastGoodsModel.id];
        param[@"count"] = [NSString stringWithFormat:@"%ld",_goodsCount];
        param[@"vendor"] = [NSString stringWithFormat:@"%@",_leastGoodsModel.vendor];
        param[@"gsp"] = gspString;
        [weakself POST:buyNowUrl parameters:param success:^(id responseObject) {
            
            int i = [responseObject[@"isSucc"] intValue];
            
            if (i ==1) {
                
                NSInteger cid = [responseObject[@"result"][@"cartId"] integerValue];
                [self jumpWriteOrderVC:cid];
                
            }else{
                
                [self showStaus:responseObject[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        LandingViewController *landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
}

#pragma mark ---创建订单
-(void)jumpWriteOrderVC:(NSInteger)cartId{
    
    WriteOrderViewController * writeOrderVC =[[WriteOrderViewController alloc] init];
    //购物车ID
    writeOrderVC.cartId = cartId;
    if (_stockArray) {
        for (NSDictionary *dic in _stockArray){
            if ([_choseView.contentString isEqualToString:dic[@"id"]]) {
                //价钱
                writeOrderVC.totalPrice = [dic[@"cash"] doubleValue] *_goodsCount;
                //积分
                writeOrderVC.totalIntegral = [dic[@"price"] doubleValue] * _goodsCount;
            }
        }
    } else {
        //价钱
        writeOrderVC.totalPrice = _leastGoodsModel.cash *_goodsCount;
        //积分
        writeOrderVC.totalIntegral = _leastGoodsModel.ig_goods_integral * _goodsCount;
    }
    
    //商品数量
    _leastGoodsModel.count = _goodsCount;
    
    writeOrderVC.count = _goodsCount;
    
    writeOrderVC.shopCarNumber = _goodsCount;
    //立即兑换
    writeOrderVC.type = 1;
    
    writeOrderVC.vendor = _leastGoodsModel.vendor;
    
    [writeOrderVC.ImageArray addObject:_leastGoodsModel];
    
    [writeOrderVC.goodIdaArray addObject:[NSString stringWithFormat:@"%ld",_leastGoodsModel.id]];
    
    [self.navigationController pushViewController:writeOrderVC animated:YES];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == 0) {
        _segement.selectedSegmentIndex = 0;
        
    }else if (scrollView.contentOffset.x == ScreenW){
        _segement.selectedSegmentIndex = 1;

    }
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
    
    [_choseView.img sd_setImageWithURL:[NSURL URLWithString:_leastGoodsModel.logo] placeholderImage:[UIImage imageNamed:BigbgImage]];
    
    //点击黑色透明视图choseView会消失
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_choseView.alphaiView addGestureRecognizer:tap];
    
}

#pragma mark  ----选择商品尺寸

- (void)sure{
    NSString * priceValue = _choseView.lb_price.text;
    
    if (priceValue.length ) {
        
        NSMutableString * mstring = [NSMutableString stringWithString:priceValue];
        [mstring deleteCharactersInRange:NSMakeRange(0, 1)];
        
        priceValue = [NSMutableString stringWithString:mstring];
    }
    
    
    if ( _choseView.stock > 0) {//[priceValue floatValue] > 0 &&
        
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
            //立即购买
            [self buyNowWithGspString:mmmstring];
        }else{
            //加入购物车
            [self addStopCartWithGsp:mmmstring];
        }
        
        
    }else{
        
        // 设置显示文本信息
        [self showStaus:@"请选择正确的规格"];
        
    }
}

#pragma mark ---选择规格

-(void)show
{
    
    center = _contentScrollView.center;
    center.y -= 64;
    
    _tableView.frame = CGRectMake(0, 0, ScreenW, screenH);
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration: 0.35 animations: ^{
        
        _contentScrollView.center = center;
        _contentScrollView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
        
        [_contentScrollView bringSubviewToFront:_choseView];
        _choseView.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height);
        
    } completion: nil];
    
    
}

-(void)dismiss
{
    center.y += 64;
    
    _tableView.frame = CGRectMake(0, 0, ScreenW, screenH - 100);
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration: 0.35 animations: ^{
        
        _choseView.frame =CGRectMake(0, self.view.frame.size.height + 200, self.view.frame.size.width, self.view.frame.size.height);
        _contentScrollView.center = center;
        _contentScrollView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        
    } completion: nil];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    }
   else if (section == 1) {
        return 1;
    }else if (section == 2){
        
        return self.convertDataArray.count;
        
    } else if (section == 3){
        
        return self.moreGoodsArray.count;
        
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==2) {
        
        UIView * sectionFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 43)];
        sectionFootView.backgroundColor = [UIColor colorWithHexString:BackColor];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.textAlignment = 1;
        [btn setTitle:@"更多兑换记录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
        [sectionFootView addSubview:btn];
        [btn addTarget:self action:@selector(jumpMoreRecordVC) forControlEvents:UIControlEventTouchDown];
        return sectionFootView;
    } else if (section == 3){
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.textAlignment = 1;
        [btn setTitle:@"查看更多兑换商品" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(jumpMoreGoodsVC) forControlEvents:UIControlEventTouchDown];
        return btn;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        //创建文字图片
      UILabel *  label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        label.text = @"兑换记录";
        //分割线
        [label setFont:[UIFont systemFontOfSize:14]];
        UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenW, 1)];
        seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
        
        [bgView addSubview:seperateView];
        [bgView addSubview:label];
        bgView.backgroundColor = [UIColor whiteColor];
     
        return bgView;
    } if (section == 3) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        //创建文字图片
        UILabel *  label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        label.text = @"更多兑换商品";
        //分割线
        [label setFont:[UIFont systemFontOfSize:14]];
        UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenW, 1)];
        seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
        
        [bgView addSubview:seperateView];
        [bgView addSubview:label];
        bgView.backgroundColor = [UIColor whiteColor];
        
        return bgView;

    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==1) {
        return 8;
    }
     else if (section ==2) {
        return 43;
         
    } else if (section == 3){
        return 35;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==2) {
        return 35;
    } else if (section ==3){
        return 35;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    else if (indexPath.section ==1){
        return 40;
    } else if (indexPath.section ==2){
        return 100;
    } else if (indexPath.section ==3){
        return 100;
    }
    return 0;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        
        HeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:covertHeadIndertifer forIndexPath:indexPath];
        cell.selectionStyle = NO;
        cell.goodsNameLabel.text = _leastGoodsModel.ig_goods_name;
        cell.goodsPriceLabel.text =[NSString stringWithFormat:@"已消费: %ld",_leastGoodsModel.ig_exchange_count];
        //商品库存
        cell.enoughNumberLabel.text =[NSString stringWithFormat:@"库存: %ld",_leastGoodsModel.ig_goods_count];
        //已消费
//        cell.saledNumberLabel.text =[NSString stringWithFormat:@"%ld积分",_leastGoodsModel.ig_goods_integral];
        [cell.saledNumberLabel labelWithIntegral:_leastGoodsModel.ig_goods_integral money:_leastGoodsModel.cash];
        
        return cell;
    }
    else if (indexPath.section ==1){
        
        SelectGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:selectGoodsIndertifer forIndexPath:indexPath];
        cell.selectionStyle = NO;
        cell.goodsCountView.NumberChangeBlock = ^(NSInteger count){
            
            _goodsCount = count;

        };

        return cell;
    }else if (indexPath.section ==2){
        
        CovertRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:covertRecordInderfer forIndexPath:indexPath];
        Exchangerecord * model = self.convertDataArray[indexPath.row];
        cell.recordModel = model;
        return cell;
        
    } else if (indexPath.section ==3){
        
        CovertDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:convertDindertifer forIndexPath:indexPath];
        cell.starsView.hidden = YES;
        
        Recommendgoods * model = self.moreGoodsArray[indexPath.row];
        cell.goodsModel = model;
        return cell;
    }
    return 0;
}
//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选测尺寸
    if (indexPath.section == 1) {
        
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"selectMeature" object:nil];

    }//兑换列表
    else if (indexPath.section ==2){
        
    }else if (indexPath.section ==3){
        //更多兑换商品
        Exchangerecord * model = self.moreGoodsArray[indexPath.row];
        [User defalutManager].selectedGoodsID =[NSString stringWithFormat:@"%ld",model.id];
        
        CovertGoodsViewController * covertVC =[[CovertGoodsViewController alloc] init];
        [self.navigationController pushViewController:covertVC animated:YES];
    //    [self requestGoodsData];
    }
}

-(void)shareIntegral{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        
        [UMSocialQQHandler setQQWithAppId:@"1105491978" appKey:@"4vcul0EYJddeh32a" url:[NSString stringWithFormat:@"%@?integralGoodsId=%@",integralByIdhtmUrl,[User defalutManager].selectedGoodsID]];
        
        [UMSocialWechatHandler setWXAppId:__WXappID appSecret:__WXappSecret url:[NSString stringWithFormat:@"%@?integralGoodsId=%@",integralByIdhtmUrl,[User defalutManager].selectedGoodsID]];
        
        //分享类型为店铺
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title =_leastGoodsModel.ig_goods_name;
        [UMSocialData defaultData].extConfig.qqData.title = _leastGoodsModel.ig_goods_name;
        //分享文字
        NSString * shareText = [NSString stringWithFormat:@"%@",_leastGoodsModel.ig_goods_name];
        
        // 显示分享界面
        
        //分享图片
        UIImage * shareImage = _convertImageView.image;
        
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMSocialAppKey                                      shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone, nil] delegate:nil];
    }else{
        
        [self goLanding];
        
    }
    
    

}
#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

//
//  OnlineOrderController.m
//  XuXin
//
//  Created by xuxin on 17/3/9.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "OnlineOrderController.h"
#import "RecievePlaceTableViewCell.h"
#import "OnlineGoodsModel.h"
#import "HaiDuiTextView.h"
#import "RecivePlaceTableViewController.h"
#import "receivePlaceModel.h"
#import "GroupGoodsMOdel.h"
#import "MyOrderTableViewController.h"
#import "SBMyOrderTableviewController.h"
#import "HDShopCarModel.h"
#import "GoodsLIstViewController.h"
#import "ChooseCouponViewController.h"
NSString * const onLineReceiveIndertifer = @"RecievePlaceTableViewCell";
@interface OnlineOrderController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic ,assign)CGFloat sendFee;
@property(nonatomic ,strong)receivePlaceModel * placeModel;

@property (nonatomic ,copy)NSString * orderId;

@property (nonatomic ,copy)NSString * orderSn;

@property (nonatomic ,assign)NSInteger sendType;

@property (nonatomic, strong) ChooseCouponViewController *couponVC;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) NSString *couponId;

@end

@implementation OnlineOrderController{
    //是否设置默认地址
    BOOL _isSetAdress;
    
    UIButton * _setAdressbtn;
    //快递费用
    UILabel * _totalLabel;
    //快递方式
    UILabel * _sendLabel;
    
    HaiDuiTextView * _textView;
    NSString *factPrice;
}
-(NSMutableArray * )ImageArray{
    if (!_ImageArray) {
        
        _ImageArray =[[NSMutableArray alloc] init];
    }
    return _ImageArray;
}
-(receivePlaceModel *)placeModel{
    
    if (!_placeModel) {
        
        _placeModel = [[receivePlaceModel alloc] init];
    }
    return _placeModel;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self creatTableView];
    
    [self createCouponView];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAdress:) name:@"refreshingData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAdress:) name:@"selectAdress" object:nil];
    factPrice = _amountMoney;
}
-(void)selectAdress:(NSNotification *)dic{
    
    receivePlaceModel * model = dic.userInfo[@"name"];
    self.placeModel = model;
    
    [_tableView reloadData];
    
    _isSetAdress = YES;
    
    //重新计算快递费
    [self requestSendFee];
    
}
#pragma mark ---默认地址请求
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    
    [self.httpManager POST:getDefaultAddressUrl parameters:nil  progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray * array = responseObject[@"result"];
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            
            if (array.count > 0 ) {
                
                _isSetAdress = YES;
                
                NSDictionary * dic = array[0];
                
                weakself.placeModel = [receivePlaceModel yy_modelWithDictionary:dic];
                
                //计算快递费
                [weakself requestSendFee];
                
            }else{
                
                _isSetAdress = NO;
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"线上商品"];
    
    [self addBackBarButtonItem];
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStyleGrouped];
    [_tableView registerNib:[UINib nibWithNibName:@"RecievePlaceTableViewCell" bundle:nil] forCellReuseIdentifier:onLineReceiveIndertifer];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH - 80, ScreenW, 120)];
    footView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    UIButton * uploadOrderBtn =[[UIButton alloc] initWithFrame:CGRectMake(10, 50, ScreenW - 20, 50)];
    uploadOrderBtn.backgroundColor =[UIColor colorWithHexString:MainColor];
    [uploadOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [uploadOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uploadOrderBtn.layer.cornerRadius = 25;
    [footView addSubview:uploadOrderBtn];
    
    [uploadOrderBtn addTarget:self action:@selector(uploadOrder) forControlEvents:UIControlEventTouchDown];
    
    _tableView.tableFooterView = footView;
}

- (void)createCouponView{
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor colorWithHexString:WordColor alpha:0.5];
    
    [self.view addSubview:_bgView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH/2, ScreenW, screenH/2)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    _couponVC = [[ChooseCouponViewController alloc] init];
    _couponVC.view.frame = CGRectMake(0, 0, ScreenW, screenH/2);
    __weak typeof(self)weakself= self;
    _couponVC.storevcartId = _storeCartId;
    _couponVC.orderId = _orderId;
    _couponVC.isCoupon = YES;
    _couponVC.orderType = [NSString stringWithFormat:@"0"];
    [_couponVC requestData];
    _couponVC.cancelBtnBlock = ^(BOOL flag) {
        [weakself hiddenOrShowCouponVC:YES];
    };
    _couponVC.couponBlock = ^(StoreCouponModel *couponModel) {
        if ([couponModel.price intValue] > 0) {
            _couponId = couponModel.id;
            
        }
        UILabel *valueLbl = [weakself.view viewWithTag:122];
        valueLbl.text = couponModel.name;
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
        self.tableView.scrollEnabled = NO;
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
    self.tableView.scrollEnabled = YES;
    _bgView.hidden = YES;
    self.contentView.hidden = YES;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        
        if (_isSetAdress == NO) {
            
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            _setAdressbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
            [_setAdressbtn setTitle:@"请选择收货地址以确保顺利到达" forState:UIControlStateNormal];
            
            _setAdressbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            _setAdressbtn.backgroundColor = [UIColor whiteColor];
            [_setAdressbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_setAdressbtn addTarget:self action:@selector(junmRecivePlaceVC) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:_setAdressbtn];
            return cell;
        } else{
            
            RecievePlaceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:onLineReceiveIndertifer forIndexPath:indexPath];
            
            cell.NameLabel.text = self.placeModel.trueName;
            cell.phoneNumberLabel.text = self.placeModel.mobile;
            cell.receivePlaceLbael.text = self.placeModel.area;
            return cell;
        }
    }else if (indexPath.section == 1){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 60, 10, 60, 20)];
        countLabel.textAlignment = 2;
        countLabel.center = CGPointMake(ScreenW - 50, 45);
        countLabel.textColor = [UIColor colorWithHexString:WordLightColor];
        
        countLabel.font = [UIFont systemFontOfSize:14];
        
        countLabel.text = [NSString stringWithFormat:@"共%ld件",self.ImageArray.count];
        
        [cell.contentView addSubview:countLabel];
        
        UIImageView * nextImageView =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 22, 10, 8, 8)];
        nextImageView.center = CGPointMake(ScreenW - 10, 45);
        [nextImageView setImage:[UIImage imageNamed:@"icon_address_right_arrow@2x"]];
        [cell.contentView addSubview:nextImageView];
        
        for (int i = 0; i < self.ImageArray.count; i++) {
            if (_orderType == 1) {
                
                HDShopCarModel * goodModel = self.ImageArray[i];
                
                CGFloat imageViewW = 70;
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (imageViewW +10) *i, 10 , imageViewW, imageViewW)];
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 4;
                [cell.contentView addSubview:imageView];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:goodModel.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
                if (i>= 2) {
                    
                    imageView.hidden = YES;
                }

            }else{
                GroupGoodsMOdel * goodModel = self.ImageArray[i];
                
                CGFloat imageViewW = 70;
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (imageViewW +10) *i, 10 , imageViewW, imageViewW)];
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 4;
                [cell.contentView addSubview:imageView];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:goodModel.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
                if (i>= 2) {
                    
                    imageView.hidden = YES;
                }

            }
        }
        //分割线
        UIView * sptString = [[UIView alloc] initWithFrame:CGRectMake(0, 89, ScreenW , 1)];
        sptString.backgroundColor = [UIColor colorWithHexString:BackColor];
        
        [cell.contentView addSubview:sptString];
        
        //消费金额
        UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 20)];
        priceLabel.text = @"消费金额:";
        priceLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:priceLabel];
        
        UILabel * moneyLabel =[[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 110, 100, 100, 20)];
        
        moneyLabel.textAlignment = 2;
        moneyLabel.font = [UIFont systemFontOfSize:15];
    
        moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[_amountMoney floatValue]];
        
        moneyLabel.textColor = [UIColor colorWithHexString:MainColor];
        [cell.contentView addSubview:moneyLabel];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        //店铺优惠
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        
        UILabel * couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        couponLabel.text = @"店铺优惠:";
        couponLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:couponLabel];
        
        UILabel * valueLabel =[[UILabel alloc] initWithFrame:CGRectMake(130, 10, ScreenW-160, 20)];
        
        valueLabel.textAlignment = 2;
        valueLabel.tag = 122;
        valueLabel.font = [UIFont systemFontOfSize:15];
        
        valueLabel.textColor = [UIColor colorWithHexString:MainColor];
        [cell.contentView addSubview:valueLabel];
        UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW-20, 15, 8, 10)];
        rightImgView.image = [UIImage imageNamed:@"icon_address_right_arrow"];
        [cell.contentView addSubview:rightImgView];
        return cell;
        
    } else if (indexPath.section == 3){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        UILabel * sendTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        sendTypeLabel.text = @"配送方式:";
        sendTypeLabel.font = [UIFont systemFontOfSize:15];
        
        _sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW -110, 10, 100, 20)];
        _sendLabel.font = [UIFont systemFontOfSize:15];
        _sendLabel.textAlignment = 2;
        
      
        sendTypeLabel.font = [UIFont systemFontOfSize:15];
        UILabel * sendFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 100, 20)];
        sendFeeLabel.font = [UIFont systemFontOfSize:15];
        
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 110, 40, 100, 20)];
        _totalLabel.textAlignment   = 2;
        _totalLabel.font = [UIFont systemFontOfSize:15];
        _totalLabel.textColor = [UIColor colorWithHexString:MainColor];
    
        sendFeeLabel.text = @"邮       费:";
        
        [cell.contentView addSubview:sendTypeLabel];
        [cell.contentView addSubview:sendFeeLabel];
        [cell.contentView addSubview:_totalLabel];
        [cell.contentView addSubview:_sendLabel];
        
        
        [_totalLabel setText:[NSString stringWithFormat:@"%.1f元",_sendFee]];
        if (_isSetAdress) {
            if (_sendFee == 0) {
                
                _sendLabel.text = @"买家包邮";
                
            }else{
                _sendLabel.text = @"快递";
                
            }
        } else {
            _sendLabel.text = @"快递";
            _totalLabel.text = @"--";
        }
        
        return cell;
    }else{
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];

        _textView =[[HaiDuiTextView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
        _textView.delegate = self;
        
        [_textView setMyPlaceholder:@"备注信息"];
        
        [cell.contentView addSubview:_textView];
        
        return cell;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1){
        
        return 130;
        
    }else if (indexPath.section == 2){
        
        return 40;
        
    }else if (indexPath.section == 3){
        
        return 70;
        
    }else{
        
        return 100;
    }
}
-(void)junmRecivePlaceVC{
    
    RecivePlaceTableViewController   * edictPlaceVC = [[RecivePlaceTableViewController alloc] init];
    
    [self.navigationController pushViewController:edictPlaceVC animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        [self junmRecivePlaceVC];
    }else if (indexPath.section == 1){
        
        [self jumpGoodsListVC];
    } else if (indexPath.section == 2) {
        
        [self hiddenOrShowCouponVC:NO];
    }
}
#pragma mark ---商品列表
-(void)jumpGoodsListVC{
    
    GoodsLIstViewController * goodListVC = [[GoodsLIstViewController alloc] init];
    
    goodListVC.goodsCount  = _goodsCount;
   
    //从购物车进来
    if (_orderType == 1) {
        
        goodListVC.goodsType = 2;
        goodListVC.shopCarType = 1;
        
    }else{
        
        //线上商品
        goodListVC.goodsType = 1;
        goodListVC.goodsPirce = [_amountMoney floatValue];
        
    }
    for ( GroupGoodsMOdel * goodModel in self.ImageArray) {
        
        [goodListVC.goodsModelArray addObject:goodModel];
    }
    
    [self.navigationController pushViewController:goodListVC animated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  5;
}
#pragma mark ---计算快递费

-(void)requestSendFee{
    
    NSMutableString * goodsID = [NSMutableString string];
    
    for (int i = 0; i< self.ImageArray.count; i++) {
        
        if (_orderType == 1) {
            
            HDShopCarModel * model = self.ImageArray[i];
            
            [goodsID appendString:[NSString stringWithFormat:@"%@,",model.goodsCartId]];
            
        }else{
            
           GroupGoodsMOdel * model  = self.ImageArray[i];
        
        [goodsID appendString:[NSString stringWithFormat:@"%@,",model.goods_id]];
        }
        
    }
    if (goodsID.length) {
        
        [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
    }
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    //购物车进来
  
    param[@"goodsCartIds"] = _goodsCartId;
    
    param[@"areaId"] =[NSString stringWithFormat:@"%ld",self.placeModel.id];
 
    [self POST:freightcalculationUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            //获取快递费
            NSString * sendF = responseObject[@"result"][@"money"];
            
            weakself.sendFee = [sendF floatValue];
            
        }
        
        
      dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}
#pragma mark ---提交订单
-(void)uploadOrder{
    
    
    if (_orderId != nil) {
        
        CGFloat totalMoney = 0;
        
        if (_orderType == 1) {
            
            
            for (HDShopCarModel * model in self.ImageArray) {
                
            totalMoney = totalMoney + model.price* model.count;
                
            }
            
            totalMoney = totalMoney + _sendFee;

            
        }else{
            
            totalMoney = [_amountMoney floatValue] + _sendFee;
            
        }
    
        UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
        myOrderVC.orderPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
        myOrderVC.factPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
                //订单类型,线上订单
        myOrderVC.orderType = 1;
        
        myOrderVC.orderId = self.orderId;
                //订单号
        myOrderVC.orderNumber =self.orderSn;
        
        myOrderVC.sendFee = _sendFee;
        
        myOrderVC.type = 0;
        
        if (_couponId != nil) {
            myOrderVC.isUseCoupon = YES;
        }

        [self.navigationController pushViewController:myOrderVC animated:YES];

    
    }else{
        
        [self uploadOrderData];
    }

}
-(void)uploadOrderData{
    
    [SVProgressHUD showWithStatus:@"正在提交订单"];
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    
    NSMutableString * goodsID = [NSMutableString string];
    
    for (int i = 0; i< self.ImageArray.count; i++) {
        if (_orderType == 1) {
            
            HDShopCarModel * model = self.ImageArray[i];
            
            [goodsID appendString:[NSString stringWithFormat:@"%@,",model.goodsCartId]];
            
        }else{
            
            GroupGoodsMOdel * model  = weakself.ImageArray[i];
        
            [goodsID appendString:[NSString stringWithFormat:@"%@,",model.goods_id]];
            
        }
    }
    if (goodsID.length) {
        
        [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
        
    }
    
    param[@"goodsCartID"] = _goodsCartId;
    
    param[@"storeCartId"] = _storeCartId;
    
    param[@"addrid"] =[NSString stringWithFormat:@"%ld", self.placeModel.id];
    
    param[@"remarks"] = _textView.text;
//    NSString *urlString ;
    if (_couponId != nil) {
        param[@"couponid"] = _couponId;
//        urlString = appSaveOnlineOrderUseCouponUrl;
    } else {
//        urlString = app_save_onLine_orderUrl;
    }
    
    [self POST:appSaveOnlineOrderUseCouponUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str integerValue] == 1) {
            
            CGFloat totalMoney = 0;
            weakself.orderId = responseObject[@"result"][@"orderId"];
            //订单号
            weakself.orderSn = responseObject[@"result"][@"order"];
            
            if (_orderType == 1) {
                
//                for (HDShopCarModel * model in self.ImageArray) {
//
//                    totalMoney = totalMoney + model.price* model.count;
//
//                    [User defalutManager].lineShopCart = [User defalutManager].lineShopCart - model.count ;
//
//                }
//            //购物车进来
//                if (weakself.shopcarType == 1) {
//
//                    totalMoney = totalMoney + _sendFee;
//
//                }
                
                totalMoney = [responseObject[@"result"][@"price"] floatValue];
            }else if (_couponId != nil){
                totalMoney = [responseObject[@"result"][@"price"] floatValue];
            }else{
                
                totalMoney = [_amountMoney floatValue] + _sendFee;

            }
//            //加上快递费，总的费用
//            totalMoney = totalMoney + _sendFee;
            
//        if (totalMoney >= 150 && [User defalutManager].redPacket > 0 ) {
            
            UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
            myOrderVC.orderPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
            myOrderVC.factPrice = factPrice;
            //订单类型,线上订单
            myOrderVC.orderType = 1;
            if (_couponId == nil ) {
                myOrderVC.isUseCoupon = NO;
            } else {
                myOrderVC.isUseCoupon = YES;
            }
            
            myOrderVC.type = 0;
            
            myOrderVC.orderId = weakself.orderId;
            //订单号
            myOrderVC.orderNumber =weakself.orderSn;;
            
            myOrderVC.sendFee = _sendFee;

            [weakself.navigationController pushViewController:myOrderVC animated:YES];
            

        }
        
    } failure:^(NSError *error) {
        
        
    }];

}
#pragma mark --uitextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
     [UIView animateWithDuration:0.5 animations:^{
    
    self.tableView.contentOffset = CGPointMake(0, 220);

}];
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

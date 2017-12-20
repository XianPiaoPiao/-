//
//  MyOrderTableViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyOrderTableViewController.h"
#import "ReadPayViewController.h"
#import "FaceToFaceOrderModel.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "MyOrderBaseViewController.h"
//导入微信支付文件
#import "WXApi.h"
#import "payRequsestHandler.h"
// 微信支付头文件
//红包选择
#import "ChooseCouponViewController.h"

@interface MyOrderTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *redWalletBtn;
@property (weak, nonatomic) IBOutlet UIButton *supendPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UILabel *supendLabel;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *redpacketDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDescLabel;
@property (nonatomic ,copy)NSString * outTrade_no;
@property (nonatomic ,copy)NSString * orderBody;
@property(nonatomic,copy)NSString * orderSubjiect;
@property(nonatomic,copy)NSString * total_fee;
@property(nonatomic,copy)NSString * notify_url;
@property (nonatomic ,copy)NSString * noncestr;
@property (nonatomic ,copy)NSString * sign;
@property (nonatomic, copy)NSString *redPacketId;
@property (nonatomic, copy) NSString *couponId;
//微信
@property (nonatomic ,copy)NSString * prepareId;

@property (weak, nonatomic) IBOutlet UILabel *orderNuberLabel;

@property (nonatomic ,strong)AFHTTPSessionManager * httpManager;

@property (nonatomic ,assign)NSInteger lastBtn;

@property (nonatomic ,copy)NSString * useRedWalletPrice;

@property (nonatomic, strong) ChooseCouponViewController *couponVC;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation MyOrderTableViewController{
    
    BOOL isUseRedwallet;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;


   // self.supendLabel.text = [NSString stringWithFormat:@"预充值: ￥%ld",[User defalutManager].preDeposit];
   // self.balanceLabel.text = [NSString stringWithFormat:@"余额: ￥%ld",[User defalutManager].balance];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    //红包
    isUseRedwallet = NO;
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",_orderPrice];
    _useRedWalletPrice = _orderPrice;
    self.orderNuberLabel.text =[NSString stringWithFormat:@"订单号:%@", _orderNumber];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(junmpOrderVC) name:@"AlipaySucess" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(junmpOrderVC) name:@"weixinSucess" object:nil];
 
    [self creatNavgationBar];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
   
    [self settingUI];
    
    [self createCouponView];
    
//    if (_type != 3) {
//        if (_type == 1 || [User defalutManager].redPacket > 0) {
//
//            [self createCouponView];
//
//        }
//    } else {
//        if ([User defalutManager].redPacket > 0) {
//
//            [self createCouponView];
//
//        }
//
//
//
//    }
    if (_couponmoeny > 0) {
        self.couponDescLabel.text = [NSString stringWithFormat:@"抵用%ld元",_couponmoeny];
    }
    CGFloat orderValue =  [self.orderPrice floatValue];
    self.orderPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", orderValue];
}

- (void)createCouponView{
    
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor colorWithHexString:WordColor alpha:0.5];
    
    [self.view addSubview:_bgView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH/2 - 64, ScreenW, screenH/2)];

    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    _couponVC = [[ChooseCouponViewController alloc] init];
    __weak typeof(self)weakself= self;
    //面对面用orderID查询优惠券
    _couponVC.storevcartId = _orderId;
    _couponVC.orderId = _orderId;
    _couponVC.orderType = [NSString stringWithFormat:@"%ld",(long)_type];
    
    _couponVC.cancelBtnBlock = ^(BOOL flag) {
        [weakself hiddenOrShowCouponVC:YES];
    };
    _couponVC.couponBlock = ^(StoreCouponModel *couponModel) {
        [weakself hiddenOrShowCouponVC:YES];
        if ([couponModel.price intValue] > 0) {
            
            _couponId = couponModel.id;
            
            CGFloat orderValue =  [weakself.orderPrice floatValue];
            CGFloat couponValue = [couponModel.price floatValue];
            
            if (weakself.redPacketId != nil) {
                weakself.orderPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", orderValue - 5 - couponValue];
                weakself.useRedWalletPrice = [NSString stringWithFormat:@"%.2f", orderValue - 5 - couponValue];
            } else {
                weakself.orderPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", orderValue - couponValue];
                weakself.useRedWalletPrice = [NSString stringWithFormat:@"%.2f", orderValue - couponValue];
            }
            
            
            weakself.couponDescLabel.text = couponModel.name;
        }else {
            //未使用优惠券显示
            CGFloat orderValue =  [weakself.orderPrice floatValue];
            _couponId = nil;
            weakself.orderPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", orderValue];
            weakself.useRedWalletPrice = [NSString stringWithFormat:@"%.2f", orderValue];
            weakself.couponDescLabel.text = couponModel.name;
        }
        
    };
    _couponVC.redpacketBlock = ^(StoreCouponModel *couponModel) {
        [weakself hiddenOrShowCouponVC:YES];
        if ([couponModel.price intValue] > 0) {
            isUseRedwallet = YES;
            _redPacketId = couponModel.id;
            
            CGFloat orderValue =  [weakself.orderPrice floatValue];
            CGFloat redValue = [couponModel.price floatValue];
            //使用红包显示
            
            weakself.orderPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", orderValue - redValue];
            weakself.useRedWalletPrice = [NSString stringWithFormat:@"%.2f", orderValue - redValue];
            weakself.redpacketDescLabel.text = couponModel.name;
        }else {
            //未使用红包显示
            CGFloat orderValue =  [weakself.orderPrice floatValue];
            
            weakself.orderPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", orderValue];
            weakself.useRedWalletPrice = [NSString stringWithFormat:@"%.2f", orderValue];
            weakself.redpacketDescLabel.text = couponModel.name;
            isUseRedwallet = NO;
        }
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

//钱包
-(void)returnWalletList{
    
    UIViewController * viewCrl = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:viewCrl animated:YES];
}
//跳转到订单界面
-(void)junmpOrderVC{
    
    
    [User defalutManager].redPacket--;
    
    MyOrderBaseViewController * orderVC = [[MyOrderBaseViewController alloc] init];
    orderVC.ordrType = _orderType;

    [self.navigationController pushViewController:orderVC animated:YES];
}


-(void)settingUI{
    
    //确认支付
//    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//    UIButton * surePayBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, ScreenW - 20, 50)];
////    [self.view addSubview:surePayBtn];
////    [self.tableView addSubview:surePayBtn];
//    [view addSubview:surePayBtn];
//    [surePayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
//    surePayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [surePayBtn addTarget:self action:@selector(choosePayWay:) forControlEvents:UIControlEventTouchUpInside];
//    surePayBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
//    surePayBtn.layer.cornerRadius = 25;
//    self.tableView.tableFooterView = view;
}
#pragma mark  ---选择支付方式
-(void)choosePayWay:(UIButton *)btn{
    if (_type != 2 ) {
        if (!isUseRedwallet && _couponId == nil && !_isUseCoupon) {
            _type = 2;
        }
    }
    if (_type == 2) {
        if (self.weixinBtn.selected == YES) {
            
            [SVProgressHUD showWithStatus:@"正在打开微信"];
            
            if (_orderType == 1 || _orderType == 2) {
                
                [self requestWeixinDataIsOnline:YES];
            }else{
                
                [self requestWeixinDataIsOnline:NO];
                
            }
        } else if (self.zhifubaoBtn.selected == YES){
            [SVProgressHUD showWithStatus:@"正在打开支付宝"];
            
            if (_orderType == 1 || _orderType == 2) {
                
//                [self requestOnlineData];
                [self requestAlipayDataIsOnline:YES];
                
            }else{
                
                [self requestAlipayDataIsOnline:NO];
                
            }
        } else if (self.supendPayBtn.selected == YES){
            [self jumpNextVCWithBalanceOrSupend:NO];
            
        }else if (self.balanceBtn.selected == YES){
            [self jumpNextVCWithBalanceOrSupend:YES];
        }
    } else {
        //有优惠券或者红包的
        //支付方式（1预充值、2余额、3支付宝、4微信）
        if (self.weixinBtn.selected == YES) {
            [SVProgressHUD showWithStatus:@"正在打开微信"];
            [self requestDataByUsePacketPay:4];
            
        } else if (self.zhifubaoBtn.selected == YES){
            [SVProgressHUD showWithStatus:@"正在打开支付宝"];
            [self requestDataByUsePacketPay:3];
            
        } else if (self.supendPayBtn.selected == YES){
            [self jumpNextVCWithBalanceOrSupend:NO];
            
        }else if (self.balanceBtn.selected == YES){
            [self jumpNextVCWithBalanceOrSupend:YES];
        }
    }
    
}
#pragma mark ---选择付款方式

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 108;
    }
    if (indexPath.row == 1 || indexPath.row == 4) {
        return 8;
    }
    if (_type != 3) {
        if (indexPath.row == 2 && ([User defalutManager].redPacket <= 0 || [_orderPrice floatValue] < 150)){
            return 0;
            
        }
        if (indexPath.row == 3 && (_type == 0 || _type == 2) && _couponmoeny <= 0) {
            return 0;
        }
    } else {
        
        if (indexPath.row == 2 && _redpacketmoeny <= 0) {
            return 0;
        }
        if (indexPath.row == 3 && _couponmoeny <= 0) {
            return 0;
        }
    }

    return 58;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screenH, ScreenW, 80)];
    UIButton * surePayBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, ScreenW - 20, 50)];
    //    [self.view addSubview:surePayBtn];
    //    [self.tableView addSubview:surePayBtn];
    [view addSubview:surePayBtn];
    [surePayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    surePayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [surePayBtn addTarget:self action:@selector(choosePayWay:) forControlEvents:UIControlEventTouchUpInside];
    surePayBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    surePayBtn.layer.cornerRadius = 25;
//    self.tableView.tableFooterView = view;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.supendPayBtn.tag = buttonTag + 1;
    self.balanceBtn.tag = buttonTag + 2;
    self.weixinBtn.tag = buttonTag + 3;
    self.zhifubaoBtn.tag = buttonTag + 4;
    
    if (indexPath.row == 5|| indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8) {
        if (_lastBtn != 0) {
            
            UIButton * lastButton = [self.view viewWithTag:_lastBtn ];
            
            lastButton.selected = NO;
        }
    }
  
    //预充值支付
    if (indexPath.row == 5) {
        _lastBtn = buttonTag + 1;
        self.supendPayBtn.selected = YES;
   //       [[NSNotificationCenter defaultCenter] postNotificationName:@"supendCharge" object:nil userInfo:nil];
   //余额支付
    } else if (indexPath.row == 6){
        
        _lastBtn = buttonTag + 2;
        self.balanceBtn.selected = YES;
 
    } else if (indexPath.row == 7){
        
        _lastBtn = buttonTag + 3;
        self.weixinBtn.selected = YES;
        

    } else if (indexPath.row == 8){
        
        _lastBtn = buttonTag + 4;
        self.zhifubaoBtn.selected = YES;

    }
 
    if (indexPath.row == 2) {
        if (_type != 3) {
            _couponVC.isCoupon = NO;
            [_couponVC requestDataRedPacket];
            [self hiddenOrShowCouponVC:NO];
        }
    }
    if (indexPath.row == 3) {
        if (_type != 3 && _couponmoeny <= 0) {
            _couponVC.isCoupon = YES;
            [_couponVC requestData];
            [self hiddenOrShowCouponVC:NO];
        }
    }
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:BackColor];
    UIButton * barButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    //让按钮所有内容水平向左
    //  barButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    barButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置按钮的标题
    [barButton setTitle:@"返回" forState:UIControlStateNormal];
    [barButton setImagePositionWithType:SSImagePositionTypeLeft spacing:8];
    
    //设置按钮背景
    [barButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    barButton.tintColor = [UIColor blackColor];
    //设置target -action
    [barButton addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchDown];
    //创建uibarButtonItem
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    

    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 64)];
    [label setTextColor:[UIColor blackColor]];
    [label setText:@"支付订单"];
    [label setFont:[UIFont systemFontOfSize:14]];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

#pragma mark ---使用了红包或者优惠券的支付---
- (void)requestDataByUsePacketPay:(NSInteger)type{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    NSString *urlString;
    
    
    //面对面
    if(_type == 1){
        /*
         1    couponid    优惠券ID    是    [string]
         2    redpacketid    红包ID    是    [string]
         3    payType    支付方式；1为预充值，2为余额，3为支付宝，4为微信    是    [string]
         4    orderId    订单ID    是    [string]
         5    payPassword    余额预、充值支付密码
         */
        if (_couponId) {
            param[@"couponid"] = _couponId;
        }
        if (_redPacketId) {
            param[@"redpacketid"] = _redPacketId;
        }
        param[@"orderId"] = self.orderId;
        param[@"payType"] = @(type);
        urlString = payFace2FaceOrderUseCouponUrl;
    }
    if (_type == 0) {
        /*
         1    pwd    支付密码（微信，支付宝，不必传此参数）    是    [string]
         2    orderId    订单ID    是    [int]
         3    type    支付方式（1预充值、2余额、3支付宝、4微信）    是    [int]        查看
         4    packetid    红包ID
         */
        if (_redPacketId) {
            param[@"packetid"] = _redPacketId;
        }
        param[@"orderId"] = self.orderId;
        param[@"type"] = @(type);
        urlString = lineoutlinePayOrderUsePracktUrl;
    }
    
    [self.httpManager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger  i = [responseObject[@"isSucc"] integerValue];
        
        if (i ==1) {
            if (type == 4) {
                weakself.prepareId = responseObject[@"result"][@"prepayid"];
                
                [self sendPay_demo];
                //
                [SVProgressHUD dismiss];
            }
            if (type == 3) {
                self.outTrade_no = responseObject[@"result"][@"out_trade_no"];
                self.orderBody = responseObject[@"result"][@"body"];
                self.orderSubjiect = responseObject[@"result"][@"subject"];
                self.total_fee =  responseObject[@"result"][@"total_fee"];
                
                self.notify_url = responseObject[@"result"][@"notify_url"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    [self doAlipayPay];
                    
                });
            }
            
            
        } else{
            //
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismissWithDelay:2];
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        
        [SVProgressHUD dismissWithDelay:2];
        
    }];
}

#pragma mark --- 余额支付/预存款---
- (void)jumpNextVCWithBalanceOrSupend:(BOOL)isBalance{
    if (_isUseCoupon) {
        isUseRedwallet = YES;
    }
    if (isBalance == YES) {
        //余额
        ReadPayViewController * readPayVC = [[ReadPayViewController alloc] init];
        readPayVC.isUseRedWallet = isUseRedwallet;
        readPayVC.redpacketId = _redPacketId;
        readPayVC.couponId = _couponId;
        readPayVC.orderId = self.orderId;
        readPayVC.order_sn = [NSString stringWithFormat:@"订单号:%@", _orderNumber];
        readPayVC.price =  _useRedWalletPrice;
        //支付类型
        readPayVC.payType = 2;
        
        //订单类型
        readPayVC.orderType = _orderType;
        
        
        [self.navigationController pushViewController:readPayVC animated:YES];
    } else {
        //预存款
        ReadPayViewController * readPayVC = [[ReadPayViewController alloc] init];
        //是否使用红包
        readPayVC.isUseRedWallet = isUseRedwallet;
        //支付类型
        
        readPayVC.payType = 1;
        
        readPayVC.orderId = self.orderId;
        
        readPayVC.redpacketId = _redPacketId;
        readPayVC.couponId = _couponId;
        
        readPayVC.order_sn = [NSString stringWithFormat:@"订单号:%@", _orderNumber];
        
        CGFloat price =  [_useRedWalletPrice floatValue] - _sendFee;
        readPayVC.price =[NSString stringWithFormat:@"%.1f", price];
        readPayVC.sendPriceValue = [NSString stringWithFormat:@"%.1f",self.sendFee];
        //订单类型,根据订单类型
        readPayVC.orderType = _orderType;
        
        [self.navigationController pushViewController:readPayVC animated:YES];
    }
    
}

#pragma mark --- 微信支付
-(void)requestWeixinDataIsOnline:(BOOL)flag{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    //微信支付
    
    NSString *urlString;
    if (flag) {
        param[@"type"] = @"4";
        urlString = lineoutlinePayOrderUrl;
    } else {
        param[@"payType"] = @"4";
        urlString = payOrderUrl;
    }

    [self.httpManager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger  i = [responseObject[@"isSucc"] integerValue];
        
        if (i ==1) {
            
            weakself.prepareId = responseObject[@"result"][@"prepayid"];
            
            [self sendPay_demo];
            //
            [SVProgressHUD dismiss];

        } else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismissWithDelay:2];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        
        [SVProgressHUD dismissWithDelay:2];

    }];

}
#pragma mark --线上
-(void)requestOnlineWeixinData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    //微信支付
    param[@"type"] = @"4";
    
    if (isUseRedwallet == YES) {
        
        param[@"userRedPacket"] = @"1";
    }
    
    [weakself.httpManager POST:lineoutlinePayOrderUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger  i = [responseObject[@"isSucc"] integerValue];
        
        if (i ==1) {
            
            [SVProgressHUD dismiss];
            
            NSMutableDictionary * dict = responseObject[@"result"];
            
            weakself.prepareId = dict[@"prepayid"];
            
            [self sendPay_demo];
            
        } else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        
        [SVProgressHUD dismissWithDelay:1];
    }];
    
    
}

- (void)sendPay_demo
{
    
    // 配置微信支付的参数
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:__WXappID mch_id:__WXmchID];
    //设置密钥
    [req setKey:__WXpaySignKey];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
//    NSMutableDictionary * dict = [req sendPay_demo:_storeName andPrice:_orderPrice andNotifyUrl:_notify_url andTradeOrder:_outTrade_no andNoncestr:_noncestr andSign:_sign];
    NSMutableDictionary * dict = [req sendPay_demo:_prepareId];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        // 调用微信支付
        [WXApi sendReq:req];
    }
}

#pragma mark --通知服务器开始支付-支付宝支付
-(void)requestAlipayDataIsOnline:(BOOL)flag{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
 
    param[@"orderId"] = self.orderId;

    NSString *urlString;
    if (flag) {
        param[@"type"] = @"3";
        urlString = lineoutlinePayOrderUrl;
    } else {
        param[@"payType"] = @"3";
        urlString = payOrderUrl;
    }

    [weakself.httpManager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSInteger  i = [responseObject[@"isSucc"] integerValue];
            if (i ==1) {
            
                self.outTrade_no = responseObject[@"result"][@"out_trade_no"];
                self.orderBody = responseObject[@"result"][@"body"];
                self.orderSubjiect = responseObject[@"result"][@"subject"];
                self.total_fee =  responseObject[@"result"][@"total_fee"];
                
                self.notify_url = responseObject[@"result"][@"notify_url"];

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    [self doAlipayPay];
                    
                });
            
            } else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                [SVProgressHUD dismissWithDelay:3];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [SVProgressHUD dismissWithDelay:3];

    }];
}
-(void)requestOnlineData{
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = self.orderId;
    if (isUseRedwallet == YES) {
        
        param[@"userRedPacket"] = @"1";
    }
    param[@"type"] = @"3";
    
    [self.httpManager POST:lineoutlinePayOrderUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSInteger  i = [responseObject[@"isSucc"] integerValue];
        if (i ==1) {
            
            weakself.outTrade_no = responseObject[@"result"][@"out_trade_no"];
            weakself.orderBody = responseObject[@"result"][@"body"];
            weakself.orderSubjiect = responseObject[@"result"][@"subject"];
            weakself.total_fee =  responseObject[@"result"][@"total_fee"];
            weakself.notify_url = responseObject[@"result"][@"notify_url"];
            
            
            [weakself doAlipayPay];
            
        } else{
            
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网路错误"];
        
        [SVProgressHUD dismissWithDelay:2];
        
    }];
}
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
  
    
    //partner和seller获取失败,提示
    if ([AppId length] == 0 ||
        [PartnerPrivKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
}
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order * order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = AppId;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    order.notify_url = self.notify_url;
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = self.orderBody;
    order.biz_content.subject = [NSString stringWithFormat:@"%@",self.orderSubjiect];
    order.biz_content.out_trade_no = self.outTrade_no; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [_useRedWalletPrice floatValue]]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    // 需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString * appScheme = @"highdui";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        //支付成功的回调
   
        }];
    }
}


//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}


-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}
-(AFHTTPSessionManager *)httpManager{
    
    if (!_httpManager) {
        
        _httpManager = [AFHTTPSessionManager manager];
        //设置序列化,将JSON数据转化为字典或者数组
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        //在序列化器中追加一个类型，text、html这个类型不支持的，text、json，apllication，json
        _httpManager.responseSerializer.acceptableContentTypes = [_httpManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _httpManager.requestSerializer.timeoutInterval = 15;
        
        // AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        securityPolicy.allowInvalidCertificates = YES;
        //域名验证
        [securityPolicy setValidatesDomainName:NO];

        [_httpManager setSecurityPolicy:securityPolicy];
    }
    
    return _httpManager;
    
}
#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

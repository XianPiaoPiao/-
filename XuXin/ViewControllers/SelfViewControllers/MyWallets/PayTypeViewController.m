//
//  PayTypeViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "PayTypeViewController.h"
#import "TrueMethodTableViewCell.h"
#import "ChargeSureViewController.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
//导入微信支付文件
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "balanceReadyPayControllerViewController.h"

NSString * const payMethodInderfier = @"TrueMethodTableViewCell";
@interface PayTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,assign)NSInteger lastCellIndex;
@property (nonatomic ,copy)NSString * outTrade_no;
@property (nonatomic ,copy)NSString * orderBody;
@property(nonatomic,copy)NSString * orderSubjiect;
@property(nonatomic,copy)NSString * total_fee;
@property(nonatomic,copy)NSString * notify_url;
@property (nonatomic ,copy)NSString * noncestr;
@property (nonatomic ,copy)NSString * sign;
@property (nonatomic ,copy)NSString * orderPrice;

//
@property (nonatomic ,copy)NSString * prepareid;
@end

@implementation PayTypeViewController{
    UITableView * _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
    [self creatNavgationBar];
    
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(junmpVC) name:@"AlipaySucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(junmpVC) name:@"weixinSucess" object:nil];
}
//跳转到我的钱包
-(void)junmpVC{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
    
    UIViewController * viewCrl = self.navigationController.viewControllers[1];
    
    [self.navigationController popToViewController:viewCrl animated:YES];
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"支付形式选择"];
    [self addBackBarButtonItem];
}


-(void)creatUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, ScreenW, screenH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"TrueMethodTableViewCell" bundle:nil] forCellReuseIdentifier:payMethodInderfier];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, screenH - 80, ScreenW - 20, 50)];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 25;
    [btn setTitle:@"确认充值" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpInputPWVc) forControlEvents:UIControlEventTouchDown];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:MainColor];
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {

        TrueMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payMethodInderfier forIndexPath:indexPath];
        [cell.TrueMethodHeadImage setImage:[UIImage imageNamed:@"wx_icon.png"]];
        cell.PayMethodLabel.text = @"微信支付";
        
        return cell;
        
    } else if (indexPath.row ==1){
        TrueMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payMethodInderfier forIndexPath:indexPath];
        [cell.TrueMethodHeadImage setImage:[UIImage imageNamed:@"icon_money_zfb@2x"]];
        cell.PayMethodLabel.text = @"支付宝";
        return cell;
     
    }else{
        TrueMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payMethodInderfier forIndexPath:indexPath];
        [cell.TrueMethodHeadImage setImage:[UIImage imageNamed:@"ye_icon"]];
        
        cell.PayMethodLabel.text = @"余额支付";
        return cell;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrueMethodTableViewCell * lastSelectedcell =  (TrueMethodTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastCellIndex inSection:0]];
     TrueMethodTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
         cell.selected = YES;
    //未被点击
       [lastSelectedcell.trueMethodStateImage setImage:[UIImage imageNamed:@"icon_money_check_off@2x"]];
        //点击
        [cell.trueMethodStateImage setImage:[UIImage imageNamed:@"dingdan_chenggong@3x"]];
    
    
       self.lastCellIndex = indexPath.row;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(void)jumpInputPWVc{
    
    if (_lastCellIndex == 0) {
        
        [SVProgressHUD showWithStatus:@"正在打开微信"];
        [self requetWeixinData];

        
    }else if (_lastCellIndex == 1){
        //支付宝
        [SVProgressHUD showWithStatus:@"正在打开支付宝"];

        [self creatAlipayOrder];

    }else if (_lastCellIndex ==2){
        //余额支付预充值
        [SVProgressHUD showWithStatus:@"请等待"];
        //创建订单
        [self requestReadyPay];
        
    }

 
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
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary * dict = [req sendPay_demo:_prepareid];
    
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
        NSLog(@"-=========================%@",dict);
        // 调用微信支付
        [WXApi sendReq:req];
    }
}

#pragma mark --创建微信订单
-(void)requetWeixinData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"payment"] = @"4";
    param[@"amount"] = _moneyNumber;
    [weakself POST:createPreChargeOrderUrl parameters:param success:^(id responseObject) {
        
        NSInteger  i = [responseObject[@"isSucc"] integerValue];
        
        if (i ==1) {
            
            NSDictionary * dic = responseObject[@"result"];
            _notify_url = dic[@"notify_url"];
            _outTrade_no = dic[@"out_trade_no"];
            _orderPrice = dic[@"total_fee"];
            _noncestr = dic[@"noncestr"];
            _sign = dic[@"sign"];
            //
            _prepareid =dic[@"prepayid"];
            
            [self sendPay_demo];
            
        } else{
            
            [self showStaus:responseObject[@"msg"]];
        }
        

    } failure:^(NSError *error) {
        
        
    }];
 
}

#pragma mark --- 创建支付宝订单

-(void)creatAlipayOrder{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"payment"] = @"3";
    param[@"amount"] = _moneyNumber;
    [weakself POST:createPreChargeOrderUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            self.outTrade_no = responseObject[@"result"][@"out_trade_no"];
            self.orderBody = responseObject[@"result"][@"body"];
            self.orderSubjiect =  responseObject[@"result"][@"subject"];
            self.total_fee =  responseObject[@"result"][@"total_fee"];
            self.notify_url = responseObject[@"result"][@"notify_url"];
            [self doAlipayPay];
            
        }

    } failure:^(NSError *error) {
        

    }];
  

}
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
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [self.total_fee floatValue]]; //商品价格
    
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
        NSString *appScheme = @"highdui";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}


//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}
#pragma mark ---余额支付预充值
-(void)requestReadyPay{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"amount"] = _moneyNumber;
    param[@"payment"] = @"2";
    
    [weakself.httpManager POST:creatPreChargeOderUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            //余额支付
            ReadPayViewController * reayPayVC =[[ReadPayViewController alloc] init];
            reayPayVC.price = _moneyNumber;
            reayPayVC.orderType = 8;
            reayPayVC.orderId = responseObject[@"result"][@"id"];
            reayPayVC.order_sn = responseObject[@"result"][@"sc_sn"];
            
            [self.navigationController pushViewController:reayPayVC animated:YES];
          
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];

    }];

}
#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

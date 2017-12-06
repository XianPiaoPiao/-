//
//  qucklySendViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/1.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "qucklySendViewController.h"
#import "TrueMethodTableViewCell.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
//导入微信支付文件
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "ReadPayViewController.h"
#import "MyOrderBaseViewController.h"
NSString * const trueMethodIndertfier2 = @"TrueMethodTableViewCell";
@interface qucklySendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,assign)NSInteger lastCellIndex;
@property (nonatomic ,assign)NSInteger selectIndex;
@property(nonatomic ,copy)NSString * requestUrl;

@property (nonatomic ,copy)NSString * outTrade_no;
@property (nonatomic ,copy)NSString * orderBody;
@property(nonatomic,copy)NSString * orderSubjiect;
@property(nonatomic,copy)NSString * total_fee;
@property(nonatomic,copy)NSString * notify_url;
@property (nonatomic ,copy)NSString * noncestr;
@property (nonatomic ,copy)NSString * sign;
@property (nonatomic ,copy)NSString * orderPrice;

//
@property (nonatomic ,copy)NSString * prepayId;
@end

@implementation qucklySendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(junmpOrderVC) name:@"AlipaySucess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(junmpOrderVC) name:@"weixinSucess" object:nil];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
}
-(void)junmpOrderVC{
    
    MyOrderBaseViewController * myorderVC =[[MyOrderBaseViewController alloc] init];
    
    [User defalutManager].shopcart =[User defalutManager].shopcart - self.shopCarNumber;
    
    if (_payType == 1) {
        
        myorderVC.ordrType = 1;

    }else{
        
        myorderVC.ordrType = 4;

    }
    
    [self.navigationController pushViewController:myorderVC animated:YES];
    
}
-(void)creatUI{
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, ScreenW, screenH) style:UITableViewStylePlain];
  //  创建头部视图
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 160, 40)];
    nameLabel.textAlignment = 0;
    [nameLabel setText:[NSString stringWithFormat:@"快递费金额:"]];
    nameLabel.font = [UIFont systemFontOfSize:15];
    UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, ScreenW -170, 40)];
    
    numberLabel.text =[NSString
                        stringWithFormat:@"￥%@", self.price];
    numberLabel.textAlignment = 2;
    
    [numberLabel setTextColor:[UIColor colorWithHexString:MainColor]];
    [headerView addSubview:nameLabel];
    [headerView addSubview:numberLabel];
    //创建分割线
    UIView * sepereteView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 10)];
    sepereteView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [headerView addSubview:sepereteView];
    
    tableView.tableHeaderView = headerView;
    tableView.separatorStyle = NO;

    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"TrueMethodTableViewCell" bundle:nil] forCellReuseIdentifier:trueMethodIndertfier2];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //确认支付
    UIButton * surePayBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 300, ScreenW -20, 40)];
    surePayBtn.layer.cornerRadius = 5;
    [surePayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    surePayBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [surePayBtn addTarget:self action:@selector(surePay) forControlEvents:UIControlEventTouchDown];
    [tableView addSubview:surePayBtn];
}
-(void)creatNavgationBar{
    [self addNavgationTitle:@"快递费"];
    [self addBackBarButtonItem];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        TrueMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:trueMethodIndertfier2 forIndexPath:indexPath];
        [cell.TrueMethodHeadImage setImage:[UIImage imageNamed:@"ye_icon.png"]];
        
        [cell.trueMethodStateImage setImage:[UIImage imageNamed:@"exchange_selected@3x"]];
        return cell;
    } else if (indexPath.row ==1){
        
        TrueMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:trueMethodIndertfier2 forIndexPath:indexPath];
        [cell.TrueMethodHeadImage setImage:[UIImage imageNamed:@"icon_money_zfb@2x"]];
       cell.PayMethodLabel.text = @"支付宝";
        return cell;
        
    }else if (indexPath.row ==2){
        TrueMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:trueMethodIndertfier2 forIndexPath:indexPath];
        [cell.TrueMethodHeadImage setImage:[UIImage imageNamed:@"wx_icon.png"]];
        cell.PayMethodLabel.text = @"微信支付";
        return cell;
    }
    return 0;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrueMethodTableViewCell * lastSelectedcell =  (TrueMethodTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastCellIndex inSection:0]];
    
    TrueMethodTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //当前选中选中cell的下标
    self.selectIndex = indexPath.row;
    //点击
    [cell.trueMethodStateImage setImage:[UIImage imageNamed:@"exchange_selected@3x"]];
    //未被点击
    [lastSelectedcell.trueMethodStateImage setImage:[UIImage imageNamed:@"icon_money_check_off@2x"]];
    
    self.lastCellIndex = indexPath.row;
}
#pragma mark ---确认支付
-(void)surePay{
    
    
    if (self.selectIndex == 0) {
        //余额支付
        [SVProgressHUD showWithStatus:@"请稍等..."];

        
        self.requestUrl = payIntegralOrderCourierByBalanceUrl;
        [self requestBalancPayData];
        
    } else if (self.selectIndex == 1){
        //支付宝支付
        
        [SVProgressHUD showWithStatus:@"请稍等..."];

        self.requestUrl = payIntegralOrderCourierUrl;
        [self requestPayData];

    }else if (_selectIndex == 2){
        //微信支付
        [SVProgressHUD showWithStatus:@"请稍等..."];

        self.requestUrl = payIntegralOrderWeChatUrl;
        
        [self requestPayData];
        
    }
}
#pragma mark ---余额支付快递费
-(void)requestBalancPayData{
    
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = self.orderId;
    
    param[@"type"] =[NSString stringWithFormat:@"%ld", _ordertType];
    
    [self.httpManager POST:self.requestUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSInteger  i = [responseObject[@"isSucc"] integerValue];
        if (i ==1) {
            
            if (_selectIndex == 1) {
                //支付宝支付
                self.outTrade_no = responseObject[@"result"][@"out_trade_no"];
                self.orderBody = responseObject[@"result"][@"body"];
                self.orderSubjiect =  responseObject[@"result"][@"subject"];
                self.total_fee =  responseObject[@"result"][@"total_fee"];
                self.notify_url = responseObject[@"result"][@"notify_url"];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakself doAlipayPay];
                    
                });
                
            }else if (_selectIndex == 0){
                //余额支付
                if (weakself.sendType == 1) {
#pragma mark ---余额支付快递费
                    
                    MyOrderBaseViewController * orderBaseVC = [[MyOrderBaseViewController alloc] init];
                    //预充值支付
                    if (_payType == 1) {
                        
                        orderBaseVC.ordrType = 1;
                        
                    }else{
                        
                        orderBaseVC.ordrType = 4;
                        
                    }
                    
                    [weakself.navigationController pushViewController:orderBaseVC animated:YES];
                    
                }else{
                    
                    ReadPayViewController * readPayVC =[[ReadPayViewController alloc] init];
                    readPayVC.payType = 5;
                    readPayVC.price = _intergralPoint;
                    readPayVC.orderId = _orderId;
                    readPayVC.order_sn = _orderSn;
                    [weakself.navigationController pushViewController:readPayVC animated:YES];
                }
            }else if (_selectIndex == 2){
                //微信支付
                _prepayId = responseObject[@"result"][@"prepayid"];
                
                [weakself sendPay_demo];
                
            }
            
            
        }
        //错误提示消息
        else {
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismiss];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
        [SVProgressHUD dismiss];
    }];
    



}
#pragma mark ---支付数据请求
-(void)requestPayData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = self.orderId;
    
    [self.httpManager POST:self.requestUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];

        NSInteger  i = [responseObject[@"isSucc"] integerValue];
        if (i ==1) {
            
            if (_selectIndex == 1) {
                //支付宝支付
                self.outTrade_no = responseObject[@"result"][@"out_trade_no"];
                self.orderBody = responseObject[@"result"][@"body"];
                self.orderSubjiect =  responseObject[@"result"][@"subject"];
                self.total_fee =  responseObject[@"result"][@"total_fee"];
                self.notify_url = responseObject[@"result"][@"notify_url"];
                

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakself doAlipayPay];
                    
                });
                
            }else if (_selectIndex == 0){
                //余额支付
                if (weakself.sendType == 1) {
     #pragma mark ---余额支付快递费
                    
            MyOrderBaseViewController * orderBaseVC = [[MyOrderBaseViewController alloc] init];
                    //预充值支付
            if (_payType == 1) {
                        
                orderBaseVC.ordrType = 1;

            }else{
                        
                orderBaseVC.ordrType = 4;
 
        }
                    
                    [weakself.navigationController pushViewController:orderBaseVC animated:YES];
                    
                }else{
                    
                ReadPayViewController * readPayVC =[[ReadPayViewController alloc] init];
                readPayVC.payType = 5;
                readPayVC.price = _intergralPoint;
                readPayVC.orderId = _orderId;
                readPayVC.order_sn = _orderSn;
                [weakself.navigationController pushViewController:readPayVC animated:YES];
                }
            }else if (_selectIndex == 2){
                   //微信支付
                    _prepayId = responseObject[@"result"][@"prepayid"];
                
                    [weakself sendPay_demo];
                    
            }
            
            
        }
        //错误提示消息
        else {
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismiss];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
        [SVProgressHUD dismiss];
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
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary * dict = [req sendPay_demo:_prepayId];
    NSLog(@"====================%@",dict);
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
        NSLog(@"-=========================%@",req.openID);
        // 调用微信支付
        [WXApi sendReq:req];
    }
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

#pragma mark --移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

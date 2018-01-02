//
//  ReadPayViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/17.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ReadPayViewController.h"
#import "MyOrderBaseViewController.h"
#import "qucklySendViewController.h"
#import "CashPayViewController.h"
#import "ChangePayPasswordViewController.h"
#import "MyOrderDetailViewController.h"
@interface ReadPayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;
@property (weak, nonatomic) IBOutlet UILabel *order_snLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopLeading;

@end

@implementation ReadPayViewController{
    
    UITextField * _payField ;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.labelTopLeading.constant = self.StatusBarHeight+65;
    
    if (_integral > 0) {
        _priceLabel.text = [NSString stringWithFormat:@"%@",_integral];
        _titleLabel.text = @"付款积分";
    } else {
        _priceLabel.text =[NSString stringWithFormat:@"￥%@",_price];
        _titleLabel.text = @"付款金额";
    }
    
    _priceLabel.textColor = [UIColor colorWithHexString:MainColor];
    _order_snLabel.text = _order_sn;
    
    [MTA trackPageViewBegin:@"ReadPayViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"ReadPayViewController"];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self creatPayField];

}

-(void)creatPayField{
    
    
    //创建左视图
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 85, 40)];
    label.textAlignment = 1;
    label.text = @"支付密码 :";
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    _payField = [[UITextField alloc] initWithFrame:CGRectMake(0, 280, ScreenW, 40)];
    _payField.secureTextEntry = YES;
    _payField.backgroundColor = [UIColor whiteColor];
    
    _payField.leftViewMode = UITextFieldViewModeAlways;
    _payField.font = [UIFont systemFontOfSize:15];
    _payField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _payField.leftView = label;
    [self.view addSubview:_payField];
    
    UIButton * forgetPasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 100, 330, 100, 20)];
    [forgetPasswordBtn setTitle:@"忘记支付密码?" forState:UIControlStateNormal];
    forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [forgetPasswordBtn setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
    
    [self.view addSubview:forgetPasswordBtn];
    
    [forgetPasswordBtn addTarget:self action:@selector(jumpForgetVC) forControlEvents:UIControlEventTouchDown];
    
    //确认按钮
    self.SureBtn.layer.cornerRadius = 25;
    
    [self.SureBtn addTarget:self action:@selector(jumpPayVC:) forControlEvents:UIControlEventTouchUpInside];
    
    self.SureBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    
}
#pragma mark -----忘记支付密码
-(void)jumpForgetVC{
    
    
    ChangePayPasswordViewController * passWordVC = [[ChangePayPasswordViewController alloc] init];
    
    passWordVC.type = changePasswordType;
    
    [self.navigationController pushViewController:passWordVC animated:YES];
}
#pragma mark ---去支付
-(void)jumpPayVC:(UIButton *)sender{
    
    
    
    if (_sendType == 1 || _sendType == 2) {
        //去支付快递费
        
        [SVProgressHUD showWithStatus:@"请稍等"];
        
        [self requestSendPriceData];
        
    }else{
        
        if (_orderType == 1 ||_orderType == 2) {
            [SVProgressHUD showWithStatus:@"请稍等"];

            //线上线下
            [self requestOlineData];
        }else if (_orderType ==8){
            
            //余额支付预充值
            [SVProgressHUD showWithStatus:@"请稍等"];
            //
            [self requestReadyPayData];
        }
        
        else{
            //面对面支付
             [SVProgressHUD showWithStatus:@"请稍等"];
            
             [self requetdData];
            
        }
    }
}
#pragma  mark ---面对面密码验证
-(void)requetdData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = self.orderId;
    
    NSString *urlString;
    
    if (_isUseRedWallet == YES) {
        
        if (_redpacketId != nil) {
            param[@"redpacketid"] = _redpacketId;
        }
        if (_couponId != nil) {
            param[@"couponid"] = _couponId;
        }
    }
//    else {
//
//        param[@"payType"] = [NSString stringWithFormat:@"%ld",_payType];
//        param[@"payPassword"] = _payField.text;
//        urlString = payOrderUrl;
//    }
    param[@"payType"] = [NSString stringWithFormat:@"%ld",_payType];
    param[@"payPassword"] = _payField.text;
    urlString = payFace2FaceOrderUseCouponUrl;
    [self POST:urlString parameters:param success:^(id responseObject) {
       
       [SVProgressHUD dismiss];
       //
       NSInteger  i = [responseObject[@"isSucc"] integerValue];
       if (i ==1) {
           

           NSString * balance =  responseObject[@"result"][@"availableBalance"];
           
           //更新数据
           [User defalutManager].balance = [balance integerValue];
           
           
           NSString *  preDeposit  = responseObject[@"result"][@"preDeposit"];
           
           [User defalutManager].preDeposit = [preDeposit  integerValue];
           //红包自减
           [User defalutManager].redPacket--;
         
         
           MyOrderBaseViewController * myOrderVC =[[MyOrderBaseViewController alloc] init];
           
           myOrderVC.ordrType = _orderType;
           
           [weakself.navigationController pushViewController:myOrderVC animated:YES];
           
       }
       
       
       
   } failure:^(NSError *error) {
       
}];


}

#pragma mark ---线上线下商品密码验证
-(void)requestOlineData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];

    param[@"orderId"] = self.orderId;
    
    param[@"type"] = [NSString stringWithFormat:@"%ld",_payType];
    
    if (_isUseRedWallet == YES) {
        
        if (_redpacketId != nil) {
            param[@"packetid"] = _redpacketId;
        }
    }
    
    param[@"pwd"] = _payField.text;

   [self POST:lineoutlinePayOrderUsePracktUrl parameters:param success:^(id responseObject) {
       
       NSInteger  i = [responseObject[@"isSucc"] integerValue];

       if (i == 1) {
           
           //预存款支付的
           if (_payType == 1) {
               
               NSString * str = responseObject[@"result"][@"ship_price"];
               
               
               if ([str doubleValue]  > 0) {
                   
                   qucklySendViewController * qucklyVC = [[qucklySendViewController alloc] init];
                   
                   qucklyVC.shopCarNumber = self.shopCarNumber;
                   
                   qucklyVC.orderId= _orderId;
                   
                   qucklyVC.intergralPoint = _price;
                   
                   qucklyVC.orderSn = _order_sn;
                   
                   qucklyVC.price = str;
                   //快递支付
                   qucklyVC.sendType = 1;
                   //线上线下
                   qucklyVC.payType = 1;
                   
                   qucklyVC.ordertType = 1;

                   [weakself.navigationController pushViewController:qucklyVC animated:YES];
                   
               }else{
                   
                   //去订单列表
                   
                   MyOrderBaseViewController * myOrderVC =[[MyOrderBaseViewController alloc] init];
                   
                   myOrderVC.ordrType = _orderType;
                   
                   //剩余购物车的数量
                   [User defalutManager].lineShopCart =[User defalutManager].lineShopCart - self.shopCarNumber;
                   
                   [weakself.navigationController pushViewController:myOrderVC animated:YES];
               }
               

               
        }else{
               //去订单列表
               
               MyOrderBaseViewController * myOrderVC =[[MyOrderBaseViewController alloc] init];
               
               myOrderVC.ordrType = _orderType;
               
               //剩余购物车的数量
               [User defalutManager].lineShopCart =[User defalutManager].lineShopCart - self.shopCarNumber;
               
               [weakself.navigationController pushViewController:myOrderVC animated:YES];
           
   
           }
           
           if (_isUseRedWallet == YES) {
               
               [User defalutManager].redPacket --;
           }
    }

       
    } failure:^(NSError *error) {
    
        
    }];
}
#pragma mark ---兑换商品密码验证
-(void)requestSendPriceData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = self.orderId;
    
    param[@"type"] = [NSString stringWithFormat:@"%ld",(long)_categoryType];
    
    param[@"pwd"] = _payField.text;
    
    [self POST:paypwdwordcheckUrl parameters:param success:^(id responseObject) {
     
     
        NSInteger  i = [responseObject[@"isSucc"] integerValue];
        
        if (i == 1) {
         
         //去支付快递费
         if (weakself.sendType == 1 || [_price doubleValue] > 0) {
             
//             qucklySendViewController * qucklyVC = [[qucklySendViewController alloc] init];
             CashPayViewController *cashPayVC = [[CashPayViewController alloc] init];
             
             cashPayVC.shopCarNumber = self.shopCarNumber;
             
             cashPayVC.orderId= _orderId;
             
             cashPayVC.cash = _price;
             
             cashPayVC.intergralPoint = [NSString stringWithFormat:@"%.2f",[_sendPriceValue floatValue] + [_price floatValue]];
             
             cashPayVC.orderSn = _order_sn;
             
             cashPayVC.sendPrice = _sendPriceValue;
             //快递支付
             cashPayVC.sendType = 1;
             //兑换
             cashPayVC.ordertType = 2;
             [weakself.navigationController pushViewController:cashPayVC animated:YES];
         }else{
             
             //去订单列表
             
             MyOrderBaseViewController * myOrderVC =[[MyOrderBaseViewController alloc] init];
             
             myOrderVC.ordrType = 4;
             
             //剩余购物车的数量
             [User defalutManager].shopcart =[User defalutManager].shopcart - self.shopCarNumber;
             [User defalutManager].integral = [User defalutManager].integral - [_integral integerValue];
             
             [weakself.navigationController pushViewController:myOrderVC animated:YES];
         }
         
     }
     
     

 } failure:^(NSError *error) {
     
     
 }];
    

}
#pragma mark ---余额支付预充值
-(void)requestReadyPayData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"orderId"] = _orderId;
    param[@"payPassword"] = _payField.text;
    
    [weakself.httpManager POST:balancePayShopcoinUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
       NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
        [self showStaus:@"充值成功"];
            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIViewController * vc = self.navigationController.viewControllers[1];
                
                [self.navigationController popToViewController:vc animated:YES];
            });
         
    }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];

    }];
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"支付订单"];
    
    [self addBackBarButtonItem];
}

- (void)backAction{
    if ([_backString isEqualToString:@"NotPayYet"]) {
        MyOrderDetailViewController * covertVC = [[MyOrderDetailViewController alloc] init];
        
        covertVC.requestUrl = integralOrderDetailUrl;
        
        covertVC.goodID = [NSString stringWithFormat:@"%@",_orderId];
        covertVC.backString = _backString;
        [self.navigationController pushViewController:covertVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)ReturnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
        
}


@end

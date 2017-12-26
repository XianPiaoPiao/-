
//  CovertOrderViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CovertOrderViewController.h"
#import "FaceToFaceOrderModel.h"
#import "MyOrderTableViewController.h"
#import "SBMyOrderTableviewController.h"
#import "OrderCommentsController.h"
@interface CovertOrderViewController ()<UIAlertViewDelegate>



@property (nonatomic ,strong)NSMutableArray * dataArray;

@end

@implementation CovertOrderViewController{
    
    UIButton * _payBtn;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self requestData];
    
    self.ViewTop.constant = 65+self.StatusBarHeight;
    
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"面对面订单详情"];
    
    [self addBackBarButtonItem];
    
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateUI{
    
    FaceToFaceOrderModel * model = self.dataArray[0];
    _adeessLabel.text = model.storeAddress;
    //时间戳转时间
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    [format setTimeStyle:NSDateFormatterShortStyle];
    
    [format setDateFormat:@"yyyy-MM-dd"];

    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.orderCreateTime/1000.f];
    NSString * dateStr = [format stringFromDate:date];
    
    _addTimeOrderLabel.text =[NSString stringWithFormat:@"%@" ,dateStr];

    
    _storeName.text = model.storeName;
    
    _phoneLable.text =[NSString stringWithFormat:@"%@", model.storePhone];
 
    
    _priceLabel .textColor = [UIColor colorWithHexString:MainColor];
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%.1f", model.orderPrice];
    
    _redwalletLabel.textColor = [UIColor colorWithHexString:@"#05b5ef"];
    
    _couponLabel.textColor = [UIColor colorWithHexString:@"#05b5ef"];
    
    if (model.redpacketmoeny > 0) {
        
        _redwalletLabel.text = [NSString stringWithFormat:@"￥%ld",model.redpacketmoeny];
        
    }else{
        
        _redwalletLabel.text = [NSString stringWithFormat:@"￥0"];
    }
    if (model.couponmoeny > 0) {
        
        _couponLabel.text = [NSString stringWithFormat:@"￥%ld",model.couponmoeny];
        
    }else{
        
        _couponLabel.text = [NSString stringWithFormat:@"￥0"];
    }
    
    _turePayLabel.text = [NSString stringWithFormat:@"￥%.1f", model.orderPrice - model.redpacketmoeny - model.couponmoeny];

    _turePayLabel.textColor = [UIColor colorWithHexString:MainColor];
    _orderStutasLabel.textColor = [UIColor colorWithHexString:MainColor];
    _orderIdLabel.text =[NSString stringWithFormat:@"%@", model.orderSn];
    _payLbael.text = model.payment;
    
    //订单状态
    if (model.status == 0) {
     
        _orderStutasLabel.text = @"未支付";
  
        UIView * bgView =[[UIView alloc] initWithFrame:CGRectMake(0, 494+self.StatusBarHeight, ScreenW, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UIButton * deleteBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 170, 5, 70, 30)];
        deleteBtn.layer.cornerRadius = 4;
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        [deleteBtn addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchDown];
        
        
        _payBtn  =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 80, 5, 70, 30)];
        
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.layer.cornerRadius = 4;
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        //再次发起支付
        [_payBtn addTarget:self action:@selector(facePayAgain) forControlEvents:UIControlEventTouchDown];
        
        _payBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        
        [bgView addSubview:_payBtn];
        [bgView addSubview:deleteBtn];
        
    }else if (model.status == 1 ){
        
       _orderStutasLabel.text = @"买单成功";
        
        
        if (model.evaluationState == 1) {
            
          _orderStutasLabel.text = @"已评价" ;
            
        }else{
    
            UIView * bgView =[[UIView alloc] initWithFrame:CGRectMake(0, 494+self.StatusBarHeight, ScreenW, 40)];
            bgView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:bgView];
            
            UIButton * commentBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 80, 5, 70, 30)];
            commentBtn.layer.cornerRadius = 4;
            commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
            [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            commentBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            [commentBtn addTarget:self action:@selector(goComment) forControlEvents:UIControlEventTouchDown];
            [bgView addSubview:commentBtn];
        }
        
    }
}
#pragma mark ---去评论
-(void)goComment{
    
    FaceToFaceOrderModel * model = self.dataArray[0];

    OrderCommentsController * orderCommentVC =[[OrderCommentsController alloc] init];
    //面对面评论
    orderCommentVC.orderType = 3;
    orderCommentVC.storeName = model.storeName;
    orderCommentVC.storeLogo = model.storeLogo;
    
    orderCommentVC.storeId =[NSString stringWithFormat:@"%ld",model.orderId];
    
    [self.navigationController pushViewController:orderCommentVC animated:YES];
    
}
#pragma mark --再次支付
-(void)facePayAgain{
    
    FaceToFaceOrderModel * model = self.dataArray[0];
   
    UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
    
    myOrderVC.orderPrice = [NSString stringWithFormat:@"%.2f",model.orderPrice];
    myOrderVC.factPrice = [NSString stringWithFormat:@"%.2f",model.orderPrice];
    myOrderVC.orderType = 3;
    myOrderVC.orderId =[NSString stringWithFormat:@"%ld", model.orderId];
    myOrderVC.orderNumber = model.orderSn;
    if (model.couponmoeny > 0 || model.redpacketmoeny > 0) {
        myOrderVC.type = 1;
        myOrderVC.redpacketmoeny = model.redpacketmoeny;
        myOrderVC.couponmoeny = model.couponmoeny;
        myOrderVC.isUseCoupon = YES;
    } else {
        myOrderVC.type = 1;
    }
    myOrderVC.redpacketmoeny = model.redpacketmoeny;
    myOrderVC.couponmoeny = model.couponmoeny;
    [self.navigationController pushViewController:myOrderVC animated:YES];

}
#pragma mark ---数据请求
-(void)requestData{
    //开始动画
    [[EaseLoadingView defalutManager] startLoading];
    [self.view addSubview:[EaseLoadingView defalutManager]];
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"id"] = _idName;
    
    [self POST:face2faceOrderDetailUrl parameters:param success:^(id responseObject) {
        
        //停止动画
        [[EaseLoadingView defalutManager] stopLoading];

        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSDictionary  * dic = responseObject[@"result"];
            FaceToFaceOrderModel * model = [FaceToFaceOrderModel yy_modelWithDictionary:dic];
            [weakself.dataArray addObject:model];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself updateUI];
        });

    } failure:^(NSError *error) {
        //开始动画
        [[EaseLoadingView defalutManager] stopLoading];
        
    }];

}
#pragma mark ---删除订单
-(void)deleteOrder{
    
    UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alterView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [self deleteOrderData];
    }
}
//删除订单
-(void)deleteOrderData{
    
    FaceToFaceOrderModel * model = self.dataArray[0];

    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = [NSString stringWithFormat:@"%ld",model.orderId];
    //面对面订单
    //1，删除面对面订单，2删除兑换订单，3删除线上，4删除线下
    param[@"type"] = @"1";
    
    [self POST:appdelectOrderUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            [weakself showStaus:@"删除订单成功"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrderOK" object:nil];
                
                [weakself.navigationController popViewControllerAnimated:YES];
                
            });
            
        }
    } failure:^(NSError *error) {
        
    }];
    

}
- (IBAction)phoneCallAction:(id)sender {
    
    UIWebView * webVIew = [[UIWebView alloc] init];
    FaceToFaceOrderModel * model = self.dataArray[0];

    NSString * phoneNumber = model.storePhone;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [webVIew loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webVIew];
}


@end

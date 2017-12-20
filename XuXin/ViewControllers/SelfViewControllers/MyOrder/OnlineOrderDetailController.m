//
//  OnlineOrderDetailController.m
//  XuXin
//
//  Created by xuxin on 17/3/10.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "OnlineOrderDetailController.h"
#import "RecievePlaceTableViewCell.h"
#import "OrderNumberTableViewCell.h"
#import "OrderDerailTableViewCell.h"
#import "SendWayandPayWayTableViewCell.h"
#import "CovertGradeAndQueueSendTableViewCell.h"
#import "convertDetailModel.h"
#import "intergralGoodsModel.h"
#import "CovertGoodsViewController.h"
#import "CheckTransportationController.h"
#import "qucklySendViewController.h"
#import "WriteOrderViewController.h"
#import "SBMyOrderTableviewController.h"
#import "MyOrderTableViewController.h"
#import "OnlineOrderModel.h"
#import "OrderCommentsController.h"
#import "BackOnlineOrderController.h"
#import "BackGoodsTransportController.h"
#import "OnlineGoodsModel.h"
#import "InsetLabel.h"
NSString * const OnlineRecivePlaceInderfer = @"RecievePlaceTableViewCell";
NSString * const OnlineOrderDetailIndertifer = @"OrderDerailTableViewCell";
NSString * const OnlineSendWayandPayInderfier = @"SendWayandPayWayTableViewCell";

@interface OnlineOrderDetailController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic ,strong)Goods * pickModel;

@property (nonatomic ,strong)OnlineOrderModel * model;

@property(nonatomic ,strong)NSMutableArray * dataArray;

@property (nonatomic ,strong)NSMutableArray * goodsArray;


@end

@implementation OnlineOrderDetailController
-(OnlineOrderModel *)model{
    if (!_model) {
        
        _model = [[OnlineOrderModel alloc] init];
    }
    return _model;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //数据请求
    [self creatOrderTableView];
    
    [self creatNavgationBar];

    [self requestData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark ---订单详情数据请求
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    
    [self.view addSubview:[EaseLoadingView defalutManager]];
    [[EaseLoadingView defalutManager] startLoading];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"]= self.goodID;
    
    [weakself POST:findOrderDetailsByIdUrl parameters:param success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
        NSString * str = responseObject[@"isSucc"];
        NSLog(@"线上订单详情=======\n%@",responseObject);
        if ([str intValue] == 1) {
            
            NSDictionary * dic = responseObject[@"result"];
          
            weakself.model  =[OnlineOrderModel yy_modelWithDictionary:dic];
            NSArray * array = dic[@"goods"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ONLINEgoodsModel class] json:array];
            weakself.goodsArray = [NSMutableArray arrayWithArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.tableView reloadData];
                
            });
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
    }];
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"线上订单详情"];
    
    [self addBackBarButtonItem];
}

-(void)creatOrderTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //设置tab的section间距
    _tableView.sectionFooterHeight = 5 ;
    _tableView.sectionHeaderHeight = 5;
    
    [_tableView registerNib:[UINib nibWithNibName:@"RecievePlaceTableViewCell" bundle:nil] forCellReuseIdentifier:OnlineRecivePlaceInderfer];
    
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDerailTableViewCell" bundle:nil] forCellReuseIdentifier:OnlineOrderDetailIndertifer];
    [_tableView registerNib:[UINib nibWithNibName:@"SendWayandPayWayTableViewCell" bundle:nil] forCellReuseIdentifier:OnlineSendWayandPayInderfier];
}

#pragma mark ---tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
        
        if (indexPath.section == 0) {
            
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = NO;
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 60, 40)];
            label.text =[NSString stringWithFormat:@"订单号:%@", self.model.order_sn];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor blackColor];
            [cell.contentView addSubview:label];
            
            //时间戳转时间
            NSDateFormatter * format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            [format setDateStyle:NSDateFormatterMediumStyle];
            [format setTimeStyle:NSDateFormatterShortStyle];
            
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.model.time/1000.f];
            NSString * dateStr = [format stringFromDate:date];
            
            UILabel * orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, ScreenW, 20)];
            orderTimeLabel.textColor = [UIColor blackColor];
            orderTimeLabel.font = [UIFont systemFontOfSize:14];
            orderTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",dateStr];
            [cell.contentView addSubview:orderTimeLabel];
            
            return cell;
        }else if (indexPath.section == 1){
            
            RecievePlaceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:OnlineRecivePlaceInderfer forIndexPath:indexPath];
            
            cell.selectionStyle = NO;
            cell.nextAcotBtn.hidden = YES;
            cell.NameLabel.text =[NSString stringWithFormat:@"收货人:%@",self.model.consignee];
            cell.phoneNumberLabel.text = self.model.mobile;
            
            cell.receivePlaceLbael.text = self.model.address;
            return cell;
            
        } else if (indexPath.section == 2){
            
            OrderDerailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:OnlineOrderDetailIndertifer forIndexPath:indexPath];
            cell.selectionStyle = NO;
            ONLINEgoodsModel * model = self.goodsArray[indexPath.row];
            
            cell.goodsModel = model;
            return cell;
        }else if (indexPath.section ==3 ){
            
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            
            cell.selectionStyle = NO;
            
            NSArray * array = @[@"支付方式",@"配送方式",@"红包折扣",@"优惠券折扣",@"邮  费"];
            for (int i = 0; i < 5; i ++) {
                
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + i * 40, 80, 20)];
                label.font = [UIFont systemFontOfSize:15];
                label.text = array[i];
                
                [cell.contentView addSubview:label];
                if (i == 2) {
                    
                    label.frame = CGRectMake(10, 80, 80, 20);
                    
                }
                if (i == 3) {
                    
                    label.frame = CGRectMake(10, 110, 80, 20);
                    
                }
                if (i == 4) {
                    
                    label.frame = CGRectMake(10, 140, 80, 20);
                    
                }
              
            }
            //分割线
            for (int i = 1; i < 5; i++) {
                
                UIView * sptString = [[UIView alloc] initWithFrame:CGRectMake(0,i * 40, ScreenW , 1)];
                sptString.backgroundColor = [UIColor colorWithHexString:BackColor];
                [cell.contentView addSubview:sptString];
                
                if (i == 2) {
                    
                    sptString.frame = CGRectMake(10, 75, ScreenW, 1);
                }else if (i == 3) {
                    
                    sptString.frame = CGRectMake(10, 105, ScreenW, 1);
                }else if (i ==4){
                    
                    sptString.frame = CGRectMake(10, 135, ScreenW, 1);

                }
                
                
            }
       
            
            
            UILabel * payTypeLbel =[[UILabel alloc] initWithFrame:CGRectMake( 100, 10, ScreenW - 110, 20)];
            payTypeLbel.font =[UIFont systemFontOfSize:15];
            payTypeLbel.textAlignment = 2;
            payTypeLbel.text = self.model.paymentMethod;
            
            [cell.contentView addSubview:payTypeLbel];
            //快递方式
            UILabel * sendTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 100, 50, ScreenW - 110, 20)];
            sendTypeLabel.text = @"快递";
            sendTypeLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:sendTypeLabel];
            sendTypeLabel.textAlignment  = 2;
            //红包
            UILabel * redLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, ScreenW - 110, 20)];
            
            redLabel.textAlignment = 2;
            redLabel.font = [UIFont systemFontOfSize:14];
            redLabel.textColor = [UIColor colorWithHexString:@"#05b5ef"];
            [cell.contentView addSubview:redLabel];
            
            if (self.model.redpacketmoeny > 0) {
                
                redLabel.text =[NSString stringWithFormat:@"￥%ld",self.model.redpacketmoeny];
                
            }else{
                redLabel.text =@"￥0";
            }
            //优惠券
            UILabel * couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 110, ScreenW - 110, 20)];
            
            couponLabel.textAlignment = 2;
            couponLabel.font = [UIFont systemFontOfSize:14];
            couponLabel.textColor = [UIColor colorWithHexString:@"#05b5ef"];
            [cell.contentView addSubview:couponLabel];
            
            if (self.model.couponmoeny > 0) {
                
                couponLabel.text =[NSString stringWithFormat:@"￥%ld",self.model.couponmoeny];
                
            }else{
                couponLabel.text =@"￥0";
            }
            
            //快递费
            UILabel * sendFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 140, ScreenW - 110, 20)];
            
            sendFeeLabel.font = [UIFont systemFontOfSize:14];
            
            sendFeeLabel.textAlignment = 2;
            sendFeeLabel.textColor = [UIColor colorWithHexString:MainColor];
            [cell.contentView addSubview:sendFeeLabel];
            
            sendFeeLabel.text =[NSString stringWithFormat:@"￥%.1f", self.model.freight];
            
            return cell;
            
        } else if (indexPath.section ==4){
            
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            
            cell.selectionStyle = NO;
            
            UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
            label.text = @"实际支付";
            label.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:label];
            
            UILabel * goodsPriceLbael =[[UILabel alloc] initWithFrame:CGRectMake(80, 10, ScreenW - 90, 20)];
            goodsPriceLbael.textAlignment = 2;
            goodsPriceLbael.font = [UIFont systemFontOfSize:15];
            goodsPriceLbael.textColor = [UIColor colorWithHexString:MainColor];
            goodsPriceLbael.text =[NSString stringWithFormat:@"￥%.1f", self.model.price];
            [cell.contentView addSubview:goodsPriceLbael];
            //
            UIButton * cancelOrderBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 160, 45, 70, 30)];
            cancelOrderBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            cancelOrderBtn.layer.cornerRadius = 3;
   
            [cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancelOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
         
            [cell.contentView addSubview:cancelOrderBtn];
            //
            UIView * sptString = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenW, 1)];
            sptString.backgroundColor = [UIColor colorWithHexString:BackColor];
            [cell.contentView addSubview:sptString];
            
            UIButton * giveBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 80, 45 , 70, 30)];
            giveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            giveBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            [giveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            giveBtn.layer.cornerRadius = 3;
            
            [cell.contentView addSubview:giveBtn];
            
            //取消订单
            if (self.model.status == cancelType) {
                
                cancelOrderBtn.hidden = YES;
                
                [giveBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [giveBtn addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchDown];
                
            }else if (self.model.status == waitSend){
                
                cancelOrderBtn.hidden = YES;
           //     [cancelOrderBtn addTarget:self action:@selector(giveMessage) forControlEvents:UIControlEventTouchDown];
           //     [cancelOrderBtn setTitle:@"提醒发货" forState:UIControlStateNormal];                // giveBtn.hidden = YES;
                
                [giveBtn addTarget:self action:@selector(backGoodsMoney) forControlEvents:UIControlEventTouchDown];
                [giveBtn setTitle:@"退款" forState:UIControlStateNormal];
            } else if (self.model.status == waitPayType){
                cancelOrderBtn.hidden = YES;
//                [cancelOrderBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchDown];
//                [cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                //再次支付
                [giveBtn addTarget:self action:@selector(payAgain) forControlEvents:UIControlEventTouchDown];
                
                [giveBtn setTitle:@"付款" forState:UIControlStateNormal];
                
            } else if (self.model.status == waitSendGoods){
                cancelOrderBtn.hidden = YES;
//                [cancelOrderBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchDown];
//                [cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                //再次支付
                [giveBtn addTarget:self action:@selector(paySendFee) forControlEvents:UIControlEventTouchDown];
                
                [giveBtn setTitle:@"支付快递费" forState:UIControlStateNormal];
                
            } else if(self.model.status == haveDoneSend || self.model.status == sellerRejectGoods){
                
                UIButton * retureBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 220, 45 , 50, 30)];
                retureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                retureBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
                [retureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                retureBtn.layer.cornerRadius = 3;
                [retureBtn addTarget:self action:@selector(backGoodsMoney) forControlEvents:UIControlEventTouchDown];
                [retureBtn setTitle:@"退货" forState:UIControlStateNormal];
                [cell.contentView addSubview:retureBtn];
                //评价

                [cancelOrderBtn setTitle:@"查看快递" forState:UIControlStateNormal];

                [cancelOrderBtn addTarget:self action:@selector(checkQueuk) forControlEvents:UIControlEventTouchDown];

                //评价
                [giveBtn setTitle:@"确认收货" forState:UIControlStateNormal];

                [giveBtn addTarget:self action:@selector(sureRecevieGoods) forControlEvents:UIControlEventTouchDown];
                
            }else if(self.model.status == haveDone){
                
                cancelOrderBtn.hidden = YES;
                
                //评价
                [giveBtn setTitle:@"评价" forState:UIControlStateNormal];
                
                [giveBtn addTarget:self action:@selector(commentOrder) forControlEvents:UIControlEventTouchDown];
                
            }
            else if (self.model.status == writeRetureGoodsStutes){
              //待填写物流
                cancelOrderBtn.hidden = YES;
                
                [giveBtn setTitle:@"填写物流" forState:UIControlStateNormal];
              
                [giveBtn addTarget:self action:@selector(writeTransport) forControlEvents:UIControlEventTouchDown];
            }
            else if (self.model.status == returnGoodsType){
                //退货中
                [giveBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                
                [giveBtn addTarget:self action:@selector(checkReturenQueck) forControlEvents:UIControlEventTouchDown];
                
                cancelOrderBtn.hidden = YES;

           
              //买家申请退货
            }
            else if (self.model.status == buyerend || self.model.status == returnMoney){
               
                cancelOrderBtn.hidden = YES;
                
                giveBtn.hidden = YES;
                
            }else if (self.model.status == returnGoodsCompete){
                
                cancelOrderBtn.hidden = YES;
                giveBtn.hidden = YES;

            }else if (self.model.status == haveReceived){
                cancelOrderBtn.hidden = YES;
                
                //评价
                [giveBtn setTitle:@"评价" forState:UIControlStateNormal];
                
                [giveBtn addTarget:self action:@selector(commentOrder) forControlEvents:UIControlEventTouchDown];
                
            }else if (self.model.status == commented){
                cancelOrderBtn.hidden = YES;
                giveBtn.hidden = YES;
                
            }
            else {
                
                cancelOrderBtn.hidden = YES;
                giveBtn.hidden = YES;
              
                
            }
            
            return cell;
        }
 
    
       return 0;
}
#pragma mark --- UITableViewDelegate,datasoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        if (section == 2){
            
            return self.goodsArray.count;
        }
        else {
            return 1;
        }

   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        
        return 5;
    }else{
        
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.01;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            
            return 70;
        }else if (indexPath.section == 1){
            
            return 121;
        } else if (indexPath.section ==2){
            
            return 105;
        } else if (indexPath.section ==3){
            
            return 170;
        } else if (indexPath.section ==4){
            
            return 80;
        }

    }else{
        
        return 40;
    }
       return 0;
}

#pragma mark ---确认收货
-(void)sureRecevieGoods{
    
    UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认收货" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    alterView.tag = buttonTag + 3;
    
    [alterView show];
   
}
-(void)sureReeciveGoodsData{
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param =  [NSMutableDictionary dictionary];
    param[@"orderId"] =self.model.id;
    
    [self POST:OnloneConfirmRecepUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sureReceive" object:nil];
            
            [weakself.navigationController popViewControllerAnimated:YES];
            
        }
    } failure:^(NSError *error) {
        
        
    }];
}
#pragma  mark ---退货
-(void)backGoodsMoney{
    
    if (self.model.status == waitSend) {
        UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否退款" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        
        alterView.tag = buttonTag + 2;
        
        [alterView show];
    }else{
        UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否退货" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        
        alterView.tag = buttonTag + 4;
        
        [alterView show];
    }
   
}
#pragma mark --- 填写物流
-(void)writeTransport{
    
    BackGoodsTransportController * transPortVC = [[BackGoodsTransportController alloc] init];
    transPortVC.orderId = self.model.id;
    
    [self.navigationController pushViewController:transPortVC animated:YES];
    
}
#pragma mark ---提醒发货
-(void)giveMessage{
    
    
}
#pragma mark ----再次支付
-(void)payAgain{
    
    
    CGFloat totalMoney = 0;
    
    totalMoney = self.model.price;
   
    UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
    myOrderVC.orderPrice =[NSString stringWithFormat:@"%.1f", totalMoney];
    myOrderVC.sendFee = self.model.freight;
    //订单类型，线上订单
    myOrderVC.orderType = 1;
    
    if (self.model.couponmoeny > 0 || self.model.redpacketmoeny > 0) {
        myOrderVC.type = 0;
        myOrderVC.redpacketmoeny = self.model.redpacketmoeny;
        myOrderVC.couponmoeny = self.model.couponmoeny;
        myOrderVC.isUseCoupon = YES;
    } else {
        myOrderVC.type = 0;
    }
        
    myOrderVC.orderId = self.model.id;
    //订单号
    myOrderVC.orderNumber = self.model.order_sn;

    [self.navigationController pushViewController:myOrderVC animated:YES];
   
}
-(void)paySendFee{
    qucklySendViewController * qucklyVC = [[qucklySendViewController alloc] init];
    
    qucklyVC.shopCarNumber = self.model.count;
    
    qucklyVC.orderId= self.model.id;
    
    qucklyVC.orderSn = self.model.order_sn;
    
    qucklyVC.price = [NSString stringWithFormat:@"%.1f", self.model.freight];;
    //快递支付
    qucklyVC.sendType = 1;
    
    //线上线下
    qucklyVC.payType = 1;
    
    qucklyVC.ordertType = 1;
    
    [self.navigationController pushViewController:qucklyVC animated:YES];
}
#pragma mark ---删除订单
-(void)deleteOrder{
    
    UIAlertView * alter =[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    alter.tag = buttonTag +1;
    [alter show];
    
}
-(void)deleteOrderData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = self.model.id;
    //线上订单
    param[@"type"] = @"3";
    
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
#pragma mark ---取消订单
-(void)cancelOrder{
    
    UIAlertView * alter =[[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alter.tag = buttonTag ;
    
    [alter show];
    
}
-(void)cancelOrderData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = self.model.id;
    
    [self POST:appCancellationOfOrderUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            [weakself showStaus:@"取消订单成功"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrderOK" object:nil];
                
                [weakself.navigationController popViewControllerAnimated:YES];
                
            });
            
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ----UIAlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [SVProgressHUD setStatus:@"请稍等"];
        if (alertView.tag == buttonTag ) {
            
            [self cancelOrderData];
            
        }else if (alertView.tag == buttonTag + 1){
            
            [self deleteOrderData];
            
        }else if (alertView.tag == buttonTag +2){
            
            [self backGoodsMoneyData];
            
        }else if(alertView.tag == buttonTag + 3){
            
            [self sureReeciveGoodsData];
            
        }else{
            
            [self backGoodsMoneyData];
        }
        
    }
}
#pragma mark ---申请退款
-(void)backGoodsMoneyData{
    
    BackOnlineOrderController * backOrderVC =[[BackOnlineOrderController alloc] init];
    
    
    
    backOrderVC.orderId = self.model.id;
    
    if (self.model.status == waitSend) {
        
        //退款
        backOrderVC.orderType = 1;
        
        backOrderVC.backPriceValue = self.model.price;

        
    }else{
        //退货
        backOrderVC.orderType = 2;
        
        backOrderVC.backPriceValue = self.model.price -self.model.freight;

    }

    [self.navigationController pushViewController:backOrderVC animated:YES];
}

#pragma mark ---查看快递
//退货物流
-(void)checkReturenQueck{
    
    CheckTransportationController* checkTransVC =[[CheckTransportationController alloc] init];
    
    checkTransVC.inergralId = self.model.id;
    //线上订单
    checkTransVC.orderType = 1;
    
    checkTransVC.requestUrl = ReturnGoodskuaidiUrl;
    
    [self.navigationController pushViewController:checkTransVC animated:NO];
}
-(void)checkQueuk{
    
    CheckTransportationController* checkTransVC =[[CheckTransportationController alloc] init];
    
    checkTransVC.inergralId = self.model.id;
    //线上订单
    checkTransVC.orderType = 1;
    
    checkTransVC.requestUrl = appOrderFormKuaidi_detailUrl;
    
    [self.navigationController pushViewController:checkTransVC animated:NO];

}
#pragma mark ---评论订单
-(void)commentOrder{
    
    OrderCommentsController * orderCommentsVC =[[OrderCommentsController alloc] init];
  
    orderCommentsVC.goodsArray =[NSMutableArray arrayWithArray:self.goodsArray];
    orderCommentsVC.storeName = self.model.storeName;
    orderCommentsVC.storeLogo = self.model.storeLogo;
    orderCommentsVC.goodsId = self.model.id;
    
    [self.navigationController pushViewController:orderCommentsVC animated:YES];
    
}

@end

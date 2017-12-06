//
//  MyOrderDetailViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "RecievePlaceTableViewCell.h"
#import "OrderNumberTableViewCell.h"
#import "OrderDerailTableViewCell.h"
#import "SendWayandPayWayTableViewCell.h"
#import "CovertGradeAndQueueSendTableViewCell.h"
#import "convertDetailModel.h"
#import "intergralGoodsModel.h"
#import "CovertGoodsViewController.h"
#import "CheckTransportationController.h"
//#import "qucklySendViewController.h"
#import "CashPayViewController.h"
#import "WriteOrderViewController.h"
#import "ConvertVCViewController.h"

#import "ReadPayViewController.h"
NSString * const recivePlaceInderfer2 = @"RecievePlaceTableViewCell";
NSString * const orderDetailIndertifer2 = @"OrderDerailTableViewCell";
NSString * const sendWayandPayInderfier = @"SendWayandPayWayTableViewCell";
NSString * const covertGradeAndQueIndertifer = @"CovertGradeAndQueueSendTableViewCell";
@interface MyOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong)NSMutableArray * dataArray;

@property (nonatomic ,strong)Address * pickModel;

@property (nonatomic ,strong)Goods * goodsModel;

@property (nonatomic ,assign)NSInteger transportType;

@property (nonatomic ,strong)UITableView * orderTableView;

@end

@implementation MyOrderDetailViewController{
    
    convertDetailModel * _convertDetailModel;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //数据请求
    [self creatOrderTableView];

    
    [self requestData];
    
    
    [self creatNavgationBar];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MTA trackPageViewBegin:@"MyOrderDetailViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MyOrderDetailViewController"];
}
-(void)requestData{
    
    [self.view addSubview:[EaseLoadingView defalutManager]];
    [[EaseLoadingView defalutManager] startLoading];
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"id"]= self.goodID;
    
    [weakself POST:self.requestUrl parameters:param success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"][@"integralGoods"];
  
            _convertDetailModel = [convertDetailModel yy_modelWithDictionary:responseObject[@"result"]];
            
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[intergralGoodsModel class] json:array];
            //商品模型
            if (array.count) {
                
                weakself.goodsModel = [Goods yy_modelWithDictionary:array[0][@"Goods"]];
            }
            //快递方式
            weakself.transportType = _convertDetailModel.transport;
            
            if (weakself.transportType == 1) {
                //快递
                weakself.pickModel = [Address yy_modelWithDictionary:responseObject[@"result"][@"address"]];
            }else{
                //自提
                weakself.pickModel = [Address yy_modelWithDictionary:responseObject[@"result"][@"address"]];
            }
            
            
            weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.orderTableView reloadData];
                
            });
            
        }
        
 
        
    } failure:^(NSError *error) {
  
        [[EaseLoadingView defalutManager] stopLoading];
 
    }];
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"兑换订单详情"];
    
    [self addBackBarButtonItem];
}

- (void)backAction{
    if ([_backString isEqualToString:@"NotPayYet"]) {
        for(UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[ConvertVCViewController  class]] || [controller isKindOfClass:[CovertGoodsViewController  class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)creatOrderTableView{
    
    _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_orderTableView];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    //设置tab的section间距
    _orderTableView.sectionFooterHeight = 5 ;
    _orderTableView.sectionHeaderHeight = 5;
    
    [_orderTableView registerNib:[UINib nibWithNibName:@"RecievePlaceTableViewCell" bundle:nil] forCellReuseIdentifier:recivePlaceInderfer2];
 
     [_orderTableView registerNib:[UINib nibWithNibName:@"OrderDerailTableViewCell" bundle:nil] forCellReuseIdentifier:orderDetailIndertifer2];
     [_orderTableView registerNib:[UINib nibWithNibName:@"SendWayandPayWayTableViewCell" bundle:nil] forCellReuseIdentifier:sendWayandPayInderfier];
     [_orderTableView registerNib:[UINib nibWithNibName:@"CovertGradeAndQueueSendTableViewCell" bundle:nil] forCellReuseIdentifier:covertGradeAndQueIndertifer];
}

#pragma mark ---tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {

        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 60, 40)];
        label.text =[NSString stringWithFormat:@"兑换订单号:%@", _convertDetailModel.orderSn];
        
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        [cell.contentView addSubview:label];
        
        
        //时间戳转时间
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyyMMdd"];
        [format setDateStyle:NSDateFormatterMediumStyle];
        [format setTimeStyle:NSDateFormatterShortStyle];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:_convertDetailModel.orderCreateTime/1000.f];
        NSString * dateStr = [format stringFromDate:date];
        
        UILabel * orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, ScreenW, 20)];
        orderTimeLabel.textColor = [UIColor blackColor];
        orderTimeLabel.font = [UIFont systemFontOfSize:14];
        orderTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",dateStr];
        [cell.contentView addSubview:orderTimeLabel];
        
        return cell;
    }else if (indexPath.section == 1){

        RecievePlaceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:recivePlaceInderfer2 forIndexPath:indexPath];

        cell.selectionStyle = NO;
        cell.nextAcotBtn.hidden = YES;
        cell.NameLabel.text =[NSString stringWithFormat:@"收货人:%@",self.pickModel.name];
        cell.phoneNumberLabel.text = self.pickModel.mobile;
        
        cell.receivePlaceLbael.text = self.pickModel.address;
        return cell;
        
    } else if (indexPath.section == 2){
        
        OrderDerailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:orderDetailIndertifer2 forIndexPath:indexPath];

        intergralGoodsModel * model = self.dataArray[indexPath.row];
        cell.model = model;
        return cell;
    }else if (indexPath.section ==3 ){
        
        SendWayandPayWayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sendWayandPayInderfier forIndexPath:indexPath];
        cell.selectionStyle = NO;
        /*
         序号    返回值可能性    说明
         1    cash    现金
         2    no_fee    未支付
         3    balance    余额
         4    Weixin    微信
         5    alipay    支付宝
         6    null    空(未支付)
         */
        if ([_convertDetailModel.payType isEqualToString:@"cash"]) {
            cell.payType.text = @"积分+现金";
        } else if ([_convertDetailModel.payType isEqualToString:@"no_fee"]) {
            cell.payType.text = @"未支付";
        } else if ([_convertDetailModel.payType isEqualToString:@"balance"]) {
            cell.payType.text = @"积分+余额";
        } else if ([_convertDetailModel.payType isEqualToString:@"Weixin"]) {
            cell.payType.text = @"积分+微信";
        } else if ([_convertDetailModel.payType isEqualToString:@"alipay"]) {
            cell.payType.text = @"积分+支付宝";
        } else if ([_convertDetailModel.payType isEqualToString:@"null"]) {
            cell.payType.text = @"未支付";
        } else {
            cell.payType.text = @"积分支付";
        }
        
        if (_convertDetailModel.transport == 1) {
            
            cell.sendWayBtn.selected = YES;
            
        }else if(_convertDetailModel.transport == 2){
            
            cell.selfSendBtn.selected = YES;
        }
     
        return cell;
        
    } else if (indexPath.section ==4){
        
        CovertGradeAndQueueSendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:covertGradeAndQueIndertifer forIndexPath:indexPath];
        cell.selectionStyle = NO;
        cell.model = _convertDetailModel;

        [cell.checkTransportBtn addTarget:self action:@selector(jumpTransport) forControlEvents:UIControlEventTouchDown];
        [cell.sureRecieveGoodsBtn addTarget:self action:@selector(sureRecevieGoods) forControlEvents:UIControlEventTouchDown];
        [cell.payQuklyFeeBtn addTarget:self action:@selector(payQueklyFee) forControlEvents:UIControlEventTouchDown];
        
        [cell.payOrderBtn addTarget:self action:@selector(PayConvertAgain) forControlEvents:UIControlEventTouchDown];
        
        [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchDown];

        [cell.deleteOrderBtn addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchDown];
        return cell;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

   if (section == 2){
       
        return self.dataArray.count;
    }
    else {
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.01;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section == 1){
        return 121;
    } else if (indexPath.section ==2){
        return 105;
    } else if (indexPath.section ==3){
        return 132;
    } else if (indexPath.section ==4){
        return 144;
    }
    return 0;
}
#pragma mark ----跳转到物流
-(void)jumpTransport{
    
    CheckTransportationController* checkTransVC =[[CheckTransportationController alloc] init];
    checkTransVC.inergralId =[NSString stringWithFormat:@"%ld",_convertDetailModel.orderId];
    [self.navigationController pushViewController:checkTransVC animated:NO];
    
}
#pragma mark ---确认收货
-(void)sureRecevieGoods{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary * param =  [NSMutableDictionary dictionary];
        param[@"orderId"] = [NSString stringWithFormat:@"%ld",_convertDetailModel.orderId];
        
        [self POST:confirmRecepUrl parameters:param success:^(id responseObject) {
            
            NSString * str = responseObject[@"isSucc"];
            if ([str integerValue] == 1) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sureReceive" object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self showStaus:responseObject[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
#pragma mark ----再次支付
-(void)PayConvertAgain{
    
    ReadPayViewController * readPayVC =[[ReadPayViewController alloc] init];
    //购物车被兑换的数量
    readPayVC.shopCarNumber = self.dataArray.count;
    
    //从哪儿进入的订单方式
    readPayVC.categoryType = 2;
    
    if (_convertDetailModel.transport == 1) {
        //快递
        readPayVC.sendType = 1;
        //交流困难，自己计算本地的购物车数量
        
        //订单类型，兑换订单
        readPayVC.orderType = 3;
        readPayVC.sendPriceValue =[NSString stringWithFormat:@"%.2f", _convertDetailModel.trans_fee];
        readPayVC.orderId =[NSString stringWithFormat:@"%ld", _convertDetailModel.orderId];
        readPayVC.integral =[NSString stringWithFormat:@"%ld", _convertDetailModel.totalIntegral];
        readPayVC.order_sn = _convertDetailModel.orderSn;
        readPayVC.price = [NSString stringWithFormat:@"%.2f",_convertDetailModel.totalCash];
        
        [self.navigationController pushViewController:readPayVC animated:YES];
        
        
    }else if (_convertDetailModel.transport == 2){
        //自提
        readPayVC.sendType = 2;
        //订单类型,兑换订单
        readPayVC.orderType = 3;

        readPayVC.orderId =[NSString stringWithFormat:@"%ld", _convertDetailModel.orderId];
        readPayVC.integral =[NSString stringWithFormat:@"%ld", _convertDetailModel.totalIntegral];
        readPayVC.price = [NSString stringWithFormat:@"%.2f",_convertDetailModel.totalCash];
        readPayVC.order_sn = _convertDetailModel.orderSn;
        

        [self.navigationController pushViewController:readPayVC animated:YES];
        
    }
    
    
}
#pragma mark----删除订单
-(void)deleteOrder{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = [NSString stringWithFormat:@"%ld",_convertDetailModel.orderId];
    //兑换订单
    //1，删除面对面订单，2删除兑换订单，3删除线上，4删除线下
    param[@"type"] = @"2";
    
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
#pragma mark --- 支付快递费
-(void)payQueklyFee{
    
//    qucklySendViewController * quklyVC =[[qucklySendViewController alloc] init];
//    //快递
//    quklyVC.sendType = 1;
//    //交流困难，自己计算本地的购物车数量
//    
//    quklyVC.price = [NSString stringWithFormat:@"%.2f", _convertDetailModel.trans_fee];
//    
//    quklyVC.shopCarNumber = _convertDetailModel.integralGoods.count;
//
//    quklyVC.orderId = [NSString stringWithFormat:@"%ld", _convertDetailModel.orderId];
//    quklyVC.intergralPoint = [NSString stringWithFormat:@"%ld",_convertDetailModel.totalIntegral];;
//    
//    quklyVC.orderSn = _convertDetailModel.orderSn;
//    
//    [self.navigationController pushViewController:quklyVC animated:YES];
    CashPayViewController *cashPayVC = [[CashPayViewController alloc] init];
    
    cashPayVC.sendType = 1;
    
    cashPayVC.ordertType = 2;
    
    cashPayVC.sendPrice = [NSString stringWithFormat:@"%.2f",_convertDetailModel.trans_fee];
    cashPayVC.cash = [NSString stringWithFormat:@"%.2f",_convertDetailModel.totalCash];
    
    cashPayVC.shopCarNumber = _convertDetailModel.integralGoods.count;
    
    cashPayVC.orderId = [NSString stringWithFormat:@"%ld", _convertDetailModel.orderId];
    
    cashPayVC.intergralPoint = [NSString stringWithFormat:@"%.2f",_convertDetailModel.totalCash+_convertDetailModel.trans_fee];;
    
    cashPayVC.orderSn = _convertDetailModel.orderSn;
    
    [self.navigationController pushViewController:cashPayVC animated:YES];
    
}
#pragma mark----取消订单
-(void)cancelOrder{
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"id"] =[NSString stringWithFormat:@"%ld", _convertDetailModel.orderId];
    [self POST:cancelFace2FaceUrl parameters:param success:^(id responseObject) {
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
    intergralGoodsModel * model = self.dataArray[indexPath.row];

        [User defalutManager].selectedGoodsID =[NSString stringWithFormat:@"%ld", (long)model.goods.id];
        
        CovertGoodsViewController * convertGoodsVC =[[CovertGoodsViewController alloc] init];
        
        [self.navigationController pushViewController:convertGoodsVC animated:YES];
    }
}
@end

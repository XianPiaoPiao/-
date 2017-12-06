//
//  GroupOrderDetilController.m
//  XuXin
//
//  Created by xuxin on 17/3/10.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "GroupOrderDetilController.h"
#import "OnlineOrderModel.h"
#import "OnlineGoodsModel.h"
#import "GoodsListTableViewCell.h"
#import "MyOrderTableViewController.h"
#import "SBMyOrderTableviewController.h"
#import "OrderCommentsController.h"
#import "InsetLabel.h"
#import "QrcodeModel.h"

#import "SaleQrcodeCell.h"

NSString * const groupGoodsCellInderfier = @"GoodsListTableViewCell";
NSString * const saleQrcodeInderfier = @"SaleQrcodeCell";

@interface GroupOrderDetilController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic ,strong)UITableView * orderTableView;
@property (nonatomic ,strong)OnlineOrderModel * model;

@property (nonatomic ,strong)NSMutableArray * goodsArray;
@property (nonatomic ,strong)NSMutableArray * counpArray;
@property (nonatomic ,strong)NSMutableArray * noUsedcounpArray;

@property (nonatomic ,strong)NSMutableArray * selectCounpArray;

@property (nonatomic ,copy)NSString * consumptionCode;

@property (nonatomic ,assign)NSInteger  isusedNumber;
@property (nonatomic ,assign)NSInteger  noUsedNumber;
@property (nonatomic ,assign)NSInteger  returnNumber;


@end

@implementation GroupOrderDetilController

-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}
-(NSMutableArray *)selectCounpArray{
    if (!_selectCounpArray) {
        
        _selectCounpArray = [[NSMutableArray alloc] init];
    }
    return _selectCounpArray;
}
-(NSMutableArray *)counpArray{
    if (!_counpArray) {
        _counpArray = [[NSMutableArray alloc] init];
    }
    return _counpArray;
}
-(NSMutableArray *)noUsedcounpArray{
    if (!_noUsedcounpArray) {
        _noUsedcounpArray = [[NSMutableArray alloc] init];
    }
    return _noUsedcounpArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self creatTableView];

    [self creatNavgationBar];
    
    
    [self requestData];
    
    [self requestNousedCounpData];
    
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"线下订单详情"];
    
    [self addBackBarButtonItem];
    
}
-(void)creatTableView
{
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH ) style:UITableViewStyleGrouped];
    
    [_tableView registerNib:[UINib nibWithNibName:@"GoodsListTableViewCell" bundle:nil] forCellReuseIdentifier:groupGoodsCellInderfier];
    
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
}
-(void)requestNousedCounpData{
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"]= self.goodsId;
    
    [weakself POST:findQRcodeUrl parameters:param success:^(id responseObject) {
        
        NSDictionary * dic = responseObject[@"result"];
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            
            NSArray * qrcodeArray = dic[@"qRcode"];
            NSArray * modelQrcodeArray = [NSArray yy_modelArrayWithClass:[QrcodeModel class] json:qrcodeArray];
            weakself.noUsedcounpArray = [NSMutableArray arrayWithArray:modelQrcodeArray];
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.orderTableView reloadData];
            
        });
    
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
-(void)requestData{
    
    [self.view addSubview:[EaseLoadingView defalutManager]];
    [[EaseLoadingView defalutManager] startLoading];
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"]= self.goodsId;
    
    [weakself POST:findOrderDetailsByIdUrl parameters:param success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            NSDictionary * dic = responseObject[@"result"];
            
            weakself.model  =[OnlineOrderModel yy_modelWithDictionary:dic];
            
           NSArray * array = dic[@"goods"];
           NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ONLINEgoodsModel class] json:array];
            
            weakself.goodsArray = [NSMutableArray arrayWithArray:modelArray];
            
            NSArray * qrcodeArray = dic[@"qRcode"];
            NSArray * modelQrcodeArray = [NSArray yy_modelArrayWithClass:[QrcodeModel class] json:qrcodeArray];
            weakself.counpArray = [NSMutableArray arrayWithArray:modelQrcodeArray];
            if (weakself.counpArray.count > 0) {
                
                weakself.consumptionCode = dic[@"qRcode"][0][@"consumptionCode"];
            }
        
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.tableView reloadData];
                
            });
        
        }
        
    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
    }];
}

#pragma mark ---界面布局
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _orderTableView) {
        
        SaleQrcodeCell * cell = [tableView dequeueReusableCellWithIdentifier:saleQrcodeInderfier forIndexPath:indexPath];
        
        cell.selectBtn.userInteractionEnabled = NO;

        
        QrcodeModel * model = self.noUsedcounpArray[indexPath.row];
        
        cell.saleNameLabel.text = [NSString stringWithFormat:@"劵码(%ld):%@",indexPath.row +1,model.consumptionCode];
        
        return cell;
        
    }else{
        if (indexPath.section == 0) {
            
            UITableViewCell * cell  = [[UITableViewCell alloc] init];
            cell.selectionStyle = NO;
            //下单时间
            //时间戳转时间
            NSDateFormatter * format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            [format setDateStyle:NSDateFormatterMediumStyle];
            [format setTimeStyle:NSDateFormatterShortStyle];
            
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.model.time/1000.f];
            NSString * dateStr = [format stringFromDate:date];
            
            NSArray * nameArray = @[@"订单号",@"手机号码",@"下单时间"];
            
            for (int i  = 0; i < 3; i++) {
                
                CGFloat lableH = 40;
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10,  i * lableH, ScreenW - 20, lableH)];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = [UIColor blackColor];
                //
                if (i== 0) {
                    
                    [label setText:[NSString stringWithFormat:@"%@:%@",nameArray[i], self.model.order_sn]];
                }else if (i == 1){
                    
                    [label setText:[NSString stringWithFormat:@"%@:%@",nameArray[i], self.model.mobile]];
                }else{
                    [label setText:[NSString stringWithFormat:@"%@:%@",nameArray[i], dateStr]];
                }
                
                [cell.contentView addSubview:label];
                //分割线
                UIView * sptString = [[UIView alloc] initWithFrame:CGRectMake(0, i * lableH , ScreenW, 1)];
                sptString.backgroundColor = [UIColor colorWithHexString:BackColor];
                
                [cell.contentView addSubview:sptString];
            }
            return cell;
        }else if (indexPath.section == 1){
            
            GoodsListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:groupGoodsCellInderfier forIndexPath:indexPath];
            cell.selectionStyle = NO;
            ONLINEgoodsModel * model = self.goodsArray[indexPath.row];
            
            [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
            
            cell.goodsNameLabel.text = model.goodsName;
            cell.numberLabel.text = [NSString stringWithFormat:@"数量:x%ld",model.count];
            cell.pointLabel.text= [NSString stringWithFormat:@"消费:￥%.1f",model.goodsPrice];
            //创建约束
            [ cell.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.goodsImageView.mas_right).offset(50) ;
                
            }];
            [ cell.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(cell.goodsImageView.mas_right).offset(50);
                
            }];
            [ cell.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.goodsImageView.mas_right).offset(50);
                
            }];
            
            return cell;
            
        }else if (indexPath.section ==2){
            
            UITableViewCell * cell =[[UITableViewCell alloc] init];
            
            cell.selectionStyle = NO;
            
            UILabel * orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 90, 30)];
            orderStatusLabel.font = [UIFont systemFontOfSize:15];
            orderStatusLabel.textColor = [UIColor blackColor];
            orderStatusLabel.text = @"订单状态:";
            
            UILabel * orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 110 , 5 ,100, 30)];
            orderLabel.textAlignment = 2;
            orderLabel.font = [UIFont systemFontOfSize:15];
            orderLabel.textColor = [UIColor colorWithHexString:WordColor];
            
            //订单状态
            if (self.model.status == cancelType) {
                
                orderLabel.text = @"已取消";
                
            }else if (self.model.status == waitPayType ){
                
                orderLabel.text = @"待付款";
                
            }else if (self.model.status == waitLinedType){
                
                orderLabel.text = @"线下支付待审核";
            }else if(self.model.status == haveUsedType){
                
                orderLabel.text = @"已使用";
                
            }else if (self.model.status == returnMoney){
                orderLabel.text = @"买家申请退款";
                
            }
           else if (self.model.status == returnMoneyType){
                
                orderLabel.text = @"已退款";
                
            }
          else if(self.model.status == sellerRejectGoods){
                orderLabel.text = @"卖家拒绝退货";
                
            }else if(self.model.status == regectFail){
                orderLabel.text = @"退货失败";
                
            }else if(self.model.status == commented){
                orderLabel.text = @"已评价";
                
            }else if(self.model.status == haveDone){
                orderLabel.text = @"已完成";
                
            }else if(self.model.status == compeleted){
                orderLabel.text = @"已结束";
                
            }else if (self.model.status == 20){
                
                orderLabel.text = @"已支付";

            }
            
            
            [cell.contentView addSubview:orderStatusLabel];
            [cell.contentView addSubview:orderLabel];
            
            
            for (int i = 0; i < self.counpArray.count; i++) {
                QrcodeModel * model = self.counpArray[i];
                //消费码
                UILabel * saleLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 50 + i * 40, 160, 30)];
                
                saleLabel.font = [UIFont systemFontOfSize:15];
                saleLabel.textColor = [UIColor colorWithHexString:WordColor];
                
                [cell.contentView addSubview:saleLabel];
                
                UILabel * saleStutesLabel =[[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 110, 50 + i * 40, 100, 30)];
                saleStutesLabel.textAlignment = 2;
                
                if (model.is_used == 1) {
                    
                    saleStutesLabel.text = @"已消费";
                    saleStutesLabel.textColor = [UIColor colorWithHexString:MainColor];

                }else  if (model.is_used == 0){
                    
                    saleStutesLabel.text = @"未消费";
                    saleStutesLabel.textColor = [UIColor colorWithHexString:@"#05b5ef"];
                }else{
                    
                    saleStutesLabel.text = @"已退款";
                    saleStutesLabel.textColor = [UIColor colorWithHexString:MainColor];
                }
                saleStutesLabel.font = [UIFont systemFontOfSize:15];
             
                
                [cell.contentView addSubview:saleStutesLabel];
                //分割线
                UIView * sptView = [[UIView alloc] initWithFrame:CGRectMake(0,45 + 40 * i, ScreenW, 1)];
                sptView.backgroundColor = [UIColor colorWithHexString:BackColor];
                [cell.contentView addSubview:sptView];
                
                saleLabel.text =[NSString stringWithFormat: @"消费码:  %@",model.consumptionCode];
            }
            
            return cell;
            
        }else{
            
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = NO;
            
            NSArray * array = @[@"支付方式",@"消费金额",@"红包折扣"];
            for (int i = 0; i< 3; i++) {
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + i * 40, 100, 20)];
                label.textColor = [UIColor blackColor];
                label.text = array[i];
                label.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:label];
            }
            //分割线
            for (int i = 0; i < 3; i++) {
                
                UIView * sptString = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * (i + 1), ScreenW, 1)];
                sptString.backgroundColor = [UIColor colorWithHexString:BackColor];
                [cell.contentView addSubview:sptString];
            }
            for (QrcodeModel * model in self.counpArray) {
                
                if (model.is_used == 1) {
                    
                    _isusedNumber++;
                    
                }else if (model.is_used == 0){
                    
                    _noUsedNumber ++;
                    
                }else{
                    
                    _returnNumber ++;
                    
                }
            }
            
            UILabel * payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 110, 10, 100, 20)];
            payTypeLabel.textAlignment = 2;
            payTypeLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:payTypeLabel];
            payTypeLabel.textColor = [UIColor colorWithHexString:MainColor];
            payTypeLabel.text = self.model.paymentMethod;
            //
            
            //消费金额
            UILabel * saleMoneyLable =[[UILabel alloc] initWithFrame:CGRectMake(60, 50, ScreenW - 70, 20)];
            saleMoneyLable.textAlignment = 2;
            saleMoneyLable.text = [NSString stringWithFormat:@"￥%.1f",self.model.price];
            saleMoneyLable.textColor = [UIColor colorWithHexString:MainColor];
            saleMoneyLable.textAlignment = 2;
            [cell.contentView addSubview:saleMoneyLable];
            saleMoneyLable.font = [UIFont systemFontOfSize:15];
            //红包折扣
            UILabel * redLabel =[[UILabel alloc] initWithFrame:CGRectMake(60, 90, ScreenW - 70, 20)];
            redLabel.textAlignment = 2;
            if (self.model.usedRedPacket == 0) {
                
                 redLabel.text = @"￥0";
            }else{
                
                redLabel.text = [NSString stringWithFormat:@"￥5"];
            }
           
            
            
            redLabel.textColor = [UIColor colorWithHexString:@"#05b5ef"];
            redLabel.textAlignment = 2;
            [cell.contentView addSubview:redLabel];
            redLabel.font = [UIFont systemFontOfSize:15];
            
            //
            UIButton * Btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 80, 125, 70, 30)];
            Btn.layer.cornerRadius = 3;
            
            Btn.backgroundColor = [UIColor colorWithHexString:MainColor];
            
            if (self.model.status == waitPayType) {
                
                [Btn setTitle:@"立即支付" forState:UIControlStateNormal];
                [Btn addTarget:self action:@selector(payGroupOrder) forControlEvents:UIControlEventTouchDown];
                
                //取消订单
                UIButton * cancelOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 160,125, 70, 30)];
                cancelOrderBtn.layer.cornerRadius = 3;
                cancelOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                
                cancelOrderBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
                [cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [cancelOrderBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchDown];
                [cell.contentView addSubview:cancelOrderBtn];
                
            }else if (self.model.status == cancelType){
                
                [Btn setTitle:@"删除订单" forState:UIControlStateNormal];
                [Btn addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchDown];
                
            }else if (self.model.status == commented){
                
                Btn.hidden = YES;
                
            }
            else{
                
                
                if (_noUsedNumber > 0) {
                    
                    Btn.hidden = YES;

                    
                }else{
                    
                    if (_isusedNumber > 0) {
                        
                        [Btn setTitle:@"评论" forState:UIControlStateNormal];
                        [Btn addTarget:self action:@selector(commentGroupOrder) forControlEvents:UIControlEventTouchDown];
                    }else{
                        
                        Btn.hidden = YES;

                    }
                   
                }
                
            }
         
            
            [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            Btn.titleLabel.font = [UIFont systemFontOfSize:14];
            
    //申请退款按钮
            UIButton * backMoneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 80, 125, 70, 30)];
            backMoneyBtn.layer.cornerRadius = 3;
            
            backMoneyBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            [backMoneyBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [backMoneyBtn addTarget:self action:@selector(backMoney) forControlEvents:UIControlEventTouchDown];
            
            [backMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
       
            // 不可以退款的情况
            if (self.model.status == waitPayType ||  self.model.status == returnMoneyType || self.model.status == cancelType  ) {
                backMoneyBtn.hidden = YES;
                // backMoneyBtn.backgroundColor = [UIColor colorWithHexString:WordLightColor];
                //  backMoneyBtn.userInteractionEnabled = NO;
            }
            
            if (_noUsedNumber == 0) {
                
                backMoneyBtn.hidden = YES;
                //   backMoneyBtn.backgroundColor = [UIColor colorWithHexString:WordLightColor];
                //    backMoneyBtn.userInteractionEnabled = NO;
            }
            
            
            backMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [cell.contentView addSubview:backMoneyBtn];
            

            [cell.contentView addSubview:Btn];
            
            
            return cell;
            
        }
    }
    
    return 0;
}
#pragma mark ---取消订单
-(void)cancelOrder{
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = buttonTag;
    
    [alertView show];
  

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
#pragma mark ----删除订单
-(void)deleteOrder{
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = buttonTag + 1;

    [alertView show];
    

}
-(void)deleteOrderData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = self.model.id;
    //线上订单
    //1，删除面对面订单，2删除兑换订单，3删除线上，4删除线下
    param[@"type"] = @"4";
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section == 1) {
            
            return self.goodsArray.count;
        }
        else{
            
            return 1;
            
        }
    }else{
        
        return self.noUsedcounpArray.count;
    }
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        
        return 4;
        
    }else{
        
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            
            return 120;
            
        }else if (indexPath.section == 1){
            
            return 120;
            
        }else if(indexPath.section == 2){
            
            return 45 + 40 * self.counpArray.count;
            
        }else{
            
            return 160;
        }

    }else{
        
        return 40;
    }
}
#pragma mark ---去评论
-(void)commentGroupOrder{
    
    OrderCommentsController * orderCommentsVC =[[OrderCommentsController alloc] init];
    orderCommentsVC.goodsArray = [NSMutableArray arrayWithArray:self.goodsArray];
    orderCommentsVC.storeName = self.model.storeName;
    orderCommentsVC.storeLogo = self.model.storeLogo;
    
    orderCommentsVC.goodsId = self.model.id;
    
    [self.navigationController pushViewController:orderCommentsVC animated:YES];
}
#pragma mark --去支付
-(void)payGroupOrder{
    
    CGFloat totalMoney = 0;
    
    totalMoney = self.model.price + self.model.freight;
    
    if (totalMoney >= 150 && [User defalutManager].redPacket > 0 ) {
        
        UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
        myOrderVC.orderPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
        //订单类型，线下订单
        myOrderVC.orderType = 2;
        
        myOrderVC.orderId = self.model.id;
        //订单号
        myOrderVC.orderNumber = self.model.order_sn;
        
        [self.navigationController pushViewController:myOrderVC animated:YES];
        
    }else{
        
        UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        SBMyOrderTableviewController * myOrderVC =  (SBMyOrderTableviewController *)[storybord instantiateViewControllerWithIdentifier:@"SBMyOrderTableviewController"];
        //订单类型，线下订单
        myOrderVC.orderType = 2;
        
        myOrderVC.orderPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
        myOrderVC.orderId =  self.model.id;
        //订单号
        myOrderVC.orderNumber =  self.model.order_sn;
        
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }

}
#pragma mark ---申请退款
-(void)backMoney{
    
    UIAlertView * alter =[[UIAlertView alloc] initWithTitle:@"提示" message:@"申请退款" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alter.tag = buttonTag + 2;
    [alter show];
}
#pragma mark ----UIAlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [SVProgressHUD setStatus:@"请稍等"];
        if (alertView.tag == buttonTag ) {
            
            [self cancelOrderData];
            
        }else if (alertView.tag == buttonTag + 1){

            [self deleteOrderData];
            
        }else{
            
            [self backGoodsMoney];

        }
        
    }
}
#pragma mark ----申请退款请求
#pragma mark ---申请退货
-(void)backGoodsMoney{
    
    UIView * bgView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH - 200)];
    bgView.tag = buttonTag + 10;
    
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self.view addSubview:bgView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBgView)];
    [bgView addGestureRecognizer:tapGesture];
    
    
    _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenH - 240 - 40, ScreenW, 240) style:UITableViewStylePlain];
    [_orderTableView registerNib:[UINib nibWithNibName:@"SaleQrcodeCell" bundle:nil] forCellReuseIdentifier:saleQrcodeInderfier];
    
    _orderTableView.backgroundColor = [UIColor whiteColor];
    _orderTableView.delegate = self;
    _orderTableView.dataSource =self;
    
    InsetLabel * headerLabel = [[InsetLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40) andInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    headerLabel.text = @"订单劵码(可多选)";
    headerLabel.font = [UIFont systemFontOfSize:15];
    _orderTableView.tableHeaderView = headerLabel;
    
    
    UIButton * sureBackMoneyBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, screenH - 50, ScreenW , 50)];
    sureBackMoneyBtn.tag = buttonTag + 20;
    [sureBackMoneyBtn setTitle:@"确认退款" forState:UIControlStateNormal];
    [sureBackMoneyBtn addTarget:self action:@selector(sureBackMoney) forControlEvents:UIControlEventTouchDown];
    
    [sureBackMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBackMoneyBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    sureBackMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:_orderTableView];
    
    [self.view addSubview:sureBackMoneyBtn];
    
    [self requestNousedCounpData];
    
}
//移除背景图
-(void)removeBgView{
    
    UIView * bgView = [self.view viewWithTag:buttonTag + 10];
    UIButton * btn = [self.view viewWithTag:buttonTag + 20];
    
    [btn removeFromSuperview];
    [_orderTableView removeFromSuperview];
    
    [bgView removeFromSuperview];
}

-(void)sureBackMoney{
    
    NSMutableString * selectstring = [NSMutableString string];
    
    if (self.selectCounpArray.count > 0) {
        
        __weak typeof(self)weakself = self;
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for (NSString * str in self.selectCounpArray) {
            
            [selectstring appendFormat:@"%@,",str];
        }
        
        [selectstring deleteCharactersInRange:NSMakeRange(selectstring.length -1, 1)];
        
        param[@"orderId"] = self.model.id;
        
        param[@"qRcodeId"] = selectstring;
        
        [self POST:appLineApplyForRefundUrl parameters:param success:^(id responseObject) {
            
            NSString * str = responseObject[@"isSucc"];
            if ([str integerValue] == 1) {
                
                [weakself showStaus:@"申请退款成功"];
                
                [self.selectCounpArray removeAllObjects];
                
                [self removeBgView];
                
                [self requestData];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        
        [self showStaus:@"请选择劵码"];
    }
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _orderTableView) {
        
        SaleQrcodeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        QrcodeModel * model = self.noUsedcounpArray[indexPath.row];
        
        if (model.isSelected == YES) {
            
            model.isSelected = NO;
            cell.selectBtn.selected = NO;
            
            [self.selectCounpArray removeObject:model.codeId];
            
            
        }else{
            
            model.isSelected = YES;

            cell.selectBtn.selected = YES;
            
            [self.selectCounpArray addObject:model.codeId];

        }

    }
    //  self.counpArray[indexPath.row];

}
@end

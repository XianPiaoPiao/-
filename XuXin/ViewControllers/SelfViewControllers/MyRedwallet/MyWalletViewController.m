//
//  MyWalletViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletTableViewCell.h"
#import "BalanceDetailViewController.h"
#import "CordChargeViewController.h"
#import "BalanceTrueViewController.h"
#import "MyCardTableViewCell.h"
#import "MyBankCardViewController.h"
#import "MyWalleetModel.h"
#import "HtmWalletPaytypeController.h"
#import "BalanceDetailController.h"
NSString * const myWalletIndetrfier = @"MyWalletTableViewCell";
NSString * const myCardTableIndertifer = @"MyCardTableViewCell";
@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyWalletViewController{
    
    MyWalleetModel * _model;
    UITableView * _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"MyWalletViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MyWalletViewController"];
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self creatTableView];
    
    [self requestData];
    
    //预充值成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    //添加银行卡数据同步
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"addCard" object:nil];

}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self addNavgationTitle:@"我的钱包"];
    [self addBackBarButtonItem];
}
-(void)refreshData{
    
    [self requestData];
}

-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----数据请求
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    
    [weakself POST:myWalletUrl parameters:nil success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            _model = [[MyWalleetModel alloc] init];
            _model  = [MyWalleetModel yy_modelWithDictionary:responseObject[@"result"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
            
        }
        

    } failure:^(NSError *error) {
        

    }];

}
-(void)creatTableView{
    
   _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    //设置间隔
    _tableView.sectionFooterHeight = 5;
    _tableView.sectionHeaderHeight = 5;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MyWalletTableViewCell" bundle:nil] forCellReuseIdentifier:myWalletIndetrfier];
    [_tableView registerNib:[UINib nibWithNibName:@"MyCardTableViewCell" bundle:nil] forCellReuseIdentifier:myCardTableIndertifer];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    } else{
          return 136;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {

        MyCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCardTableIndertifer forIndexPath:indexPath];
        cell.numberLabel.text =[NSString stringWithFormat:@"%ld个", _model.bankCardCount];
        return cell;
    }else if (indexPath.section == 1) {
        
        MyWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myWalletIndetrfier forIndexPath:indexPath];
                cell.userInteractionEnabled = YES;
        [cell.HDImageView setImage:[UIImage imageNamed:@"sjiao-01"]];
        cell.DetailBtn.backgroundColor = [UIColor colorWithHexString:@"ABB967"];
        cell.DetailBtn.tag = buttonTag;

        cell.RechargeBtn.backgroundColor = [UIColor colorWithHexString:@"ABB967"];
        cell.BalanceLabel.textColor = [UIColor colorWithHexString:@"ABB967"];
        cell.BalanceLabel.text = [NSString stringWithFormat:@"%.2f",_model.shopcoin];
        [User defalutManager].preDeposit = _model.shopcoin;
        [cell.DetailBtn addTarget:self action:@selector(JumpDetaillVC:) forControlEvents:UIControlEventTouchDown];
        [cell.RechargeBtn addTarget:self action:@selector(jumpChargeVC) forControlEvents:UIControlEventTouchDown];
        //预充值说明
        [cell.explainBtn addTarget:self action:@selector(SupendExpalin) forControlEvents:UIControlEventTouchDown];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
     
        return cell;
          } else if (indexPath.section ==2){
        MyWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myWalletIndetrfier forIndexPath:indexPath];
              cell.userInteractionEnabled = YES;

              //余额说明
              [cell.explainBtn setTitle:@"余额说明" forState:UIControlStateNormal];
              [cell.explainBtn addTarget:self action:@selector(BalanceExplain) forControlEvents:UIControlEventTouchDown];
       [cell.HDImageView setImage:[UIImage imageNamed:@"sjiao-02"]];
        cell.PayforLabel.text = @"余额";
        cell.BalanceLabel.text =[NSString stringWithFormat:@"%.2f",_model.availableBalance];
        //给个人余额赋值
        [User defalutManager].balance = _model.availableBalance;
              
        [cell.RechargeBtn  setTitle:@"提款" forState:UIControlStateNormal];

        [cell.RechargeBtn addTarget:self action:@selector(junmTrueVC) forControlEvents:UIControlEventTouchDown];
              cell.DetailBtn.tag = buttonTag + 1;
    
        [cell.DetailBtn addTarget:self action:@selector(JumpDetaillVC:) forControlEvents:UIControlEventTouchDown];
        cell.detailTextLabel.text = @"明细";
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    } else if (indexPath.section == 3){
        
        MyWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myWalletIndetrfier forIndexPath:indexPath];
        [cell.DetailBtn addTarget:self action:@selector(JumpDetaillVC:) forControlEvents:UIControlEventTouchDown];
        //积分说明
        [cell.explainBtn addTarget:self action:@selector(IntergralExplain) forControlEvents:UIControlEventTouchDown];
        cell.DetailBtn.tag = buttonTag + 2;
        [cell.HDImageView setImage:[UIImage imageNamed:@"sjiao-03"]];
        
        //隐藏按钮
        cell.RechargeBtn.hidden = YES;
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.DetailBtn.backgroundColor = [UIColor colorWithHexString:@"#f29800"];
        
        cell.BalanceLabel.textColor = [UIColor colorWithHexString:@"#f29800"];
        cell.PayforLabel.text = @"积分";
        cell.BalanceLabel.text = [NSString stringWithFormat:@"%ld",_model.integral];
        [User defalutManager].integral = _model.integral;
        
        [cell.explainBtn setTitle:@"积分说明" forState:UIControlStateNormal];
        cell.detailTextLabel.text = @"明细";
        return cell;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        MyBankCardViewController * mybankCardVC = [[MyBankCardViewController alloc] init];
        [self.navigationController pushViewController:mybankCardVC animated:YES];
    }
}

//预充值说明
-(void)SupendExpalin{
    
    HtmWalletPaytypeController * htmWalletVC =[[HtmWalletPaytypeController alloc] init];
    htmWalletVC.requestUrl = Pre_depositHtmUrl;
    htmWalletVC.htmlType = supendHtmlType;
    
    [self.navigationController pushViewController:htmWalletVC animated:YES];
}
//余额说明
-(void)BalanceExplain{
    HtmWalletPaytypeController * htmWalletVC =[[HtmWalletPaytypeController alloc] init];
    htmWalletVC.requestUrl = walletBalanceHtmUrl;
    htmWalletVC.htmlType = balaceHtmlType;
    [self.navigationController pushViewController:htmWalletVC animated:YES];
}
//积分说明
-(void)IntergralExplain{
    HtmWalletPaytypeController * htmWalletVC =[[HtmWalletPaytypeController alloc] init];
    htmWalletVC.htmlType = pointHtmlType;

    htmWalletVC.requestUrl = intergarlHtmUrl;

    [self.navigationController pushViewController:htmWalletVC animated:YES];
}

//明细
-(void)JumpDetaillVC:(UIButton *)sender{
    //预存款
    if (sender.tag == buttonTag) {
        BalanceDetailViewController * chargeVC =[[BalanceDetailViewController alloc] init];
          chargeVC.requestUrl = chargeListUrl;
        chargeVC.payType = 1;
        [self.navigationController pushViewController:chargeVC animated:YES];
    }else if (sender.tag == buttonTag + 1){
        //余额明细
        BalanceDetailController * balanceVC =[[BalanceDetailController alloc] init];

        [self.navigationController pushViewController:balanceVC animated:YES];
    }else{
        
        BalanceDetailViewController * chargeVC =[[BalanceDetailViewController alloc] init];
          chargeVC.requestUrl = listIntegralUrl;
          chargeVC.payType = 3;

       [self.navigationController pushViewController:chargeVC animated:YES];
    }

}
//预充值
-(void)jumpChargeVC{
    
    CordChargeViewController * balanceVC = [[CordChargeViewController alloc] init];

    [self.navigationController pushViewController:balanceVC animated:YES];
}
//提现
-(void)junmTrueVC{
    BalanceTrueViewController * balanceVC =[[ BalanceTrueViewController alloc] init];
    balanceVC.balabceNumber =[NSString stringWithFormat:@"%.2f",_model.availableBalance];
    [self.navigationController pushViewController:balanceVC animated:YES];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

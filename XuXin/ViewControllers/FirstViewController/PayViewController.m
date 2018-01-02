//
//  PayViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/17.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "PayViewController.h"
#import "MyOrderTableViewController.h"
#import "ZenKeyboard.h"
#import "PayExplainViewController.h"
#import "SBMyOrderTableviewController.h"

@interface PayViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *storeAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *storesNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *PayButton;
@property (nonatomic ,strong)NSMutableArray * dataArray;
@end

@implementation PayViewController{
    UITextField * _priceTextfield;
    ZenKeyboard * _keyboardView;

}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    self.navigationController.navigationBarHidden = NO;
    
    [MTA trackPageViewBegin:@"PayViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"PayViewController"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self createTextFiled];
  
}

-(void)creatNavgationBar{
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self addNavgationTitle:@"支付订单"];
    [self addBackBarButtonItem];
    
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]
                      initWithTitle:@"买单说明" style:UIBarButtonItemStylePlain target:self action:@selector(Explain)];
    [btn setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    btn.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = btn;
  
}

#pragma --输入价格判断，只能为数字
-(void) createTextFiled {

    //确认按钮
    self.PayButton.layer.cornerRadius = 25;
    self.PayButton.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.PayButton addTarget:self action:@selector(surePayAction) forControlEvents:UIControlEventTouchUpInside];
    
    _priceTextfield = [[UITextField alloc] initWithFrame:CGRectMake(0,84, ScreenW   , 50)];
    _priceTextfield.delegate = self;
    _priceTextfield.backgroundColor = [UIColor whiteColor];
    _keyboardView =[[ZenKeyboard alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 216)];
    _keyboardView.backgroundColor = [UIColor whiteColor];
    _keyboardView.textField = _priceTextfield;
    _priceTextfield.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_priceTextfield];
    
    [_priceTextfield setKeyboardType:UIKeyboardTypeNumberPad];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,100, 20)];
     label.textAlignment = 1;
     label.text = @"消费金额:";
    [label setTextColor:[UIColor blackColor]];
    [_priceTextfield setLeftView:label];
    [label setFont:[UIFont systemFontOfSize:15]];
    
    _priceTextfield.leftViewMode = UITextFieldViewModeAlways;
    _priceTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_priceTextfield setPlaceholder:@"输入到店消费金额"];
    
    //

}

//买单说明
-(void)Explain{
    
    PayExplainViewController * payExplainVC = [[PayExplainViewController alloc] init];
    [self.navigationController pushViewController:payExplainVC animated:YES];
}
- (void)ReturnAction:(id)sender {
    
 [self.navigationController popViewControllerAnimated:YES];
  
    
}
- (void)viewDidUnload {
    _keyboardView = nil;
    _priceTextfield = nil;
    [super viewDidUnload];
}
//确认支付
- (void)surePayAction {
 
    BOOL ret = [self isPureFloat:_priceTextfield.text];
    if (_priceTextfield.text.length && ret ==YES )  {
      
        [SVProgressHUD showWithStatus:@"正在生成订单"];
        [self requestData];
    }
}

- (void)jumpToNextVC{
    UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
    myOrderVC.orderPrice =_priceTextfield.text;
    myOrderVC.factPrice = _priceTextfield.text;
    //订单类型,面对面
    myOrderVC.orderType = 3;
    myOrderVC.type = 1;//面对面
    
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

#pragma 数据请求
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"storeId"] = [User defalutManager].selectedShop;
 
    param[@"price"] =[NSString stringWithFormat:@"%.2f",[_priceTextfield.text floatValue]];
    
   [weakself POST:faceOrderUrl parameters:param success:^(id responseObject) {
       
       int i = [responseObject[@"isSucc"] floatValue];
       
       if (i == 1) {
           
           NSString * orderOk = responseObject[@"result"][@"order_sn"];
           NSString * orderId = responseObject[@"result"][@"order_id"];
           //    创建通知===以下条件反
        
           UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
           
           MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
           myOrderVC.orderPrice =_priceTextfield.text;
           myOrderVC.factPrice =_priceTextfield.text;
           myOrderVC.orderId = orderId;
//               myOrderVC.storecartId = sto
           //订单号
           myOrderVC.orderNumber = orderOk;
           
           //订单类型,面对面
           myOrderVC.orderType = 3;
           myOrderVC.type = 1;//面对面
           
           [self.navigationController pushViewController:myOrderVC animated:YES];
           
       }
       

   } failure:^(NSError *error) {
       

   }];

}

//判断只能是数字
- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [_priceTextfield becomeFirstResponder];
}

@end

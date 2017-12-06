//
//  AddBankCardViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "BankListViewController.h"
#import "SendVerificationcodeController.h"
@interface AddBankCardViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberFelid;
@property (weak, nonatomic) IBOutlet UITextField *bankNumberFelid;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *peopleCardTexField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNUmberTexetField;
@property (nonatomic ,copy)NSString * bankid;
@end

@implementation AddBankCardViewController{
    UIAlertView * _returnAlterView;
    NSTimer * _showRepeatBttonTimer;
    NSTimer * _updateTime; //更新倒计时label
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initTextField];
    
    [self creatNavgationBar];
}
-(void)initTextField{
    //初始化控件
    _nextStepBtn.layer.cornerRadius = 6;
    
    _agreeBtn.selected = YES;
    _nextStepBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [_agreeBtn addTarget:self action:@selector(argreeAction) forControlEvents:UIControlEventTouchDown];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
    label.textAlignment = 1;
    label.text = @"账   号";
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    
    self.cardNumberFelid.leftViewMode = UITextFieldViewModeAlways;
    self.cardNumberFelid.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.cardNumberFelid.backgroundColor =[UIColor whiteColor];
    
    [self.cardNumberFelid setPlaceholder:@"请输入账号"];
    self.cardNumberFelid.leftView = label;
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
    label2.textAlignment = 1;
    label2.text = @"提款方式";
    [label2 setTextColor:[UIColor blackColor]];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    self.bankNumberFelid.leftViewMode = UITextFieldViewModeAlways;
    self.bankNumberFelid.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.bankNumberFelid.backgroundColor = [UIColor whiteColor];
    [self.bankNumberFelid setPlaceholder:@"请选择提款方式"];
    self.bankNumberFelid.delegate = self;
    self.bankNumberFelid.leftView = label2;
    
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
    label3.textAlignment = 1;
    label3.text = @"姓   名";
    [label3 setTextColor:[UIColor blackColor]];
    [label3 setFont:[UIFont systemFontOfSize:15]];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.nameTextField setPlaceholder:@"持卡人姓名"];
    self.nameTextField.leftView = label3;
    self.nameTextField.delegate = self;
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    
    UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
    label4.textAlignment = 1;
    label4.text = @"身份证";
    [label4 setTextColor:[UIColor blackColor]];
    [label4 setFont:[UIFont systemFontOfSize:15]];
    self.peopleCardTexField.leftViewMode = UITextFieldViewModeAlways;
    self.peopleCardTexField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.peopleCardTexField.delegate = self;
    [self.peopleCardTexField setPlaceholder:@"持卡人身份证"];
    self.peopleCardTexField.leftView = label4;
    self.peopleCardTexField.backgroundColor = [UIColor whiteColor];

    
}
-(void)creatNavgationBar{
  
    [self addNavgationTitle:@"添加提款账号"];
    [self addBarButtonItemWithTitle:@"返回" image:[UIImage imageNamed:@"fanhui"] target:self action:@selector(returnAction) isLeft:YES];
  //  [self addBackBarButtonItem];
}
-(void)returnAction{
    
    _returnAlterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否退出编辑" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [_returnAlterView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _returnAlterView) {
        
        if (buttonIndex == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
  
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    

    if (textField == self.bankNumberFelid) {

        
        [self.peopleCardTexField resignFirstResponder];
        [self.phoneNUmberTexetField resignFirstResponder];
        [self.nameTextField resignFirstResponder];
        
        BankListViewController * bankListVC = [[BankListViewController alloc] init];
        
        bankListVC.block = ^(BankListModel * model){
            
            _bankid = [NSString stringWithFormat:@"%ld",model.id];
            self.bankNumberFelid.text = model.name;
        };
        
        [self.navigationController pushViewController:bankListVC animated:YES];


    }
    else if (textField == self.peopleCardTexField){
        
        [UIView animateWithDuration:0.6 animations:^{
            self.view.frame = CGRectMake(0, -120, ScreenW, screenH - 120);
        }];
        
    }else if (textField == self.phoneNUmberTexetField){
        [UIView animateWithDuration:0.6 animations:^{
            self.view.frame = CGRectMake(0, -120, ScreenW, screenH - 120);
        }];
    }else{
        
        [UIView animateWithDuration:0.6 animations:^{
            self.view.frame = CGRectMake(0, 0, ScreenW, screenH );
        }];
    }

}
- (IBAction)nextStpeAction:(id)sender {
    
    if (_agreeBtn.selected == NO) {
       
        [self showStaus:@"请同意用户服务协议"];
     
    }else if(_peopleCardTexField.text.length == 0){
       
       [self showStaus:@"输入的身份证不能为空"];
       
   }
    else if (_cardNumberFelid.text.length == 0){
       
       [self showStaus:@"输入卡号不能为空"];

   }else if (_nameTextField.text.length == 0){
       
       [self showStaus:@"请输入名字"];

   }
   else{
       
       [self requestAddCardData];

    }
}
#pragma mark --- 添加银行卡请求
-(void)requestAddCardData{
    
    SendVerificationcodeController * sendVerifyVC = [[SendVerificationcodeController alloc] init];
    sendVerifyVC.phone = [User defalutManager].userName;
    sendVerifyVC.bankId = _bankid;
    sendVerifyVC.bankCardNumber = _cardNumberFelid.text;
    sendVerifyVC.trueName = _nameTextField.text;
    sendVerifyVC.iDCard = _peopleCardTexField.text;
    
    [self.navigationController pushViewController:sendVerifyVC animated:YES];
   }
-(void)argreeAction{
    
     if (_agreeBtn.selected == YES) {
    _agreeBtn.selected = NO;
    _nextStepBtn.backgroundColor = [UIColor grayColor];
}else{
    _agreeBtn.selected = YES;
    _nextStepBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
}
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.6 animations:^{
        self.view.frame = CGRectMake(0, 0, ScreenW, screenH );
    }];
    [self.view endEditing:YES];
}
@end

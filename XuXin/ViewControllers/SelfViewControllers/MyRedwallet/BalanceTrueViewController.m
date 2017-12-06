//
//  BalanceTrueViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BalanceTrueViewController.h"
#import "SelectBankCardController.h"
#import "ForgetScretViewController.h"
#import "BalanceDetailController.h"
#import "MyBankModel.h"
#import "ChangePayPasswordViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface BalanceTrueViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *VCScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *addBankCardView;

@end

@implementation BalanceTrueViewController{
  
    UITextField * _priceValueField;
    UITextField * _secretField;
    UIAlertView * _completAlterView;
    UILabel * _balabceLabel;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self creatUI];
    //给银行卡添加手势
    UITapGestureRecognizer * tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(junmpAddCardVC:)];
    [self.addBankCardView addGestureRecognizer:tapgesture];
    //密码模式
    _secretField.secureTextEntry = YES;
}
-(void)creatUI{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, ScreenW, 150)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.VCScrollView addSubview:backView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenW, 30)];
    label.text = @"提款金额";
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    [backView addSubview:label];
    
    _priceValueField = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 50)];
    _priceValueField.placeholder = @"请输入提款金额";
    _priceValueField.font = [UIFont systemFontOfSize:15];
    _priceValueField.backgroundColor = [UIColor whiteColor];
    [backView addSubview:_priceValueField];
    //创建左视图
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 50)];
    leftLabel.textAlignment = 1;
    leftLabel.text = @"￥";
    [leftLabel setTextColor:[UIColor blackColor]];
    [leftLabel setFont:[UIFont systemFontOfSize:20]];
  
    [_priceValueField setKeyboardType: UIKeyboardTypeDecimalPad];
    _priceValueField.leftViewMode = UITextFieldViewModeAlways;
    _priceValueField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _priceValueField.leftView = leftLabel;
    
    UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenW, 1)];
    seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [backView addSubview:seperateView];
    
    _balabceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 111, ScreenW -100, 30)];
    _balabceLabel.text = [NSString stringWithFormat:@"可用余额￥%@",_balabceNumber];
    _balabceLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:_balabceLabel];
    
    UIButton * allTrueBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW -100, 111, 100, 30)];
    [allTrueBtn setTitle:@"全部提款" forState:UIControlStateNormal];
    allTrueBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [allTrueBtn setTitleColor:[UIColor colorWithHexString:@"#107cee"] forState:UIControlStateNormal];
    [backView addSubview:allTrueBtn];
    [allTrueBtn addTarget:self action:@selector(allTure) forControlEvents:UIControlEventTouchDown];
    
    _secretField = [[UITextField alloc] initWithFrame:CGRectMake(0, 230, ScreenW, 50)];
    _secretField.backgroundColor = [UIColor whiteColor];
    UILabel * leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
    leftLabel2.textAlignment = 1;
    
    leftLabel2.text = @"密码";
    [leftLabel2 setTextColor:[UIColor blackColor]];
    [leftLabel2 setFont:[UIFont systemFontOfSize:16]];
    
  //  [_secretField setKeyboardType: UIKeyboardTypePhonePad];
    _secretField.leftViewMode = UITextFieldViewModeAlways;
    _secretField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _secretField.leftView = leftLabel2;
    [_secretField setPlaceholder:@"请输入支付密码"];
    _secretField.font = [UIFont systemFontOfSize:15];
    [self.VCScrollView addSubview:_secretField];
    
    UIButton * balanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 285, 100, 50)];
    [self.VCScrollView addSubview:balanceBtn];
    [balanceBtn setTitle:@"余额明细" forState:UIControlStateNormal];
    [balanceBtn addTarget:self action:@selector(balanceDetail) forControlEvents:UIControlEventTouchDown];
    
    balanceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [balanceBtn setTitleColor:[UIColor colorWithHexString:@"107cee"] forState:UIControlStateNormal];
    
    UIButton * forgetPasswordBtn  = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 120 , 285, 120, 50)];
    [self.VCScrollView addSubview:forgetPasswordBtn];
    forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetPasswordBtn setTitle:@"忘记支付密码?" forState:UIControlStateNormal];
    [forgetPasswordBtn  addTarget:self action:@selector(jumpForgetPassWord) forControlEvents:UIControlEventTouchDown];
    
    [forgetPasswordBtn setTitleColor:[UIColor colorWithHexString:@"107cee"] forState:UIControlStateNormal];
    
    UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 340, ScreenW - 20, 50)];
    sureBtn.layer.cornerRadius = 25;
    [self.VCScrollView addSubview:sureBtn];
    sureBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [sureBtn addTarget:self action:@selector(creatBalanceOrder) forControlEvents:UIControlEventTouchDown];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.VCScrollView.delegate = self;
}
#pragma mark  ---创建余额提现订单
-(void)creatBalanceOrder{
    
    if (_priceValueField.text.length && _secretField.text.length) {
        
        [self creatOrderData];

    }else{
        
        [self showStaus:@"请填写完整资料"];
    }
}
//全部提现
-(void)allTure{
    
    _priceValueField.text = _balabceNumber;
}
-(void)balanceDetail{
    
    BalanceDetailController * balanceVC =[[BalanceDetailController alloc] init];
    [self.navigationController pushViewController:balanceVC animated:YES];
}
//忘记密码
-(void)jumpForgetPassWord{
    
    
    ChangePayPasswordViewController * passWordVC = [[ChangePayPasswordViewController alloc] init];
    
    passWordVC.type = changePasswordType;
    
    [self.navigationController pushViewController:passWordVC animated:YES];
    
}
-(void)creatOrderData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"amount"] = _priceValueField.text;
    if (_balabceNumber != nil) {
        
        param[@"bindBankCardId"] = _bankID;

    }
    param[@"payPwd"] =_secretField.text;
    //提现到银行卡
    param[@"payment"] = @"5";
    
    [weakself POST:createGetCrashOrderUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [self showStaus:@"申请提款成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
            
            // 1秒钟之后跳转
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        }

    } failure:^(NSError *error) {
        
    }];
  
}
//添加银行卡
-(void)junmpAddCardVC:(UITapGestureRecognizer *)gesture{
    
    SelectBankCardController * selectBankVC = [[SelectBankCardController alloc] init];
    selectBankVC.block = ^(MyBankModel * model){
        
        for (UIView * view in self.addBankCardView.subviews) {
            [view removeFromSuperview];
        }
        _bankID =[NSString stringWithFormat:@"%ld", model.id];
        UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.bank.logoPath] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 30)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = model.bank.name;
        
        UILabel * cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 200, 20)];
        
        if (model.id == 11) {
            
            cardLabel.text =[NSString stringWithFormat:@"**** **** **** %@",model.bankCard];
            
        }else{
            
            if ([model.bankCard containsString:@"@"] == YES) {
                
                NSArray * array = [model.bankCard componentsSeparatedByString:@"@"];
                NSString * str2 = array[array.count - 1];
                
                NSString * str = array[0];
                NSString * fstr =  [str substringWithRange:NSMakeRange(0, 1)];
                NSString * endStr = [str substringWithRange:NSMakeRange(str.length - 1, 1)];
                cardLabel.text =[NSString stringWithFormat:@"%@ **** **** %@@%@",fstr,endStr,str2];
                
                
            }else{
                NSString * str = [model.bankCard substringWithRange:NSMakeRange(0, 3)];
                NSString * str2= [model.bankCard substringWithRange:NSMakeRange(model.bankCard.length - 4, 4)];
                
                cardLabel.text =[NSString stringWithFormat:@"%@ **** %@",str,str2];
                
            }
        }
        cardLabel.font = [UIFont systemFontOfSize:15];
        
        UIImageView * nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 15, 25, 10, 10)];
        [nextImageView setImage:[UIImage imageNamed:@"icon-right-arrow.png"]];
        
        [self.addBankCardView addSubview:cardLabel];
        [self.addBankCardView addSubview:nameLabel];
        [self.addBankCardView addSubview:imageView];
        [self.addBankCardView addSubview:nextImageView];
    };
    [self.navigationController pushViewController:selectBankVC animated:YES];
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"余额提款"];
    [self addBackBarButtonItem];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _completAlterView) {
        if (buttonIndex == 0) {
            
 
        }
    }
 
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

@end

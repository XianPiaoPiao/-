//
//  VoucherViewController.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "VoucherViewController.h"
#import "InputView.h"
#import "SearchTheStoreViewController.h"

#define TextFieldTag 100
@interface VoucherViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic ,copy)NSString * storeId;

@end

@implementation VoucherViewController{
    UITextField * _textField1;
    UITextField * _textField2;
    UITextField * _textField3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self creatUI];

}
-(void)creatUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];

   //    创建界面主要内容
    [self creatMainConttent];
    
}


- (void)creatMainConttent{
    
    //  输入框1
    InputView * inputView1 =[InputView loadInputView];
    
    inputView1.textFiled.tag = TextFieldTag + 1;
    
    _textField1 = inputView1.textFiled;
    inputView1.textFiled.delegate = self;
    
    inputView1.frame = CGRectMake( 0,64 + 26 * HalfOfScreenScale ,ScreenW, 100 * HalfOfScreenScale);
    
    [inputView1 setTitle:@"商家" placeHolder:@"请输入商家名" hasSearchButton:YES];
    [inputView1.textFiled setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:inputView1];
    
//    inputView2
    InputView * inputView2 =[InputView loadInputView];
    inputView2.textFiled.tag = TextFieldTag + 2;
    
    _textField2 = inputView2.textFiled;
    _textField2.delegate = self;
    
    CGFloat inputView1bottom = CGRectGetMaxY(inputView1.frame);
    CGFloat marginH = 24 * HalfOfScreenScale;

    inputView2.frame = CGRectMake( 0,inputView1bottom + marginH ,ScreenW , 100 * HalfOfScreenScale);
    
    [inputView2 setTitle:@"编号" placeHolder:@"请输入排队报销劵序号" hasSearchButton:NO];
    [inputView2.textFiled setReturnKeyType:UIReturnKeyNext];
    
    [self.view addSubview:inputView2];
    
//    inputView3
    InputView * inputView3 =[InputView loadInputView];
    inputView3.textFiled.tag = TextFieldTag + 3;
    _textField3 = inputView3.textFiled;
    _textField3.delegate = self;
    
    CGFloat inputView2bottom = CGRectGetMaxY(inputView2.frame);
 
    inputView3.frame = CGRectMake( 0 ,inputView2bottom + marginH ,ScreenW , 100 * HalfOfScreenScale);
    [inputView3 setTitle:@"密码" placeHolder:@"请输入排队报销劵密码" hasSearchButton:NO];
    [self.view addSubview:inputView3];
    
    
//    提交按钮
    UIButton * uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(inputView3.frame) + 2* marginH, ScreenW - 20, 100 * HalfOfScreenScale)];
    uploadButton.backgroundColor = [UIColor colorWithHexString:MainColor];
    
    [uploadButton setTitle:@"提交排队" forState:UIControlStateNormal];
    [uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(uploadAction) forControlEvents:UIControlEventTouchDown];
    uploadButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    uploadButton.layer.masksToBounds = YES;
    uploadButton.layer.cornerRadius = 25;
    
    [self.view addSubview:uploadButton];
    
    
}
#pragma mark --- 开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _textField1) {
        SearchTheStoreViewController * searchStoreVC = [[SearchTheStoreViewController alloc] init];
        searchStoreVC.block = ^(NSString * str,NSString * str2){
            _textField1.text = str;
            _storeId = str2;
        };
        [self.navigationController pushViewController:searchStoreVC animated:YES];
        [self.view endEditing:YES];

    }
}
//提交排队
-(void)uploadAction{
    
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"正在录入..."];
    [self requestUploadData];
    
}
#pragma mark ----查询劵
-(void)requestUploadData{
    
    __weak typeof(self)weakself= self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"merchant_id"] = _storeId;
    param[@"cardPwd"] = _textField3.text;
    param[@"cardName"] = _textField2.text;
    
    [weakself POST:addCouponUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            [self showStaus:@"录入成功"];
            //清空
            _textField1.text = @"";
            _textField2.text = @"";
            _textField3.text = @"";
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addCouponSuccess" object:nil];
                
            });
           
            
        }

    } failure:^(NSError *error) {
        
        
    }];


}
//收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

@end

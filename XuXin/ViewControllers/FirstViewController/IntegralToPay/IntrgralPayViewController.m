//
//  IntrgralPayViewController.m
//  XuXin
//
//  Created by xian on 2017/11/6.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "IntrgralPayViewController.h"
#import "IntegralStoreView.h"
#import "CheckVoucherViewController.h"
#import "IntrgralPayWayViewController.h"
#import "ChangePayPasswordViewController.h"
#import "VoucherModel.h"
#import "MyOrderBaseViewController.h"

@interface IntrgralPayViewController ()

@property (nonatomic, strong) UILabel *integralLabel;

@property (nonatomic, strong) IntegralStoreView *storeView;

@property (nonatomic, strong) UIButton *forgetPwdBtn;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) CheckVoucherViewController *checkVC;

@property (nonatomic, copy) NSMutableArray *voucherArray;
@property (nonatomic, copy) NSMutableArray *selectedArray;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *integral;

@end

@implementation IntrgralPayViewController

- (NSMutableArray *)voucherArray{
    if (!_voucherArray) {
        _voucherArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _voucherArray;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    
    [self createUI];
    
    [self requestData];
}

- (void)requestData{
    __weak typeof(self)weakself= self;
    [weakself POST:userGetOrderUrl parameters:@{@"id":_ID} success:^(id responseObject) {
        int str = [responseObject[@"isSucc"] intValue];
        if (str == 1) {
            
            _price = responseObject[@"result"][@"price"];
            _integral = responseObject[@"result"][@"integral"];
            self.integralLabel.text = [NSString stringWithFormat:@"%@",_integral];
            self.storeView.orderCodeLbl.text = responseObject[@"result"][@"order_sn"];
            self.storeView.totalDetailLbl.text = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"user_integral"]];
            
            NSArray * array = responseObject[@"result"][@"coupon"];
            for (NSDictionary *dic in array) {
                VoucherModel *model = [VoucherModel new];
                model.card_name = dic[@"card_name"];
                model.value = dic[@"value"];
                model.ID = dic[@"id"];
                model.num = dic[@"num"];
                
                [weakself.voucherArray addObject:model];
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"voucherArrayChange" object:nil userInfo:@{@"array":weakself.voucherArray}];
        } else {
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
//
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//
//                [self.navigationController popToRootViewControllerAnimated:YES];
//
//            });
            
        }
    } failure:^(NSError *error) {

    }];
    
}

- (void)createNavBar{
    [self addNavgationTitle:@"积分支付"];
    
    [self addBackBarButtonItem];
}

- (void)createUI{
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:BackColor]];
    
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(KNAV_TOOL_HEIGHT);
        make.size.sizeOffset(CGSizeMake(ScreenW, 80));
    }];
    
    UILabel *firstLabel = [UILabel new];
    firstLabel.text = @"付款积分";
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.textColor = [UIColor colorWithHexString:WordLightColor];
    firstLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.integralLabel.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(ScreenW, 30));
    }];
    
    
    [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(firstLabel.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(ScreenW, 185));
    }];
    
    [self.storeView.usevoucherBtn addTarget:self action:@selector(clickSelectVoucherBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.storeView.mas_bottom).offset(15);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.forgetPwdBtn addTarget:self action:@selector(jumpForgetVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
//        make.top.equalTo(self.forgetPwdBtn.mas_bottom).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-self.TabbarHeight);
        make.size.sizeOffset(CGSizeMake(ScreenW-20, 40));
    }];
    
    [self.sureBtn addTarget:self action:@selector(jumpToNextVC) forControlEvents:UIControlEventTouchUpInside];
    
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor colorWithHexString:WordColor alpha:0.5];
    [self.view addSubview:_bgView];
    _bgView.hidden = YES;
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH/2, ScreenW, screenH/2)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    _checkVC = [[CheckVoucherViewController alloc] init];
    _checkVC.ID = _ID;
	__weak typeof(self)weakself= self;
    _checkVC.cancelBtnBlock = ^(BOOL flag) {
        weakself.contentView.hidden = YES;
        weakself.bgView.hidden = YES;
    };
    
    _checkVC.sureBtnBlock = ^(NSMutableArray *selectedArray) {
        if (weakself.selectedArray.count > 0) {
            [weakself.selectedArray removeAllObjects];
        }
        [weakself.selectedArray addObjectsFromArray:selectedArray];
        
        weakself.contentView.hidden = YES;
        weakself.bgView.hidden = YES;
    };
    
    [self addChildViewController:_checkVC];
    
    
    
    [self.contentView addSubview:_checkVC.view];
    self.contentView.hidden = YES;
}

- (void)clickSelectVoucherBtn{
    
    self.bgView.hidden = NO;
    self.contentView.hidden = NO;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.storeView.pwdTxt resignFirstResponder];
}

- (void)jumpToNextVC{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"id"] = _ID;
    dic[@"password"] = self.storeView.pwdTxt.text;
    NSMutableString * couponIds = [NSMutableString string];
    
    for (int i = 0; i< weakself.selectedArray.count; i++) {
        
        
        VoucherModel * model = weakself.selectedArray[i];
        
        [couponIds appendString:[NSString stringWithFormat:@"%@,",model.ID]];
        
    }
    
    //拼接字符串
    if (couponIds.length) {
        
        [couponIds deleteCharactersInRange:NSMakeRange([couponIds length]-1, 1)];
        dic[@"couponIds"] = couponIds;
    }
    
    [weakself POST:paymentPointsUrl parameters:dic success:^(id responseObject) {
        if ([responseObject[@"isSucc"] intValue] == 1) {
            NSInteger price = [responseObject[@"result"][@"price"] integerValue];
            if (price > 0) {
                IntrgralPayWayViewController *paywayVC = [[IntrgralPayWayViewController alloc] init];
                paywayVC.orderId = responseObject[@"result"][@"order_id"];
                paywayVC.price = responseObject[@"result"][@"price"];
                [self.navigationController pushViewController:paywayVC animated:YES];
            } else {
                MyOrderBaseViewController * myorderVC =[[MyOrderBaseViewController alloc] init];
                
                myorderVC.ordrType = 4;
                [self.navigationController pushViewController:myorderVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark -----忘记支付密码
-(void)jumpForgetVC{
    
    ChangePayPasswordViewController * passWordVC = [[ChangePayPasswordViewController alloc] init];
    
    passWordVC.type = changePasswordType;
    
    [self.navigationController pushViewController:passWordVC animated:YES];
}

#pragma mark initUI
- (UILabel *)integralLabel{
    if (!_integralLabel) {
        _integralLabel = [UILabel new];
        _integralLabel.font = [UIFont systemFontOfSize:35.0f];
        _integralLabel.textColor = [UIColor colorWithHexString:MainColor];
        _integralLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_integralLabel];
    }
    return _integralLabel;
}

- (IntegralStoreView *)storeView{
    if (!_storeView) {
        _storeView = [[IntegralStoreView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_storeView];
    }
    return _storeView;
}

- (UIButton *)forgetPwdBtn{
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton new];
        [_forgetPwdBtn setTitle:@"忘记支付密码?" forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [_forgetPwdBtn setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
        
        [self.view addSubview:_forgetPwdBtn];
    }
    return _forgetPwdBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[UIColor colorWithHexString:MainColor]];
        _sureBtn.layer.cornerRadius = 24.0f;
        _sureBtn.layer.masksToBounds = YES;
        [self.view addSubview:_sureBtn];
    }
    return _sureBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

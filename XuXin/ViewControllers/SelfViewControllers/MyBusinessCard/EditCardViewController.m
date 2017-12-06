//
//  EditCardViewController.m
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "EditCardViewController.h"

@interface EditCardViewController ()

@end

@implementation EditCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavigationBar];
    
    [self createUI];
    
    if (_editType == updateType) {
        [self requestData];
    }
    
}

-(void)creatNavigationBar{
    
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor colorWithHexString:MainColor];
    self.navigationController.navigationBarHidden = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:@"编辑名片"];
    [navBgView addSubview:label];
    
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+self.StatusBarHeight, 60, 30)];
    [returnButton setImage:[UIImage imageNamed:@"sign_in_fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    [navBgView addSubview:returnButton];
    
}

- (void)createUI{
    [self.view setBackgroundColor:[UIColor colorWithHexString:BackColor]];
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH)];
    bgView.contentSize = CGSizeMake(ScreenW, screenH+230);
    [self.view addSubview:bgView];
    
    UITapGestureRecognizer *tapGr =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    NSArray *array = @[@"姓名",@"电话",@"公司",@"职位",@"邮箱",@"地址",@"网址"];
    for (int i = 0; i < array.count; i ++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:view];
        [bgView addSubview:view];
        
        UILabel *lbl = [[UILabel alloc] init];
        [view addSubview:lbl];
        lbl.text = array[i];
        
        UITextField *txtF = [[UITextField alloc] init];
        txtF.tag = 100+i;
        [view addSubview:txtF];
        if (i<4) {
            txtF.placeholder = @"必填";
        }else {
            txtF.placeholder = [NSString stringWithFormat:@"请输入%@",array[i]];
        }
        if (i != 3 && i != 6) {
            UILabel *line = [UILabel new];
            line.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0f];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.bottom.equalTo(view.mas_bottom);
                make.size.sizeOffset(CGSizeMake(ScreenW, 1));
            }];
        }
        
        if (i>3) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
//                make.top.equalTo(self.view.mas_top).offset(84+i*50);
                make.top.equalTo(bgView.mas_top).offset(20+i*50);//84+50+300+20
                make.size.sizeOffset(CGSizeMake(ScreenW, 50));
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
//                make.top.equalTo(self.view.mas_top).offset(74+i*50);
                make.top.equalTo(bgView.mas_top).offset(10+i*50);
                make.size.sizeOffset(CGSizeMake(ScreenW, 50));
            }];
        }
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(10);
            make.size.sizeOffset(CGSizeMake(60, 30));
        }];
        
        [txtF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(lbl.mas_right).offset(10);
            make.size.sizeOffset(CGSizeMake(ScreenW-100, 30));
        }];
        
    }
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 25;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setBackgroundColor:[UIColor colorWithHexString:MainColor]];
    sureBtn.titleLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(bgView.mas_top).offset(430);
        make.size.sizeOffset(CGSizeMake(ScreenW-40, 50));
    }];
}

-(void)returnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    for (int i=100; i<107; i++) {
        UITextField *textField = [self.view viewWithTag:i];
        [textField resignFirstResponder];
    }
}

- (void)requestData{
    __weak typeof(self)weakself = self;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = _cardId;
    [weakself POST:findMyUserCardUrl parameters:paramDic success:^(id responseObject) {
        if ([responseObject[@"isSucc"] integerValue] == 1) {
            NSDictionary *dic = responseObject[@"result"];
            for (int i=100; i<107; i++) {
                UITextField *textField = [self.view viewWithTag:i];
                switch (i) {
                    case 100:
                        textField.text = dic[@"username"];
                        break;
                    case 101:
                        textField.text = dic[@"mobile"];
                        break;
                    case 102:
                        textField.text = dic[@"company"];
                        break;
                    case 103:
                        textField.text = dic[@"job"];
                        break;
                    case 104:
                        textField.text = dic[@"email"];
                        break;
                    case 105:
                        textField.text = dic[@"addr"];
                        break;
                    case 106:
                        textField.text = dic[@"web"];
                        break;
                        
                    default:
                        break;
                }
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)sure{
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i=100; i<107; i++) {
        UITextField *textField = [self.view viewWithTag:i];
        if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            [self showStaus:@"请填写完整的个人信息"];
            return;
        } else {
            [array addObject:textField.text];
        }
    }
    __weak typeof(self)weakself = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"username"] = array[0];
    NSString *mobile = array[1];
    if (mobile.length != 11) {
        
        [self showStaus:@"请输入格式正确的电话号码"];
        return;
    }
    dic[@"mobile"] = array[1];
    dic[@"company"] = array[2];
    dic[@"job"] = array[3];
    dic[@"email"] = array[4];
    dic[@"addr"] = array[5];
    dic[@"web"] = array[6];
    if (_editType == updateType) {
        dic[@"id"] = _cardId;
    }
    [weakself POST:saveUserCardUrl parameters:dic success:^(id responseObject) {
        NSInteger str = [responseObject[@"isSucc"] integerValue];
        if (str == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserCard" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
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

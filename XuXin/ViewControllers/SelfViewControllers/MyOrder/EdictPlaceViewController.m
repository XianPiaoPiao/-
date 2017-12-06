//
//  EdictPlaceViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "EdictPlaceViewController.h"
#import "InputView.h"
#import "ChooseLocationView.h"
#import "receivePlaceModel.h"
#import "XuXinField.h"
#import "AddressItemModel.h"
@interface EdictPlaceViewController ()<NSURLSessionDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *SavePlaceBtn;
@property (weak, nonatomic) IBOutlet UILabel *placeShowLabel;
@property (strong, nonatomic)  UITextField *userNameTextField;
@property (strong, nonatomic)  UITextField *detailAdress;

@property (weak, nonatomic) IBOutlet UILabel *selectedAdress;


@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (nonatomic, strong)ChooseLocationView *chooseLocationView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,copy)NSString * areaID;
@property (nonatomic ,strong)NSMutableArray * cityDataArray;
@end

@implementation EdictPlaceViewController{
    UITableView * _selectPlaceTableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)cityDataArray{
    if (!_cityDataArray) {
        _cityDataArray = [[NSMutableArray alloc] init];
    }
    return _cityDataArray;
}
-(ChooseLocationView *)chooseLocationView{
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc] init];
    }
    return _chooseLocationView;
}
-(receivePlaceModel * )model{
    if (!_model) {
        _model = [[receivePlaceModel alloc] init];
    }
    return _model;
}
- (UIView *)coverView{
    
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
        [_coverView addSubview:_chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseAddressFinish = ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                weakSelf.placeShowLabel.text =[NSString stringWithFormat:@"收货地址:%@",weakSelf.chooseLocationView.address];
                weakSelf.view.transform = CGAffineTransformIdentity;
                weakSelf.coverView.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_coverView addGestureRecognizer:tap];
        tap.delegate = self;
        _coverView.hidden = YES;
    }
    return _coverView;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (CGRectContainsPoint(_chooseLocationView.frame, point)) {
        
        return NO;
    }
    return YES;
}
- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    if (_chooseLocationView.chooseAddressFinish) {
        _chooseLocationView.chooseAddressFinish();
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
 
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fuzhi:) name:@"areaId" object:nil];
    //
    [self creatUI];
    //判断是编辑还是新增收货地址
    if (self.placeType == 1) {
        
        self.requestUrl = addAddressUrl;
        
    } else if (self.placeType == 2){
        
        _areaID =[NSString stringWithFormat:@"%ld",self.model.area_id];
        self.userNameTextField.text = self.model.trueName;
        self.phoneNumberTextField.text = self.model.mobile;
        self.placeShowLabel.text =[NSString stringWithFormat:@"收货地址:%@", self.model.area];
         self.detailAdress.text =[NSString stringWithFormat:@"%@",self.model.area_info];
        self.requestUrl = updateAddressUrl;
        
    }
    //设置url
   // self.requestUrl = addAddressUrl;
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    [self creatNavagationBar];
    //设置windows的背景颜色
    //设置btn圆角
    self.SavePlaceBtn.layer.cornerRadius = 20;
    //
    _selectPlaceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenH, ScreenW, 200) style:UITableViewStyleGrouped];
    [self.view addSubview:_selectPlaceTableView];
    
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SelectActionAnnimate:)];
    [self.SelectPlaceView addGestureRecognizer:tap];
}

//通知方法
-(void)fuzhi:(NSNotification *)cation{
    
    _areaID = cation.userInfo[@"textOne"];
}
//
-(void)creatNavagationBar{
    
    
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    UIButton * returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 34+self.StatusBarHeight, 70, 16)];
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:8];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];

    [navBgView addSubview:returnBtn];
    [returnBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    
    
    UILabel  * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 26+self.StatusBarHeight, ScreenW - 102, 32)];
    titleLabel.text = @"编辑地址";
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [navBgView addSubview:titleLabel];

    
}
-(void)creatUI{
    //创建左视图
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 40)];
    label.textAlignment = 1;
    label.text = @"收货人:";
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 40)];
    label2.textAlignment = 2;
    label2.text = @"联系方式:";
    [label2 setTextColor:[UIColor blackColor]];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 40)];
    label3.textAlignment = 2;
    label3.text = @"详细地址:";
    [label3 setTextColor:[UIColor blackColor]];
    [label3 setFont:[UIFont systemFontOfSize:15]];
    
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 124+self.StatusBarHeight, ScreenW, 40)];
    
    [self.phoneNumberTextField setKeyboardType: UIKeyboardTypePhonePad];

    self.phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumberTextField.font = [UIFont systemFontOfSize:15];
    self.phoneNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneNumberTextField.leftView = label2;
    self.phoneNumberTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.phoneNumberTextField];
    
    self.detailAdress = [[UITextField alloc] initWithFrame:CGRectMake(0, 224+self.StatusBarHeight, ScreenW, 40)];
    self.detailAdress.font = [UIFont systemFontOfSize:15];
    self.detailAdress.leftViewMode = UITextFieldViewModeAlways;
//    
    self.detailAdress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.detailAdress.leftView = label3;
    self.detailAdress.backgroundColor = [UIColor whiteColor];
   
    [self.view addSubview:self.detailAdress];
    
    
    self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 74+self.StatusBarHeight, ScreenW, 40)];
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTextField.font = [UIFont systemFontOfSize:15];
    self.userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userNameTextField .leftView = label;
   
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.userNameTextField];
 
}
-(void)SelectActionAnnimate:(UIGestureRecognizer *)gesture{
    
    self.view.window.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
    }];
    self.coverView.hidden = !self.coverView.hidden;
    self.chooseLocationView.hidden = self.coverView.hidden;
}

-(void)returnAction:(UIButton *)btn{
    
    UIAlertView * alerter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出编辑地址页面" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alerter show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        self.view.window.backgroundColor = [UIColor whiteColor];

        [self.navigationController popViewControllerAnimated:YES];

    }
}
#pragma mark ----保存新添收货地址
- (IBAction)SavePlaceAction:(id)sender {
    if (_phoneNumberTextField.text.length && _phoneNumberTextField.text.length && _userNameTextField.text.length && _detailAdress.text.length) {
        
        [self requestAdress];
        
    }else{
        [self showStaus:@"请填写完整的资料"];
    }
    
}
-(void)requestAdress{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"areaId"] = _areaID;

    param[@"trueName"] = self.userNameTextField.text;
    param[@"mobile"] = self.phoneNumberTextField.text;
    param[@"area_info"] = self.detailAdress.text;
    
    if (self.placeType == 2) {
        
        param[@"addressId"] =[NSString stringWithFormat:@"%ld",self.model.id];
    }
    [weakself POST:self.requestUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshingPlace" object:nil];
            
            [weakself.navigationController popViewControllerAnimated:YES];
            
        }

    } failure:^(NSError *error) {
        

    }];

}
#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

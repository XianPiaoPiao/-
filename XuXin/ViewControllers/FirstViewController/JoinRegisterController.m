//
//  JoinRegisterController.m
//  XuXin
//
//  Created by xuxin on 16/12/20.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//
//
//  JoinRegisterController.m
//  XuXin
//
//  Created by xuxin on 16/12/5.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "JoinRegisterController.h"
#import "ChooseLocationView.h"
#import "AddressItemModel.h"
#import "RegisterField.h"
#import "HtmWalletPaytypeController.h"
#define timeCount 60
static int count = 0;
@interface JoinRegisterController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong)ChooseLocationView *chooseLocationView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic ,copy)NSString * areaID;
@property (nonatomic ,strong)UILabel * addressLabel;
@property (nonatomic, strong) UIButton *verifyRightView; //获取验证码按钮

@property (strong, nonatomic) UIView * maskView;

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;

@property (strong, nonatomic) IBOutlet UIView *pickeerBgView;
@property (nonatomic ,strong)NSMutableArray * cityDataArray;

@property(nonatomic,assign) BOOL isUserCamera;

//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) NSMutableArray * secondArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (nonatomic ,copy)NSString * className;
@property (nonatomic ,copy)NSString * firstClassName;
@property (nonatomic ,copy)NSString * firstClassId;

@property (nonatomic ,copy)NSString * classId;

@property (nonatomic ,copy)NSString *mobileNumber;
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *password;
@property (nonatomic ,copy)NSString *repeatPassword;
@property (nonatomic ,copy)NSString *storeName;
@property (nonatomic ,copy)NSString *detailAdress;
@property (nonatomic ,copy)NSString *yongjing;
@property (nonatomic ,copy)NSString *userName;
@property (nonatomic ,copy)NSString *userPhone;
@property (nonatomic ,copy)NSString *userCardNumber;
@property (nonatomic ,copy)NSString * recommondPhoneNumber;
@property (nonatomic ,copy)NSString * mentouName;

@property (nonatomic ,assign)NSInteger flag;
@property (nonatomic ,copy)NSString * requestUrl;

@end

@implementation JoinRegisterController{
    
    UITableView * _tableView;
    UITableView *  _selectPlaceTableView;
    UIView * _addressBgView;
    UILabel * _categoryLabel;
    UITextField * _phoneNumberField;
    //
    UIImagePickerController * _peoplePicker;
    UIImagePickerController * _storePicker;
    
    NSTimer * _showRepeatBttonTimer;
    NSTimer * _updateTime; //更新倒计时label
    UIImageView * _sucessPeoeleImage;
    UIImageView * _sucessbusesImage;

    //
    UIButton * _upLoadBtn;
    UIButton * _upLoadStoreBtn;
    
    UIProgressView * _progressView;
    UIProgressView * _StoreProgressView;

    //
    BOOL isShowSuccess;
    BOOL isShowStoresSuccess;
}
-(NSMutableArray *)cityDataArray{
    if (!_cityDataArray) {
        _cityDataArray = [[NSMutableArray alloc] init];
    }
    return _cityDataArray;
}
-(NSMutableArray *)firstArray{
    if (!_firstArray ) {
        _firstArray = [[NSMutableArray alloc] init];
    }
    return _firstArray;
}
-(NSMutableArray *)secondArray{
    if (!_secondArray ) {
        _secondArray = [[NSMutableArray alloc] init];
    }
    return _secondArray;
}
-(NSMutableArray *)selectedArray{
    if (!_selectedArray ) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.pickeerBgView.frame = CGRectMake(0, screenH, ScreenW, 200);
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    count = 0;
    //关闭定时器
    [_updateTime setFireDate:[NSDate distantFuture]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _mobileNumber = @"";
    _code = @"";
    _password = @"";
    _repeatPassword = @"";
    _userCardNumber = @"";
    _userPhone = @"";
    _userName =@"";
    _yongjing = @"";
    _detailAdress = @"";
    _storeName  = @"";
    _mentouName = @"";
    _firstClassName = @"";
    _className = @"";
    
    isShowSuccess = NO;
    isShowStoresSuccess = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fuzhi:) name:@"areaId" object:nil];
    [self creatNavgationBar];
    //
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self settingUI];
    
    // Do any additional setup after loading the view.
    _selectPlaceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenH, ScreenW, 200) style:UITableViewStyleGrouped];
    [self.view addSubview:_selectPlaceTableView];
    
    
    _progressView  = [[UIProgressView alloc] initWithFrame:CGRectMake(0, -screenH, ScreenW, 3)];
    _progressView.trackTintColor=[UIColor whiteColor];
    [_progressView setProgressTintColor:[UIColor colorWithHexString:@"#1ac837"]];
    
    [self.view  addSubview:_progressView];
    
    _StoreProgressView  = [[UIProgressView alloc] initWithFrame:CGRectMake(0, -screenH, ScreenW, 3)];
    _StoreProgressView.trackTintColor=[UIColor whiteColor];
    [_StoreProgressView setProgressTintColor:[UIColor colorWithHexString:@"#1ac837"]];
    [self.view addSubview:_StoreProgressView];
    
    //城市列表请求
    [self requestCityData];
    
    [self getPickerData];
}
#pragma mark ---城市选择
-(void)requestCityData{
    
    __weak typeof(self)weakself = self;
    [weakself POST:city_3levelUrl parameters:nil success:^(id responseObject) {
        NSMutableArray * mArray = [NSMutableArray array];
        for (NSDictionary * dict0 in responseObject[@"result"]) {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            [mDict setValue:dict0[@"childs"] forKey:@"childs"];
            AddressItemModel* item = [AddressItemModel initWithName:dict0[@"areaName"] andId:dict0[@"id"] isSelected:NO];
            [mDict setValue:item forKey:@"result"];
            [mArray addObject:mDict];
            weakself.cityDataArray = mArray;
            
            weakself.chooseLocationView.dataSouce = [NSMutableArray arrayWithArray:self.cityDataArray];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.chooseLocationView.tabbleView reloadData];
        });
    } failure:^(NSError *error) {
        
        
    }];
}

-(void)creatNavgationBar{
    
    
    
    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBegView.backgroundColor = [UIColor colorWithHexString:MainColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:@"我要加盟"];
    
    UIButton * button= [[UIButton alloc] initWithFrame:CGRectMake(5, 20+self.StatusBarHeight, 60, 40)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setImage:[UIImage imageNamed:@"sign_in_fanhui@2x"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    //添加点击事件
    [button addTarget:self action:@selector(returnToMianVC) forControlEvents:UIControlEventTouchDown];
    [navBegView addSubview:label];
    [navBegView addSubview:button];
    [self.view addSubview:navBegView];
    
    
}
- (UIView *)coverView{
    
    if (!_coverView) {
        
        _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
        
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)]
        ;
        [_coverView addSubview:_chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseAddressFinish = ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                weakSelf.addressLabel.text =[NSString stringWithFormat:@"公司经营地址:%@",weakSelf.chooseLocationView.address];
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
//通知方法
-(void)fuzhi:(NSNotification *)cation{
    
    _areaID = cation.userInfo[@"textOne"];
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
        
    self.view.window.backgroundColor = [UIColor whiteColor];

        _chooseLocationView.chooseAddressFinish();
    }
    
}

//设置UI
-(void)settingUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH) style:UITableViewStylePlain];

    [self.view addSubview:_tableView];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}
#pragma mark -------界面布局
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CGFloat fieldH =40;
        //第-部分
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:BackColor];
        cell.selectionStyle = NO;
        
        //创建右视图
        _verifyRightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 90, 30)];
  
        _verifyRightView.titleLabel.textAlignment = 1;
   
        _verifyRightView.layer.cornerRadius = 15;
        _verifyRightView.titleLabel.font = [UIFont systemFontOfSize:14];
        [_verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_verifyRightView addTarget:self action:@selector(sendRegisterNumberAction) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%d",count);
        if (count > 0 && count < 60) {
            
            _verifyRightView.backgroundColor = [UIColor colorWithHexString:WordLightColor];
            
        }else if (count == 60){
            
            _verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];
            [_verifyRightView setTitle:@"重新发送" forState:UIControlStateNormal];
            
        }else{
            
        _verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];
        [_verifyRightView setTitle:@"发送验证码" forState:UIControlStateNormal];
        }
        //
        NSArray * array = @[@"请输入注册手机号码",@"输入验证码",@"请输入密码",@"确认密码"];
        NSArray * leftArray =@[@"注册手机号码:",@"验证码:",@"密   码:",@"重复密码:"];

       NSArray * textArray = @[_mobileNumber,_code,_password,_repeatPassword];
        
        for (int i = 0; i< 4; i++) {
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, (fieldH+1) * i, ScreenW , fieldH)];
            textField.backgroundColor = [UIColor whiteColor];
            ;
            textField.delegate = self;
            
            textField.text = textArray[i];
            
            textField.placeholder = array[i];
            textField.textColor = [UIColor blackColor];
            textField.font  =[UIFont systemFontOfSize:14];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.tag = buttonTag + i;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            if (i == 0) {
                
                [textField setKeyboardType:UIKeyboardTypePhonePad];
                
            }else if (i == 1) {
                
                UIView * leftBgView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW -100, 0, 100, 40)];
                leftBgView.backgroundColor = [UIColor whiteColor];
                [leftBgView addSubview:_verifyRightView];
                
                textField.rightViewMode = UITextFieldViewModeAlways;
                
                [textField setKeyboardType:UIKeyboardTypePhonePad];
                //
                textField.rightView = leftBgView;
                //分割线
                
            }else if (i ==2){
                
                textField.secureTextEntry = YES;
                
            }else if (i == 3){
                textField.secureTextEntry = YES;
                
            }else if (i== 4){
                
                [textField setKeyboardType:UIKeyboardTypePhonePad];
                
            }
            
     
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
            UILabel * firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 108, 40)];
            
            label.textAlignment = 1;
            [label setText:leftArray[i]];
            if (i == 3) {
                label.frame = CGRectMake(0, 0, 80, 40);
            }
            label.font = [UIFont systemFontOfSize:14];
            
            if (i== 0) {
                firstLabel.textAlignment = 1;
                [firstLabel setText:leftArray[i]];
                firstLabel.font = [UIFont systemFontOfSize:14];
                [textField setLeftView:firstLabel];

            }else{
                
                [textField setLeftView:label];

            }
            [cell.contentView addSubview:textField];
            
        }
        UILabel * headerText =[[UILabel alloc] initWithFrame:CGRectMake(0, (fieldH +1) * 4, ScreenW, fieldH)];
        headerText.textAlignment =1;
        headerText.backgroundColor = [UIColor colorWithHexString:MainColor];
        headerText.textColor = [UIColor whiteColor];
        headerText.font =[ UIFont systemFontOfSize:15];
        headerText.text = @"申请加盟商家信息";
        [cell.contentView addSubview:headerText];
        return cell;
    }
    
  else  if (indexPath.row == 1){
      
        CGFloat fieldW =40;
        //第-部分
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:BackColor];
        cell.selectionStyle = NO;
        
        NSArray * array = @[@"请输入加盟公司执照名称",@"请输入门店门头招牌名称",@"请输入详细地址",@"报销佣金，给报销佣金%25，请填写0.25"];
    
      NSArray * textArray = @[_storeName,_mentouName,_detailAdress,_yongjing];
        for (int i = 0; i< 4; i++) {
            
            if (i == 0 || i== 1) {
                
                RegisterField * textField = [[RegisterField alloc] initWithFrame:CGRectMake(0, fieldW * i +i, ScreenW, fieldW)];
                
                textField.text= textArray[i];
                textField.delegate = self;
                [textField setPlaceholder:array[i]];
                textField.backgroundColor = [UIColor whiteColor];
                textField.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:textField];
                textField.tag = buttonTag + 10 +i;
                
            }else{
                
                RegisterField * textField = [[RegisterField alloc] initWithFrame:CGRectMake(0, (fieldW+1) * i + i * (fieldW +1) -1, ScreenW, fieldW)];
                textField.delegate =self;
                textField.text = textArray[i];
                
                textField.backgroundColor = [UIColor whiteColor];        [textField setPlaceholder:array[i]];
                textField.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:textField];
                textField.tag = buttonTag + 10+ i;
                
            }
        }
        //店铺分类
        UIView * storeCategoryView = [[UIView alloc] initWithFrame:CGRectMake(0, (fieldW +1) * 2 , ScreenW, fieldW)];
        //手势
        storeCategoryView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMyPicker:)];
        [storeCategoryView addGestureRecognizer:tap2];
        
        storeCategoryView.backgroundColor = [UIColor whiteColor];
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 40, fieldW)];
        _categoryLabel.font = [UIFont systemFontOfSize:14];
        _categoryLabel.text = @"请选择店铺分类:";
        [storeCategoryView addSubview:_categoryLabel];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( ScreenW - 20, 16, 10, 8)];
        [imageView setImage:[UIImage imageNamed:@"exchange_icon_bottom_arrow_off@3x"]];
        [storeCategoryView addSubview:imageView];
        
        //公司经营地址
        
        _addressBgView = [[UIView alloc] initWithFrame:CGRectMake(0, (fieldW +1) * 3, ScreenW, fieldW -1)];
        //添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SelectActionAnnimate:)];
        _addressBgView.userInteractionEnabled = YES;
        [_addressBgView addGestureRecognizer:tap];
        
        _addressBgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:_addressBgView];
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , 0, ScreenW - 20, fieldW)];
        _addressLabel.text = @"公司经营地址:";
        _addressLabel.font = [UIFont systemFontOfSize:14];
        [_addressBgView addSubview:_addressLabel];
        
        //按钮
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 20 , 16, 10, 8)];
        btn.titleLabel.textAlignment = 2;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"exchange_icon_bottom_arrow_off@3x"] forState:UIControlStateNormal];
        [btn setImagePositionWithType: SSImagePositionTypeRight spacing:2];
        [_addressBgView addSubview:btn];
        
        [cell.contentView addSubview:storeCategoryView];
        //上传营业执照照片
        
        UIView * pictureBgView = [[UIView alloc] initWithFrame:CGRectMake(0, (fieldW+1) * 5 -1, ScreenW , fieldW)];
        pictureBgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:pictureBgView];
        UILabel * pictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, fieldW)];
        pictureLabel.text = @"上传身份证照:";
        pictureLabel.font = [UIFont systemFontOfSize:14];
        [pictureBgView addSubview:pictureLabel];
        //
        _upLoadBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90, 5, 80, 30)];
        [_upLoadBtn setTitle:@"上传照片" forState:UIControlStateNormal];
        _upLoadBtn.layer.cornerRadius = 15;
        [_upLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _upLoadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _upLoadBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        [pictureBgView addSubview:_upLoadBtn];
        [_upLoadBtn addTarget:self action:@selector(uploadPeoplePicture) forControlEvents:UIControlEventTouchDown];
      
      _sucessPeoeleImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 120, 10, 20, 20)];
      if (isShowSuccess == YES) {
          
          _sucessPeoeleImage.hidden= NO;

      }else{
          
          _sucessPeoeleImage.hidden= YES;

      }
      [_sucessPeoeleImage setImage:[UIImage imageNamed:@"jiameng_selected@3x"]];
      [pictureBgView addSubview:_sucessPeoeleImage];
      


      
        return cell;
        
    }else if (indexPath.row == 2){
        
        CGFloat fieldW = 40;
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:BackColor];
        cell.selectionStyle = NO;
        
        UILabel * peopleLael = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, fieldW)];
        peopleLael.textAlignment = 1;
        peopleLael.backgroundColor = [UIColor colorWithHexString:MainColor];
        peopleLael.textColor = [UIColor whiteColor];
        peopleLael.text = @"法人信息";
        [cell.contentView addSubview:peopleLael];
        NSArray * array = @[@"法人姓名:",@"服务电话:",@"身份证号码:"];
        NSArray * placeHoderArray = @[@"请输入法人姓名",@"请输入法人手机号码",@"请输入身份证号码"];
         NSArray * textArray = @[_userName,_userPhone,_userCardNumber];
        for (int i = 0; i< 3; i++) {
        
            
            if (i == 2) {
                
                UITextField * textField =[[UITextField alloc] initWithFrame:CGRectMake(0,fieldW + i * (fieldW + 1), ScreenW, fieldW)];
                textField.delegate = self;
                textField.text = textArray[i];
                
                textField.backgroundColor = [UIColor whiteColor];
                textField.leftViewMode = UITextFieldViewModeAlways;
                
                textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:textField];
                [textField setPlaceholder:placeHoderArray[i]];
                textField.font = [UIFont systemFontOfSize:14];
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 95, 40)];
                label.textAlignment = 1;
                [label setText:array[i]];
                label.font = [UIFont systemFontOfSize:14];
                [textField setLeftView:label];
                textField.tag = buttonTag + i + 20;
                
            }else{
                
            UITextField * textField =[[UITextField alloc] initWithFrame:CGRectMake(0,fieldW + i * (fieldW + 1), ScreenW, fieldW)];
                
                textField.text = textArray[i];
                textField.delegate = self;
            textField.backgroundColor = [UIColor whiteColor];
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [cell.contentView addSubview:textField];
            [textField setPlaceholder:placeHoderArray[i]];
            textField.font = [UIFont systemFontOfSize:14];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
            label.textAlignment = 1;
            [label setText:array[i]];
            label.font = [UIFont systemFontOfSize:14];
            [textField setLeftView:label];
            textField.tag = buttonTag + i + 20;
                
        if (i == 1) {
            
            UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
            label2.textAlignment = 1;
            [label2 setText:array[i]];
            label2.font = [UIFont systemFontOfSize:14];
            textField.leftView = label2;
        }
    }

}
      
        //上传身份证照
        
        UIView * pictureBgView = [[UIView alloc] initWithFrame:CGRectMake(0, (fieldW+1) * 4 -1, ScreenW , fieldW)];
        pictureBgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:pictureBgView];
        UILabel * pictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, fieldW)];
        pictureLabel.text = @"上传营业执照照片:";
        pictureLabel.font = [UIFont systemFontOfSize:14];
        [pictureBgView addSubview:pictureLabel];
        
       _upLoadStoreBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90, 5, 80, 30)];
        [_upLoadStoreBtn setTitle:@"上传照片" forState:UIControlStateNormal];
        //上传营业执照
        [_upLoadStoreBtn addTarget:self action:@selector(uploadStoresPicture) forControlEvents:UIControlEventTouchDown];
        _upLoadStoreBtn.layer.cornerRadius = 15;
        [_upLoadStoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _upLoadStoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _upLoadStoreBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        [pictureBgView addSubview:_upLoadStoreBtn];
        
        _sucessbusesImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 120, 10, 20, 20)];
        
        if (isShowStoresSuccess == YES) {
            
            _sucessbusesImage.hidden= NO;

        }else{
            
            _sucessbusesImage.hidden= YES;

        }
        [_sucessbusesImage setImage:[UIImage imageNamed:@"jiameng_selected@3x"]];
        [pictureBgView addSubview:_sucessbusesImage];
        
    
        
        //推荐人手机
        _phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(0, (fieldW+1) *5, ScreenW , fieldW)];
        _phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
        [_phoneNumberField setKeyboardType: UIKeyboardTypePhonePad];

        _phoneNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:_phoneNumberField];
        [_phoneNumberField setPlaceholder:@"有推荐人就填写，没有就不填"];
       

        _phoneNumberField.font = [UIFont systemFontOfSize:14];
        _phoneNumberField.delegate = self;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 98, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = 1;
        [label setText:@"推荐人手机:"];
        _phoneNumberField.leftView = label;
        [cell.contentView addSubview:_phoneNumberField];
        //其他
        NSArray * otherArray = @[@"加盟电话:400-023-9719",@"注册成嗨兑用户协议书",@"加盟协议书已认真阅读，同意合同内容"];
        NSArray * otherBtnArray = @[@"立即拨打",@"立即查看",@"立即查看"];
        for (int i = 0; i< 3; i++) {
            
            UIView * otherBgView = [[UIView alloc] initWithFrame:CGRectMake(0, (fieldW+1) * 6 + i * (fieldW +1), ScreenW , fieldW)];
            [cell.contentView addSubview:otherBgView];
            otherBgView.backgroundColor = [UIColor whiteColor];
            UILabel * otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 , ScreenW -70, fieldW)];
            otherLabel.text = otherArray[i];
            otherLabel.font = [UIFont systemFontOfSize:14];
            otherLabel.textAlignment = 0;
            UIButton * otherBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90,5, 80, 30)];
            otherBtn.tag = buttonTag + 10 + i;
            [otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            otherBtn.layer.cornerRadius = 15;
            [otherBtn setTitle:otherBtnArray[i] forState:UIControlStateNormal];
            otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            otherBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            [otherBtn addTarget:self action:@selector(doSometing:) forControlEvents:UIControlEventTouchDown];
            if (i == 2) {
                
                UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                btn.tag = buttonTag + 800;
                
                btn.selected = YES;
                [btn addTarget:self action:@selector(agreeUser:) forControlEvents:UIControlEventTouchDown];
                
                [btn setImage:[UIImage imageNamed:@"icon_pane_circle_off.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"icon_pane_circle_on.png"] forState:UIControlStateSelected];
                
                otherLabel.frame = CGRectMake(40, 0, ScreenW - 120, 40) ;
                                    
                [otherBgView addSubview:btn];
            }
            
            [otherBgView addSubview:otherLabel];
            [otherBgView addSubview:otherBtn];
            
            
        }
        
        UIView * otherBtnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, (fieldW+1) * 9, ScreenW , fieldW)];
        otherBtnBgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:otherBtnBgView];
        UIButton * uploadContentBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20, 40)];
        uploadContentBtn.layer.cornerRadius = 20;
        [uploadContentBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [uploadContentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        uploadContentBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        [uploadContentBtn addTarget:self action:@selector(uploadData) forControlEvents:UIControlEventTouchDown];
        uploadContentBtn.center = CGPointMake(ScreenW/2.0f, 20);
        [otherBtnBgView addSubview:uploadContentBtn];
        return cell;
    }
    return 0;
    
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.userType == 1) {
            
            return 0;
            
           }else{
        return 205;
        }
    }else  if (indexPath.row == 1) {
        
        return 286;
        
        
    }else if (indexPath.row == 2){
        return 41 * 10;
    }
    return 0;
}
-(void)returnToMianVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];

}
#pragma mark ----选择城市点击事件
-(void)SelectActionAnnimate:(UIGestureRecognizer *)gesture{
    
    self.view.window.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
    }];
    self.coverView.hidden = !self.coverView.hidden;
    self.chooseLocationView.hidden = self.coverView.hidden;
}
#pragma mark ----选择商家列表
#pragma mark - init view
- (void)initView {
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
}
#pragma mark - get data 商家分类数据请求
- (void)getPickerData {
    
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"isNeedChildClass"] = @"1";
    param[@"level"] = @"0";
    param[@"type"] = @"1";
    [weakself POST:storeClassUrl parameters:param success:^(id responseObject) {
        
        
        NSArray * array = responseObject[@"result"];
        
        weakself.firstArray = [NSMutableArray arrayWithArray:array];
        
        weakself.selectedArray = weakself.firstArray[0][@"childs"];
        
        if (weakself.selectedArray.count > 0) {
            
            weakself.secondArray = self.selectedArray;
        }
        //设置默认值
        _firstClassName = self.firstArray[0][@"className"];
        _className = self.secondArray[0][@"className"];
        _classId = [self.firstArray objectAtIndex:0][@"id"];
        //更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            //创建对象
            [self initView];
            
        });
        

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        
        return self.firstArray.count;
    } else {
        return self.secondArray.count;
    }}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        
        return self.firstArray[row][@"className"];
        
    } else   {
        
        return self.secondArray[row][@"className"];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        
        return 110;
    } else  {
        return 100;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        self.selectedArray = [self.firstArray objectAtIndex:row][@"childs"];
        _firstClassName = [self.firstArray objectAtIndex:row][@"className"];
        
        _classId = [self.firstArray objectAtIndex:row][@"id"];
        
        if (self.selectedArray.count > 0) {
            
            self.secondArray = self.selectedArray;
            
        } else {
            
            self.secondArray = nil;
        }
        
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
//
    if (component == 1) {
        
        _className = self.secondArray[row][@"className"];
        _classId = self.secondArray[row][@"id"];
        
    }
    
}

#pragma mark - private method
- (void)showMyPicker:(UITapGestureRecognizer *)sender {
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickeerBgView];
    
    self.myPickerView.delegate = self;
    
    self.maskView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.maskView.alpha = 0.3;
        self.pickeerBgView.frame = CGRectMake(0, screenH - 200, ScreenW, 200);
    }];
}

- (void)hideMyPicker {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.maskView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.maskView removeFromSuperview];
        [self.pickeerBgView removeFromSuperview];
    }];
}

#pragma mark - xib click

- (IBAction)cancel:(id)sender {
    
    [self hideMyPicker];
}

- (IBAction)ensure:(id)sender {
    
    [_categoryLabel setText:[NSString stringWithFormat:@"请选择店铺分类:%@-%@",_firstClassName, _className]];
    
    [self hideMyPicker];
}
#pragma mark ---提交申请
-(void)uploadData{
//
    self.view.window.backgroundColor = [UIColor whiteColor];

    [SVProgressHUD showWithStatus:@"正在提交资料"];
    
    [self upStoresData];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 100) {
        
        _mobileNumber =  textField.text;
        
    }else if (textField.tag == 101){
        _code = textField.text;
        
    }else if (textField.tag == 102){
        
        _password = textField.text;
    }else if (textField.tag == 103){
        _repeatPassword = textField.text;
        
    }else if (textField.tag == 110){
        
        _storeName = textField.text;
        
    }else if (textField.tag == 111){
        
        _mentouName = textField.text;
    }
    else if (textField.tag == 112){
        
        _detailAdress = textField.text;
        
    }else if (textField.tag == 113){
        
        _yongjing = textField.text;

    }else if (textField.tag == 120){
        _userName = textField.text;

    }else if (textField.tag ==121){
        _userPhone = textField.text;

    }else if (textField.tag == 122){
        
        _userCardNumber = textField.text;
    }
}
-(void)upStoresData{

    UIButton * btn =[self.view viewWithTag:900];
    
    
    if (self.userType == 1) {
      
        
        if (_storeName.length>0 && _detailAdress.length >0 && _yongjing.length > 0 &&_userName.length > 0 && _userPhone.length > 0 && _userCardNumber.length > 0 && btn.selected == YES) {
            
            __weak typeof(self)weakself = self;
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            if (_phoneNumberField.text != nil) {
                
            param[@"recommendPerson"] = _phoneNumberField.text;
                
            }
            param[@"storeName"] = _storeName;
            param[@"storeClassId"] =_classId;
            
            param[@"storeAreaId"] = _areaID;
            
            param[@"areaInfo"]= _detailAdress;
            param[@"adm_divide"] = _yongjing;
            param[@"storeOwerName"] = _userName;
            param[@"storePhone"] = _userPhone;
            param[@"storeOwerNameCard"] = _userCardNumber;
            [weakself.httpManager POST:save_storeUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString * str = responseObject[@"isSucc"];
                if ([str intValue] == 1) {
                    
                [SVProgressHUD showSuccessWithStatus:@"提交资料成功"];
                    
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                 [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    });
                    
                }else{
                    [SVProgressHUD dismiss];

                    [self showStaus:responseObject[@"msg"]];
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [SVProgressHUD dismiss];
            }];
        
            
        }else{
            if (btn.selected == NO) {
                
                [SVProgressHUD showErrorWithStatus:@"请同意用户协议"];

            }else{
                [SVProgressHUD showErrorWithStatus:@"请填写完整资料"];

            }
        }

    }else if (self.userType == 2){
       
        
        
        if (_storeName.length>0 && _detailAdress.length >0 && _yongjing.length > 0 &&_userName.length > 0 && _userPhone.length > 0 && _userCardNumber.length > 0 && _code.length > 0 &&_mobileNumber.length > 0&& _password.length > 0 && _repeatPassword.length > 0 && btn.selected == YES) {
            
            __weak typeof(self)weakself = self;
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            
            if (_phoneNumberField.text != nil) {
                
                param[@"recommendPerson"] = _phoneNumberField.text;

            }
            param[@"storeName"] = _storeName;
            param[@"storeClassId"] =_classId;
            param[@"storeAreaId"] = _areaID;
            
            param[@"areaInfo"]= _detailAdress;
            param[@"adm_divide"] = _yongjing;
            param[@"storeOwerName"] = _userName;
            param[@"storePhone"] = _userPhone;
            param[@"storeOwerNameCard"] = _userCardNumber;
            
            param[@"phone"] = _mobileNumber;
            param[@"verficationCode"] =_code;
            param[@"passWord"] =_password;
            
            param[@"confirmPwd"]= _repeatPassword;
            
            [weakself.httpManager POST:saveStoreAndUserUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            NSString * str = responseObject[@"isSucc"];
                

                if ([str intValue] == 1) {

                [SVProgressHUD showSuccessWithStatus:@"提交资料成功"];
                    
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    });
                    
                }else{
                    
                    [SVProgressHUD dismiss];

                    [self showStaus:responseObject[@"msg"]];
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [SVProgressHUD dismiss];

                
            }];
    }else{
        if (btn.selected == NO) {
            [SVProgressHUD showErrorWithStatus:@"请同意用户协议"];

        }else{
            [SVProgressHUD showErrorWithStatus:@"请填写完整资料"];

        }
        }
    }
}
#pragma mark --- 上传身份证照
-(void)uploadPeoplePicture{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPeopleCamera];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPeoplePhoto];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [alertController addAction:action2];
    
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark ----上传营业执照
-(void)uploadStoresPicture{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openStoreCamera];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openStrorePhoto];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [alertController addAction:action2];
    
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark ---立即查看，立即拨打
-(void)doSometing:(UIButton *)sender{
    if (sender.tag == buttonTag + 10) {
        
        UIWebView * webVIew = [[UIWebView alloc] init];
        NSString * phoneNumber = @"4000239719";
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
        [webVIew loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webVIew];
    }else if (sender.tag == buttonTag + 11){
        //查看协议
        HtmWalletPaytypeController * htmlVC = [[HtmWalletPaytypeController alloc] init];
        htmlVC.requestUrl = registrAgreementUrl;
        htmlVC.htmlType = registrAgreementType;
        [self.navigationController pushViewController:htmlVC animated:YES];
        
    }else{
        //合同
        HtmWalletPaytypeController * htmlVC = [[HtmWalletPaytypeController alloc] init];
        htmlVC.requestUrl = agreementHtmUrl;
        htmlVC.htmlType =joinType;
        [self.navigationController pushViewController:htmlVC animated:YES];
    }
    
}

#pragma 修改图片
-(void)openStoreCamera{
    
    BOOL ret = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    //判断是否支持相机
    if (ret) {
        

        //1.创建一个图片选择器控制器对象
        _storePicker = [[UIImagePickerController alloc] init];
        
        //2.设置图片资源类型
        [_storePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //3.设置代理
        _storePicker.delegate = self;
        
        //4.显示图片选择器
        [self presentViewController:_storePicker animated:YES completion:nil];
        
         self.isUserCamera = YES;
        
    }else{
        
        // FLLog(@"该设备没有相机");
    }
    
}
-(void)openPeopleCamera{
    
    BOOL ret = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    //判断是否支持相机
    if (ret) {
        
        //1.创建一个图片选择器控制器对象
        _peoplePicker = [[UIImagePickerController alloc] init];
        //2.设置图片资源类型
        [_peoplePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //3.设置代理
        _peoplePicker.delegate = self;
        
        //4.显示图片选择器
        [self presentViewController:_peoplePicker animated:YES completion:nil];
        
    
        
    }else{
        
        // FLLog(@"该设备没有相机");
    }
    
}
//参数1：委托
//参数2：选中的资源信息
-(void)openPeoplePhoto{
    //1.创建一个图片选择器控制器对象
     _peoplePicker = [[UIImagePickerController alloc] init];
    
    //2.设置资源类型
    [_peoplePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    //3.设置代理
    _peoplePicker.delegate = self;
    
    //5.选择的时候看大图
  //  _peoplePicker.allowsEditing = YES;
    
    
    //4.显示在界面
    [self presentViewController:_peoplePicker animated:YES completion:nil];
    self.isUserCamera = NO;
    
   }
-(void)openStrorePhoto{
    _storePicker = [[UIImagePickerController alloc] init];
    
    //2.设置资源类型
    [_storePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    //3.设置代理
    _storePicker.delegate = self;
    
    //5.选择的时候看大图
  //  _storePicker.allowsEditing = YES;
    
    //4.显示在界面
    [self presentViewController:_storePicker animated:YES completion:nil];
    self.isUserCamera = NO;

}
#pragma mark - imagePicker Delegate
//参数1:委托
//参数2:选中的资源信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if(picker == _peoplePicker){
        
        //身份证
        self.requestUrl = app_testPngUrl;
        self.flag = 2;

    } else if(picker == _storePicker) {
        //执照
        self.requestUrl = app_testPngUrl;
        self.flag = 1;
        
    }
    //1.获取原图
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
    
    //获取截图(只有在允许编辑的时候才有)
 //   UIImage * image2 = info[@"UIImagePickerControllerEditedImage"];
    
    NSData * data;
    if (UIImagePNGRepresentation(image)) {
        
        data= UIImagePNGRepresentation(image);
        
    } else {
        data =UIImageJPEGRepresentation(image, 1.0);
    }
     //  [[NSFileManager defaultManager] createFileAtPath:_imagePath contents:data attributes:nil];
    
    //3.让图片选择器消失
    //上传数据
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"type"] = [NSString stringWithFormat:@"%ld",(long)self.flag];
    
    if ([[User defalutManager].userName isEqualToString:@"NO"] == NO) {
        
        param[@"username"] = [User defalutManager].userName;

    }else{
        param[@"username"] = _mobileNumber;
    }
    
    NSURLSessionDataTask *task = [weakSelf.httpManager POST:self.requestUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%.2f",uploadProgress.fractionCompleted);
        
        
        if (self.flag == 2) {
            
      
         //显示上传进度
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _progressView.frame = CGRectMake(0, 64, ScreenW, 8);
                
//                _progressView.transform = CGAffineTransformMakeScale(2.0f,6.0f);

                _progressView.progress = uploadProgress.fractionCompleted;
            });
            
        }else if(self.flag ==1){
            
            //显示上传进度

            dispatch_async(dispatch_get_main_queue(), ^{
                
                _StoreProgressView.frame = CGRectMake(0, 64, ScreenW, 8);
                _StoreProgressView.transform = CGAffineTransformMakeScale(1.0f,6.0f);

                _StoreProgressView.progress = uploadProgress.fractionCompleted;
            });
     
            
        }
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [self showStaus:responseObject[@"msg"]];
            if (self.flag == 2) {
                //显示上传进度

            _progressView.frame = CGRectMake(0, -screenH, ScreenW, 0);

            _sucessPeoeleImage.hidden = NO;
                isShowSuccess = YES;
                
            }else if(self.flag ==1){
                //显示上传进度

                _StoreProgressView.frame = CGRectMake(0, -screenH, ScreenW, 0);

                _sucessbusesImage.hidden = NO;
                isShowStoresSuccess = YES;
            }
        }else{
            
            [self showStaus:@"上传失败"];
        }
     
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        

        [self showStaus:@"上传失败"];
        
    }];
    [task resume];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
  
    if (textField.tag == 120 || textField.tag == 121 || textField.tag == 122 || textField.tag == 123) {
        
        
        [UIView animateWithDuration:0.6 animations:^{
            
        _tableView.contentOffset = CGPointMake(0, 500);
            

       }];

    }
}

- (void)getVerify
{
    [_showRepeatBttonTimer invalidate]; //
    [_updateTime invalidate];
    self.verifyRightView.backgroundColor = [UIColor colorWithHexString:WordLightColor];
    
    count = 0;
    // 显示重新发送按钮
    NSTimer *showRepeatButtonTimer=[NSTimer scheduledTimerWithTimeInterval:timeCount target:self selector:@selector(showRepeatButton) userInfo:nil
                                                                   repeats:YES];
    // 倒计时label
    NSTimer * updateTime = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    //添加到
    [[NSRunLoop mainRunLoop] addTimer:updateTime forMode:NSRunLoopCommonModes];

    _showRepeatBttonTimer = showRepeatButtonTimer;
    _updateTime = updateTime;
}
/**
 *  显示重新发送按钮
 */
-(void)showRepeatButton{
    
    self.verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];

    [self.verifyRightView setTitle:@"重新发送" forState:UIControlStateNormal];
    self.verifyRightView.userInteractionEnabled = YES;
    [self.verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_showRepeatBttonTimer invalidate];
    return;
}
-(void)updateTime
{
    count++;
    if (count >= timeCount)
    {
        [_updateTime invalidate];
        return;
    }
    
    NSString *updateTimeStr =[NSString stringWithFormat:@"%@%i%@",NSLocalizedString(@"", nil),timeCount-count,NSLocalizedString(@"秒可重发", nil)];
    [self.verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.verifyRightView.userInteractionEnabled = NO;
    [self.verifyRightView setTitle:updateTimeStr forState:UIControlStateNormal];
    
}
-(void)sendRegisterNumberAction{
    
    UITextField * field =  [self.view viewWithTag:buttonTag ];
    
    
    if( field.text.length != 11){
        
        
        [self showStaus:@"手机号码不正确"];
        
    } else{
        
        [SVProgressHUD showWithStatus:@"请稍等"];
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param = [NSMutableDictionary dictionary];
        param[@"phone"] = field.text;
        
        param[@"verifyCodeType"] = [NSString stringWithFormat:@"%ld",(long)registerType];
        
        [weakself POST:VerifyCodeUrl parameters:param success:^(id responseObject) {
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
                
                
                [weakself getVerify];
                
            }else{
                
                [self showStaus:responseObject[@"msg"]];
                
            }

        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark ---同意用户协议
-(void)agreeUser:(UIButton *)sender{
    
    sender.selected = !sender.selected;
}
#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


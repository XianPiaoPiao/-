//
//  LeftScreenController.m
//  嗨兑商家端
//
//  Created by xuxin on 17/6/5.
//  Copyright © 2017年 www.hidui.com. All rights reserved.
//

#import "LeftScreenController.h"
#import "STPickerDate.h"
#import "HaiduiTextFiled.h"
@interface LeftScreenController ()<UITextFieldDelegate,STPickerDateDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,assign)BOOL isStartTime;

//收入，支出
@property (nonatomic ,assign)NSInteger income;

@property (nonatomic ,assign)NSInteger startTime;
@property (nonatomic ,assign)NSInteger endTime;

//滑动
@property (strong, nonatomic) UIView * maskView;

@property (strong, nonatomic) UIPickerView *myPickerView;

@property (nonatomic ,strong)UIView * pickerBgView;


@property (nonatomic ,copy)NSString * className;

@property (nonatomic ,strong)NSMutableArray * dataArray;

@end

@implementation LeftScreenController{
    
    STPickerDate * _datePicker;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(UIView *)pickerBgView{
    
    if (!_pickerBgView) {
        
        CGFloat bgViewH = 300;
        
        CGFloat btnH = 30;
        CGFloat btnW = 60;
        
        _pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(-40, screenH , ScreenW, bgViewH)];
        _pickerBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
        
    //    [self.view addSubview:_pickerBgView];
        //pickerView
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, btnH + 10, ScreenW, bgViewH - btnH)];
        _myPickerView.backgroundColor = [UIColor whiteColor];
        
        _myPickerView.delegate = self;
        _myPickerView.dataSource = self;
        //初始化数据
        if (self.dataArray.count > 0) {
            
            _className = [self.dataArray objectAtIndex:0][@"type"];
            
        }
        
        [_pickerBgView addSubview:_myPickerView];
        
        UIButton * sureBtn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - btnW -5, 5, btnW, btnH)];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.layer.cornerRadius = 4;
        sureBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pickerBgView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(enSure) forControlEvents:UIControlEventTouchDown];
        
        UIButton * cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, btnW, btnH)];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancleBtn.layer.cornerRadius = 4;
        [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancleBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_pickerBgView addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(hideMyPicker) forControlEvents:UIControlEventTouchDown];
        //阴影
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, ScreenW  , screenH)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
        
        [self.view addSubview:_maskView];
        
    }
    return _pickerBgView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self settingNavBar];
    
    [self settingUI];
    
    //初始化日期
    _datePicker = [[STPickerDate alloc]initWithDelegate:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)requestData{
    
    [SVProgressHUD showWithStatus:@"请稍等"];
    
    [self POST:blanceStoreCategoryUrl parameters:nil success:^(id responseObject) {
        
        [SVProgressHUD dismiss];

        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            self.dataArray = responseObject[@"result"];
            
            [self showStoresPicker];
        }
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];

    }];
}
-(void)settingNavBar{
    
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenW -40 , 30)];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor colorWithHexString:BackColor];
    label.text = @"筛选" ;
    label.font = [UIFont systemFontOfSize:14];
    
   // label.center = CGPointMake(0, 28);
    
    [self.view addSubview:label];
    
}
-(void)settingUI{
    
    //c
    CGFloat bgViewH = 90;
    CGFloat textFieldH = 35;
    
    NSArray * array = @[@"类型",@"时间",@"描述查询",@"收入/支出"];
    for (int i = 0; i < 4; i ++) {
        
        UILabel * nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 54 + bgViewH * i, 100, 20)];
        nameLabel.tag = buttonTag + i;
        
        nameLabel.text = array[i];
        [self.view addSubview:nameLabel];
        //分割线
        UIView * stringView =[[UIView alloc] initWithFrame:CGRectMake(0,44 + bgViewH * (i + 1), ScreenW, 1)];
        stringView.backgroundColor =[UIColor colorWithHexString:BackColor];
        
        [self.view addSubview:stringView];
    }
    
    //买家
    UILabel * buyerLabel = [self.view viewWithTag:100];

    //右视图
  
    HaiduiTextFiled * buyerField = [[HaiduiTextFiled alloc] init];
    buyerField.tag = buttonTag + 20;
    buyerField.layer.cornerRadius = 6;
    buyerField.layer.borderWidth = 1;
   // buyerField.layer.borderColor = CORE_RGBCOLOR(220, 220, 220).CGColor;
    buyerField.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    buyerField.delegate = self;
    UIButton * categoryrightView =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [categoryrightView setImage:[UIImage imageNamed:@"present_arrow"] forState:UIControlStateNormal];
    [buyerField setRightViewMode:UITextFieldViewModeAlways];
    buyerField.rightView = categoryrightView;
    
    [self.view addSubview:buyerField];
    
    CGFloat buyerW = ScreenW /2.0f;
    
    [buyerField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.width.mas_equalTo(buyerW);
        make.top.equalTo(buyerLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
    }];
    
    //时间
    UILabel * dateLabel = [self.view viewWithTag:101];

    UILabel * label  =[[UILabel alloc] initWithFrame:CGRectMake((ScreenW - 80)/2.0f, 38 + bgViewH + bgViewH / 2.0f , 40, textFieldH)];
    
    label.textAlignment = 1;
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    
    label.text = @"—";
    [self.view addSubview:label];
    
    HaiduiTextFiled * startField = [[HaiduiTextFiled alloc] init];
    startField.text = @"起始时间";
    startField.tag = buttonTag + 10;
    
    startField.delegate = self;
    //右视图
    UIButton * rightView =[[UIButton alloc] initWithFrame:CGRectMake(0, 0,15, 15)];
    [rightView setImage:[UIImage imageNamed:@"present_arrow"] forState:UIControlStateNormal];
    [startField setRightViewMode:UITextFieldViewModeAlways];
    startField.rightView = rightView;
    
    startField.layer.cornerRadius = 6;
    startField.layer.borderWidth = 1;
    startField.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    [self.view addSubview:startField];
    [startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(self.view.mas_left).offset(5);
        make.right.equalTo(label.mas_left);
    }];
    
    HaiduiTextFiled * endField = [[HaiduiTextFiled alloc] init];
    endField.tag = buttonTag + 11;
    endField.delegate = self;
    endField.layer.cornerRadius = 6;
    endField.backgroundColor = [UIColor whiteColor];
    endField.layer.borderWidth = 1;
    endField.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    endField.text = @"截止时间";
    endField.layer.cornerRadius = 6;
    [self.view addSubview:endField];
    
    //右视图
    UIButton * endRightView =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [endRightView setImage:[UIImage imageNamed:@"present_arrow"] forState:UIControlStateNormal];
    [endField setRightViewMode:UITextFieldViewModeAlways];
    endField.rightView = endRightView;
    
    [endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(label.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-45);
    }];
    
    //订单号
    UILabel * orderLabel = [self.view viewWithTag:102];
    
    HaiduiTextFiled * orderField = [[HaiduiTextFiled alloc] init];
    orderField.tag = buttonTag + 21;
    
    [self.view addSubview:orderField];
    orderField.layer.cornerRadius = 6;
    orderField.layer.borderWidth = 1;
    orderField.layer.borderColor =[UIColor colorWithHexString:@"#999999"].CGColor;
    
    CGFloat ordelH  = ScreenW/2.0f + 40;
    
    [orderField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.width.mas_equalTo(ordelH);
        make.top.equalTo(orderLabel.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];
    
    //收入、支出
    UILabel * categroyLabel = [self.view viewWithTag:103];
    UIButton * getBtn = [[UIButton alloc] init];
    getBtn.tag = buttonTag + 200;
    
    getBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    getBtn.layer.cornerRadius = 6;
    [getBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [getBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    [getBtn setBackgroundColor:[UIColor colorWithHexString:BackColor]];
    
    [getBtn setTitle:@"收入" forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(setGet:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:getBtn];
    
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.width.equalTo(@80);
        make.top.equalTo(categroyLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
    }];
    
    UIButton * expendBtn = [[UIButton alloc] init];
    expendBtn.tag = buttonTag + 300;
    expendBtn.layer.cornerRadius = 6;
    expendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [expendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [expendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [expendBtn setBackgroundColor:[UIColor colorWithHexString:BackColor]];
    [expendBtn setTitle:@"支出" forState:UIControlStateNormal];
    [expendBtn addTarget:self action:@selector(setPay:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:expendBtn];
    [expendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(getBtn.mas_right).offset(5);
        make.width.equalTo(@80);
        make.top.equalTo(categroyLabel.mas_bottom).offset(10);
        make.height.equalTo(@30);
    }];

    //重置，完成
    CGFloat btnH = 50;
    
    UIButton * resetBtn  =[[UIButton alloc] initWithFrame:CGRectMake(0, screenH -btnH , (ScreenW -40) / 2.0f, btnH)];
    resetBtn.backgroundColor = [UIColor colorWithHexString:@"ff9a01"];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(resetData) forControlEvents:UIControlEventTouchDown];
    
    UIButton * completBtn =[[UIButton alloc] initWithFrame:CGRectMake((ScreenW - 40)/2.0f, screenH - btnH, (ScreenW - 40)/2.0f, btnH)];
    completBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [completBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:completBtn];
}

#pragma mark --重置
-(void)resetData{

    HaiduiTextFiled * buyField =[self.view viewWithTag: buttonTag + 20];
    HaiduiTextFiled * startField = [self.view viewWithTag: buttonTag + 10];
    HaiduiTextFiled * endField =[self.view viewWithTag: buttonTag + 11];
    HaiduiTextFiled * orderField =[self.view viewWithTag: buttonTag + 21];

     buyField.text = @"";
     startField.text = @"起始时间";
     endField.text = @"截止时间";
     orderField.text = @"";
    
}
#pragma mark ---完成
-(void)complete{
    
    HaiduiTextFiled * buyField =[self.view viewWithTag: buttonTag + 20];
    HaiduiTextFiled * orderField =[self.view viewWithTag: buttonTag + 21];
    HaiduiTextFiled * startTextFiled = [self.view viewWithTag:110];
    HaiduiTextFiled * endTextFiled = [self.view viewWithTag:111];
    
    //时间转时间戳
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateA = [dateFormatter dateFromString:startTextFiled.text];
    NSDate *dateB = [dateFormatter dateFromString:endTextFiled.text];
    
    _startTime = [[NSNumber numberWithDouble:[dateA timeIntervalSince1970]] integerValue];
    _endTime = [[NSNumber numberWithDouble:[dateB timeIntervalSince1970]] integerValue];
    __weak typeof(self)weakeself = self;
    
    [self.navigationController popViewControllerAnimated:YES];

    self.block(weakeself.income,buyField.text,orderField.text,weakeself.startTime,weakeself.endTime);
    
}

#pragma mark ----UITextfieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
    if (textField.tag == 110) {
        
        [_datePicker show];

        _isStartTime = YES;

        
    }else if(textField.tag == 111){
        
        [_datePicker show];

        _isStartTime = NO;
        
    }else if(textField.tag == 120){
        //
        if (self.dataArray.count == 0) {
            
            [self requestData];

        }else{
            
            [self showStoresPicker];
            
        }
        
    }
    return NO;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
    
}

- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *text = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, (long)month, (long)day];
    
    HaiduiTextFiled * startTextFiled = [self.view viewWithTag:110];
    HaiduiTextFiled * endTextFiled = [self.view viewWithTag:111];
    
    if (_isStartTime ==  YES) {
        
        if ([endTextFiled.text isEqualToString:@"截止时间"] == YES) {
            
            startTextFiled.text = text;

        }else{
            //判断时间大小
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *dateA = [dateFormatter dateFromString:text];
            NSDate *dateB = [dateFormatter dateFromString:endTextFiled.text];
            
            
            NSComparisonResult result = [dateA compare:dateB];
            
            if (result == NSOrderedDescending) {
                
                [self showStaus:@"截止时间不能小于起止时间"];
            }
            else if (result == NSOrderedAscending){
                
                startTextFiled.text = text;
                
            }
  
        }
      
    }else{
        //判断时间大小
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   
        NSDate *dateA = [dateFormatter dateFromString:startTextFiled.text];
        NSDate *dateB = [dateFormatter dateFromString:text];
        
        NSComparisonResult result = [dateA compare:dateB];
        
        if (result == NSOrderedDescending) {
           
            [self showStaus:@"截止时间不能小于起止时间"];
        }
        else if (result == NSOrderedAscending){
            
            endTextFiled.text = text;

        }
    }
    
}
#pragma mark ---收入支出
//收入
-(void)setGet:(UIButton *)sender{
    
    sender.backgroundColor = [UIColor colorWithHexString:MainColor];
    UIButton * btn = [self.view viewWithTag:400];
    btn.backgroundColor = [UIColor colorWithHexString:BackColor];
    _income = 1;
}
-(void)setPay:(UIButton *)sender{
    
    sender.backgroundColor = [UIColor colorWithHexString:MainColor];
    UIButton * btn = [self.view viewWithTag:300];
    
    btn.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _income = 2;
}

#pragma mark ---选择店铺分类
-(void)showStoresPicker{
    
    
    [self.view addSubview:self.pickerBgView];
    
    
    self.maskView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.pickerBgView.frame = CGRectMake(-40, screenH - 300, ScreenW, 300);
    }];
    
}


- (void)hideMyPicker {
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.pickerBgView.frame = CGRectMake(-40, screenH, ScreenW, 300);
        
        self.maskView.hidden = YES;
        
        
    } completion:^(BOOL finished) {
        
        
    }];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return self.dataArray.count;
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return self.dataArray[row][@"type"];
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return 110;
        
    } else {
        
        return 100;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    //
    _className = self.dataArray[row][@"type"];
}

//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        
        [pickerLabel setTextAlignment:1];
        
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)enSure {
    
    UITextField * superClassField = [self.view viewWithTag:120];
    
    superClassField.text = [NSString stringWithFormat:@"%@",_className];
    
    [self hideMyPicker];
}
@end
